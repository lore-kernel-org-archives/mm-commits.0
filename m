Return-Path: <SRS0=50af=CO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8020BC43461
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E03420796
	for <mm-commits@archiver.kernel.org>; Sat,  5 Sep 2020 20:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599338326;
	bh=XK1IUXaY0CkG+KiMNC5xKy7G5sH7YtOlfv4eQ0M7nJA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CZE6jogoX9/1eaXlmLRV8c479Q3zP3FET0n17xDJEezyjt5BMr6BFZBWtWvBg8pR2
	 LKpmNEol3v5L+WSiYx2usR5LGP/tKchv8VSQNSXUTnBfqTIBMz9hQ9ZJjbK+cEEhtn
	 2/c+8Rju2JuiJXzmdRrOVrvZL/3VJUTLj84pFR6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIEUiq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUip (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 5 Sep 2020 16:38:45 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE29020760;
        Sat,  5 Sep 2020 20:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599338324;
        bh=XK1IUXaY0CkG+KiMNC5xKy7G5sH7YtOlfv4eQ0M7nJA=;
        h=Date:From:To:Subject:From;
        b=hnz4DrGbknecFu0pNzyKZog3yqqkMQgCI9kBybAGxq5my1XUk4ooJoJM8awxanb57
         fvkGjiwz6i8+OC4hGEsBsz42qJaWc+VrSWIZvfIMvRY4dYiOAXVwjd6vfsJE3xlJvj
         Fie5e05vGA7JizMmGtguJP/MfowR3Z2+u0yKAZss=
Date:   Sat, 05 Sep 2020 13:38:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org
Subject:  +
 checkpatch-warn-on-self-assignments-checkpatch-fixes.patch added to -mm tree
Message-ID: <20200905203843.cOnnE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-warn-on-self-assignments-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-self-assignments-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-self-assignments-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-warn-on-self-assignments-checkpatch-fixes

WARNING: Unknown commit id '63a0895d960a', maybe rebased or not pulled?
#4: 
The uninitialized_var() macro was removed recently via commit 63a0895d960a

WARNING: 'assigments' may be misspelled - perhaps 'assignments'?
#30: FILE: scripts/checkpatch.pl:3904:
+# check for self assigments used to avoid compiler warnings

total: 0 errors, 2 warnings, 17 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/checkpatch-warn-on-self-assignments.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-warn-on-self-assignments-checkpatch-fixes
+++ a/scripts/checkpatch.pl
@@ -3901,7 +3901,7 @@ sub process {
 #ignore lines not being added
 		next if ($line =~ /^[^\+]/);
 
-# check for self assigments used to avoid compiler warnings
+# check for self assignments used to avoid compiler warnings
 # e.g.:	int foo = foo, *bar = NULL;
 #	struct foo bar = *(&(bar));
 		if ($line =~ /^\+\s*(?:$Declare)?([A-Za-z_][A-Za-z\d_]*)\s*=/) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

