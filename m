Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34199C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiI0Cvs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704096C113
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D890B81906
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA073C433D7;
        Tue, 27 Sep 2022 02:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246935;
        bh=P4o+sodjiaQHbh7sQSpDJfza73Hr2SHA2pitxOv23dQ=;
        h=Date:To:From:Subject:From;
        b=D84cUcExBrGzPPNJPUa4hlVZRHWtBEo2/x2tudxqCi03crMmbG60AcIvOvbhTWPWP
         pxI9NAmXB3nFy7qv7+kmz/4o0yEA1xPTj1HUTaDuiszWHdznVEFgsXUKu9lnaJ1rpa
         NtPCBRFUxQGGzkfZVW+LxczgodXZE8I5Chmnn87U=
Date:   Mon, 26 Sep 2022 19:48:55 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch removed from -mm tree
Message-Id: <20220927024855.CA073C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: change zeroing of maple tree in __vma_adjust()
has been removed from the -mm tree.  Its filename was
     mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: change zeroing of maple tree in __vma_adjust()
Date: Tue, 6 Sep 2022 19:48:49 +0000

Only write to the maple tree if we are not inserting or the insert isn't
going to overwrite the area to clear.  This avoids spanning writes and
node coealescing when unnecessary.

The change requires a custom search for the linked list addition to find
the correct VMA for the prev link.

Link: https://lkml.kernel.org/r/20220906194824.2110408-19-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mmap-change-zeroing-of-maple-tree-in-__vma_adjust
+++ a/mm/mmap.c
@@ -567,11 +567,11 @@ static int vma_link(struct mm_struct *mm
  * mm's list and the mm tree.  It has already been inserted into the interval tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct ma_state *mas,
-			       struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned long location)
 {
 	struct vm_area_struct *prev;
 
-	mas_set(mas, vma->vm_start);
+	mas_set(mas, location);
 	prev = mas_prev(mas, 0);
 	vma_mas_store(vma, mas);
 	__vma_link_list(mm, vma, prev);
@@ -601,6 +601,7 @@ int __vma_adjust(struct vm_area_struct *
 	int remove_next = 0;
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
+	unsigned long ll_prev = vma->vm_start; /* linked list prev. */
 
 	if (next && !insert) {
 		if (end >= next->vm_end) {
@@ -728,15 +729,27 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (start != vma->vm_start) {
-		if (vma->vm_start < start)
+		if ((vma->vm_start < start) &&
+		    (!insert || (insert->vm_end != start))) {
 			vma_mas_szero(&mas, vma->vm_start, start);
-		vma_changed = true;
+			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
+		} else {
+			vma_changed = true;
+		}
 		vma->vm_start = start;
 	}
 	if (end != vma->vm_end) {
-		if (vma->vm_end > end)
-			vma_mas_szero(&mas, end, vma->vm_end);
-		vma_changed = true;
+		if (vma->vm_end > end) {
+			if (!insert || (insert->vm_start != end)) {
+				vma_mas_szero(&mas, end, vma->vm_end);
+				VM_WARN_ON(insert &&
+					   insert->vm_end < vma->vm_end);
+			} else if (insert->vm_start == end) {
+				ll_prev = vma->vm_end;
+			}
+		} else {
+			vma_changed = true;
+		}
 		vma->vm_end = end;
 		if (!next)
 			mm->highest_vm_end = vm_end_gap(vma);
@@ -783,7 +796,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		__insert_vm_struct(mm, &mas, insert);
+		__insert_vm_struct(mm, &mas, insert, ll_prev);
 	}
 
 	if (anon_vma) {
@@ -870,6 +883,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
+	mas_destroy(&mas);
 	validate_mm(mm);
 	return 0;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


