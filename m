Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2921CC4321E
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 21:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbiK1VYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiK1VYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 16:24:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97510FC3
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 13:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8EE3B80E9A
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 21:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92977C433C1;
        Mon, 28 Nov 2022 21:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669670672;
        bh=+dzBnjvBX9nom+sLEzXhFQyfwdPbJ6bcLi7HUdbZ7Gg=;
        h=Date:To:From:Subject:From;
        b=2Mo94AHJGT35lFmg9ojEXbYrWk2LwoQebbs59c35zdAPeThh3+6T5v3pJo4HHv2P4
         FWwaj16XQCWcSZGXw+NcJS1Y5+zvWbEigTKr4ayIs9VXKqsTcA7aEfg6hOmLZ2V3IC
         TPP8J26AoPRaDZ0/sWqmUAh6jDxtkoKqu64kTopc=
Date:   Mon, 28 Nov 2022 13:24:31 -0800
To:     mm-commits@vger.kernel.org, sam@gentoo.org, hns@goldelico.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch added to mm-hotfixes-unstable branch
Message-Id: <20221128212432.92977C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Reportd-by: "H. Nikolaus Schaller" <hns@goldelico.com>
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

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch
revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

