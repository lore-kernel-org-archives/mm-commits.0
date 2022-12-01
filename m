Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50375C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLAARz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLAARD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100B899505
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACD3EB81D96
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C04C433D6;
        Thu,  1 Dec 2022 00:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853641;
        bh=GxMkPpP8hITQRnUADvi5ldeoeGanIre00WThIEHCErc=;
        h=Date:To:From:Subject:From;
        b=yShzkMkpOegmaxO8he5WTNn5e0QrcBku8gERlCpf6vh3j7+bUHkC+pTjTApSfBc+X
         72RyR2nnLvUDUOVcGi8mcW/qEZokyIMaFCxKDj7/577/9v892U2Nocgon45WvFIYiG
         hi5pYljsV2Xay87/DF0sjGIIKCThpAkUihsUcYl8=
Date:   Wed, 30 Nov 2022 16:14:00 -0800
To:     mm-commits@vger.kernel.org, yijiangshan@kylinos.cn,
        samitolvanen@google.com, rdunlap@infradead.org,
        peterz@infradead.org, keescook@chromium.org, masahiroy@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch removed from -mm tree
Message-Id: <20221201001401.49C04C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: linux/init.h: include <linux/build_bug.h> and <linux/stringify.h>
has been removed from the -mm tree.  Its filename was
     linux-inith-include-linux-build_bugh-and-linux-stringifyh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: linux/init.h: include <linux/build_bug.h> and <linux/stringify.h>
Date: Sun, 13 Nov 2022 20:08:02 +0900

With CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y, the following code fails to
build:

  ---------------->8----------------
  #include <linux/init.h>

  int foo(void) { return 0; }
  core_initcall(foo);
  ---------------->8----------------

Include <linux/build_bug.h> for static_assert() and <linux/stringify.h>
for __stringify().

Link: https://lkml.kernel.org/r/20221113110802.3760705-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/init.h~linux-inith-include-linux-build_bugh-and-linux-stringifyh
+++ a/include/linux/init.h
@@ -2,7 +2,9 @@
 #ifndef _LINUX_INIT_H
 #define _LINUX_INIT_H
 
+#include <linux/build_bug.h>
 #include <linux/compiler.h>
+#include <linux/stringify.h>
 #include <linux/types.h>
 
 /* Built-in __init functions needn't be compiled with retpoline */
_

Patches currently in -mm which might be from masahiroy@kernel.org are


