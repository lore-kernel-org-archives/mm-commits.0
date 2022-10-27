Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC54FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 19:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ0TOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiJ0TOW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 15:14:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BDA71BC9
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 12:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC21DB82768
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81663C433C1;
        Thu, 27 Oct 2022 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666898057;
        bh=Q+X9x1MLIveK9hiHtzOXIx+gykwWh3iBGc7JB1t5N7Y=;
        h=Date:To:From:Subject:From;
        b=Frnseo0i8d0B5Bjgs24ccNbLKBQop8h0A6kS8fQeMNlv2vLDVDxEHiMDQWRVAmAfW
         eED4XnOBy4+Xpw5FFBkK79s/JBHSk+GPwI+CXPrL76JczcY+2nsutRQAEqAViFwKgZ
         MlixYC+2vUDNzMRyx8BLKJW6BwPczwBdUR4pBJ7Y=
Date:   Thu, 27 Oct 2022 12:14:16 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        willy@infradead.org, vbabka@suse.cz, ke.wang@unisoc.com,
        huangzhaoyang@gmail.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20221027191417.81663C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
Date: Thu Oct 27 12:12:56 PM PDT 2022

WARNING: please, no spaces at the start of a line
#59: FILE: mm/kmemleak.c:362:
+       for (i = 0; i < nr_entries; i++) {$

WARNING: suspect code indent for conditional statements (7, 15)
#59: FILE: mm/kmemleak.c:362:
+       for (i = 0; i < nr_entries; i++) {
+               void *ptr = (void *)entries[i];

ERROR: code indent should use tabs where possible
#60: FILE: mm/kmemleak.c:363:
+               void *ptr = (void *)entries[i];$

WARNING: please, no spaces at the start of a line
#60: FILE: mm/kmemleak.c:363:
+               void *ptr = (void *)entries[i];$

ERROR: code indent should use tabs where possible
#61: FILE: mm/kmemleak.c:364:
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);$

WARNING: Missing a blank line after declarations
#61: FILE: mm/kmemleak.c:364:
+               void *ptr = (void *)entries[i];
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);

WARNING: please, no spaces at the start of a line
#61: FILE: mm/kmemleak.c:364:
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);$

WARNING: please, no spaces at the start of a line
#62: FILE: mm/kmemleak.c:365:
+       }$

ERROR: space required before the open parenthesis '('
#71: FILE: mm/kmemleak.c:384:
+	if(object->trace_handle)

total: 3 errors, 6 warnings, 107 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
+++ a/mm/kmemleak.c
@@ -359,10 +359,10 @@ static void print_unreferenced(struct se
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
-       for (i = 0; i < nr_entries; i++) {
-               void *ptr = (void *)entries[i];
-               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
-       }
+	for (i = 0; i < nr_entries; i++) {
+		void *ptr = (void *)entries[i];
+		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+	}
 }
 
 /*
@@ -381,7 +381,7 @@ static void dump_object_info(struct kmem
 	pr_notice("  flags = 0x%x\n", object->flags);
 	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
-	if(object->trace_handle)
+	if (object->trace_handle)
 		stack_depot_print(object->trace_handle);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-msgc-fix-percpu_counter-use-after-free.patch
fs-ext4-superc-remove-unused-deprecated_msg.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

