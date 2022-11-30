Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5FAC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiK3WwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiK3Wvz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:51:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A9C6034D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 998C961E26
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2377C433D7;
        Wed, 30 Nov 2022 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848713;
        bh=4L1LMTnk11w5RjbW7yi2XwaKRJkrZBBRa1ieDDEN87c=;
        h=Date:To:From:Subject:From;
        b=gzFRbJ8skoA3t0tn0OA+X9yqHOhMW2a5zAU+kJUnWlj4N9KaiqLfnOnrMM13aIi9P
         ErB+ozpgghdK9+/BzKp+vAKOYM0xALPYkU5IgXAkPFcgnDpVjRwARMzof4s9kxsxYm
         1YNJiOJ2C8XuJSczCZ3LikwHcOB541P1bqjm65uc=
Date:   Wed, 30 Nov 2022 14:51:52 -0800
To:     mm-commits@vger.kernel.org, sam@gentoo.org, hns@goldelico.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch removed from -mm tree
Message-Id: <20221130225152.F2377C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: revert "kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible"
has been removed from the -mm tree.  Its filename was
     revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible"
Date: Mon Nov 28 01:21:40 PM PST 2022

It causes build failures with unusual CC/HOSTCC combinations.

Quoting
https://lkml.kernel.org/r/A222B1E6-69B8-4085-AD1B-27BDB72CA971@goldelico.com:

  HOSTCC  scripts/mod/modpost.o - due to target missing
In file included from include/linux/string.h:5,
                 from scripts/mod/../../include/linux/license.h:5,
                 from scripts/mod/modpost.c:24:
include/linux/compiler.h:246:10: fatal error: asm/rwonce.h: No such file or directory
  246 | #include <asm/rwonce.h>
      |          ^~~~~~~~~~~~~~
compilation terminated.

...

The problem is that HOSTCC is not necessarily the same compiler or even
architecture as CC and pulling in <linux/compiler.h> or <asm/rwonce.h>
files indirectly isn't a good idea then.

My toolchain is providing HOSTCC = gcc (MacPorts) and CC = arm-linux-gnueabihf
(built from gcc source) and all running on Darwin.

If I change the include to <string.h> I can then "HOSTCC scripts/mod/modpost.c"
but then it fails for "CC kernel/module/main.c" not finding <string.h>:

  CC      kernel/module/main.o - due to target missing
In file included from kernel/module/main.c:43:0:
./include/linux/license.h:5:20: fatal error: string.h: No such file or directory
 #include <string.h>
                    ^
compilation terminated.

Reported-by: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Sam James <sam@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/license.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/license.h~revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible
+++ a/include/linux/license.h
@@ -2,8 +2,6 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
-#include <linux/string.h>
-
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

