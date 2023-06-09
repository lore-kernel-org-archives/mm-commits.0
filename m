Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C6EC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjFIXLb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjFIXLa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:11:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4BC2733
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F08C65CB2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC52C433D2;
        Fri,  9 Jun 2023 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352288;
        bh=TAM/UmavAagtj4+Q8T1Rfy1MAqsv1FdVf34lW1r174A=;
        h=Date:To:From:Subject:From;
        b=Zb149hQCLsZFVuh6DcgsTqL3W8oibSEPbtmXIHK86ALPcP7FSUZV+i5YMqGABALDH
         eLjJpqbY+krADkLMEkLOEUiAs4QO7L8c96qbhS8ttC8gALgcq8k5Xar6DxeC0JKd7j
         tVncqm49590aZ3tdCNjiYxlpsELCAJAuIvcwJ/hw=
Date:   Fri, 09 Jun 2023 16:11:27 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        wenyang.linux@foxmail.com, wefu@redhat.com, pintu@codeaurora.org,
        osalvador@suse.de, mgorman@techsingularity.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch removed from -mm tree
Message-Id: <20230609231128.5EC52C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch

This patch was dropped because it was folded into mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
Date: Tue May  2 01:47:48 PM PDT 2023

add __read_mostly, per Mel

Cc: Fu Wei <wefu@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Cc: William Lam <william.lam@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix
+++ a/mm/compaction.c
@@ -1736,7 +1736,7 @@ static int sysctl_compact_unevictable_al
  */
 static unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 static int sysctl_extfrag_threshold = 500;
-static int sysctl_compact_memory;
+static int __read_mostly sysctl_compact_memory;
 
 static inline void
 update_fast_start_pfn(struct compact_control *cc, unsigned long pfn)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote-fix.patch
selftests-mm-gup_longterm-new-functional-test-for-foll_longterm-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

