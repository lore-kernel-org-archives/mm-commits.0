Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6BCC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjBJAxq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjBJAw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE98B6E9A5
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77463B82399
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1766AC433D2;
        Fri, 10 Feb 2023 00:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990374;
        bh=Lkp6FKONUuEB0IuMdEuxLu5g/RRgGpelvDcNWLkA7o0=;
        h=Date:To:From:Subject:From;
        b=vJiDfnby2sZYurAKfiv31bK5yZhihDhAUxSt8VlJrw1n8W/F5QSS/t4dtb9pyP4YC
         /enTPWS+LisoQaat6XGOJrBKCvYTi82F72ZM+sCMtNgnbajQYEEHHGU4aODDxM/VqW
         m3FkvwPHbosU0Eiva7Ui2Zy5KjYarjJohkCwBxpc=
Date:   Thu, 09 Feb 2023 16:52:53 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-convert-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005254.1766AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched: convert to vma iterator
has been removed from the -mm tree.  Its filename was
     sched-convert-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: sched: convert to vma iterator
Date: Fri, 20 Jan 2023 11:26:23 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-23-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sched/fair.c~sched-convert-to-vma-iterator
+++ a/kernel/sched/fair.c
@@ -2938,11 +2938,11 @@ static void task_numa_work(struct callba
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 	u64 runtime = p->se.sum_exec_runtime;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct vm_area_struct *vma;
 	unsigned long start, end;
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
+	struct vma_iterator vmi;
 
 	SCHED_WARN_ON(p != container_of(work, struct task_struct, numa_work));
 
@@ -2995,16 +2995,16 @@ static void task_numa_work(struct callba
 
 	if (!mmap_read_trylock(mm))
 		return;
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_next(&vmi);
 	if (!vma) {
 		reset_ptenuma_scan(p);
 		start = 0;
-		mas_set(&mas, start);
-		vma = mas_find(&mas, ULONG_MAX);
+		vma_iter_set(&vmi, start);
+		vma = vma_next(&vmi);
 	}
 
-	for (; vma; vma = mas_find(&mas, ULONG_MAX)) {
+	do {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
 			continue;
@@ -3051,7 +3051,7 @@ static void task_numa_work(struct callba
 
 			cond_resched();
 		} while (end != vma->vm_end);
-	}
+	} for_each_vma(vmi, vma);
 
 out:
 	/*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


