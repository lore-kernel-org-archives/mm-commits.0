Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9EAEEAA66
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbjINSwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242224AbjINSvX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:51:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43982134
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:47:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D299C433C8;
        Thu, 14 Sep 2023 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694717239;
        bh=NlVDYsEmeP4znjroY/HlA6n3svC4cDKRRKJetjwCsiQ=;
        h=Date:To:From:Subject:From;
        b=KzuaVUWt6CxGF1/+2zyaNDM2/Zo4MiTeYeDLYGRshYuac90RH+kvh+9+Rk6W33WS2
         8MRGIcOMJpvhojx3+Fm6fgv+eTU7Nnd6t+62Pw14pGSiMnOOYqapChZkrJPGS6DNGZ
         y5Yug44lZMjSZUH5kpitRpvgBBX7+hA0o0lgEN+U=
Date:   Thu, 14 Sep 2023 11:47:18 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_corec-remove-unneeded-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20230914184719.7D299C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_core.c: remove unneeded functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_corec-remove-unneeded-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_corec-remove-unneeded-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: crash_core.c: remove unneeded functions
Date: Thu, 14 Sep 2023 11:31:42 +0800

So far, nobody calls functions parse_crashkernel_high() and
parse_crashkernel_low(), remove both of them.

Link: https://lkml.kernel.org/r/20230914033142.676708-10-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    4 ----
 kernel/crash_core.c        |   18 ------------------
 2 files changed, 22 deletions(-)

--- a/include/linux/crash_core.h~crash_corec-remove-unneeded-functions
+++ a/include/linux/crash_core.h
@@ -96,10 +96,6 @@ void final_note(Elf_Word *buf);
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base,
 		unsigned long long *low_size, bool *high);
-int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
-		unsigned long long *crash_size, unsigned long long *crash_base);
-int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
-		unsigned long long *crash_size, unsigned long long *crash_base);
 
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 #ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
--- a/kernel/crash_core.c~crash_corec-remove-unneeded-functions
+++ a/kernel/crash_core.c
@@ -350,24 +350,6 @@ int __init parse_crashkernel(char *cmdli
 	return ret;
 }
 
-int __init parse_crashkernel_high(char *cmdline,
-			     unsigned long long system_ram,
-			     unsigned long long *crash_size,
-			     unsigned long long *crash_base)
-{
-	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-				suffix_tbl[SUFFIX_HIGH]);
-}
-
-int __init parse_crashkernel_low(char *cmdline,
-			     unsigned long long system_ram,
-			     unsigned long long *crash_size,
-			     unsigned long long *crash_base)
-{
-	return __parse_crashkernel(cmdline, system_ram, crash_size, crash_base,
-				suffix_tbl[SUFFIX_LOW]);
-}
-
 /*
  * Add a dummy early_param handler to mark crashkernel= as a known command line
  * parameter and suppress incorrect warnings in init/main.c.
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

