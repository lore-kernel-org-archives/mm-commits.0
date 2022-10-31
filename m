Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E96FA3746
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJaXYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJaXYX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 19:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0773A15826
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 16:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 972E0614F4
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 23:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA79FC433D6;
        Mon, 31 Oct 2022 23:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667258662;
        bh=0UuKzHuCZXXC2qnr4uh647SJMiz/aW2+5ls4JAbWui4=;
        h=Date:To:From:Subject:From;
        b=nuIkG2CaC8Z4kNLc1C74ToVCqCGF1FLwhK8DafcL0t8/LCMgU5Y2higtm9+dmSdol
         ALznr/IofXTbppKt+u7ykH1+IQJ8EGbByD/Z/9OV+68+LGJu+55PsY+WGeG2Utswl1
         vazTQKLh4fzhnF3jg6/AEhEP+RxMW6Ysu+cN7D/I=
Date:   Mon, 31 Oct 2022 16:24:21 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        huangzhaoyang@gmail.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch added to mm-unstable branch
Message-Id: <20221031232421.EA79FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch

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
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
Date: Mon Oct 31 04:23:03 PM PDT 2022

fix v3 layout oddities

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix
+++ a/mm/kmemleak.c
@@ -343,7 +343,7 @@ static bool unreferenced_object(struct k
  * print_unreferenced function must be called with the object->lock held.
  */
 static void print_unreferenced(struct seq_file *seq,
-		struct kmemleak_object *object)
+			       struct kmemleak_object *object)
 {
 	int i;
 	unsigned long *entries;
@@ -352,10 +352,10 @@ static void print_unreferenced(struct se
 
 	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
-			object->pointer, object->size);
+			  object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
-			object->comm, object->pid, object->jiffies,
-			msecs_age / 1000, msecs_age % 1000);
+			   object->comm, object->pid, object->jiffies,
+			   msecs_age / 1000, msecs_age % 1000);
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing-fix.patch
maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

