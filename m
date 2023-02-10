Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36924C636D6
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjBJAzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjBJAyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1881721E4
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63CC9B8239B
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7F1C4339B;
        Fri, 10 Feb 2023 00:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990410;
        bh=1+nPCnHLiu6UIRThXoLFZ/zJrKbgASbNyloNDXArDkA=;
        h=Date:To:From:Subject:From;
        b=0aU+Eiher3KpDYfAQ8tvYm3e8PTIDv90LmFCh1lPxhFfL/5rPaEgnQyWpbT24y92T
         qk/03fps5S6yGMmFNC908yGyligy/7nql5X8pFutbUByWqQx5Q755WzPATmyyJYQMp
         f/mXDNODlU15uzZOUMtF2l+hpBz8bWTSR0paGM5A=
Date:   Thu, 09 Feb 2023 16:53:29 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-introduce-dup_vma_anon-helper.patch removed from -mm tree
Message-Id: <20230210005330.1F7F1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: introduce dup_vma_anon() helper
has been removed from the -mm tree.  Its filename was
     mm-mmap-introduce-dup_vma_anon-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: introduce dup_vma_anon() helper
Date: Fri, 20 Jan 2023 11:26:47 -0500

Create a helper for duplicating the anon vma when adjusting the vma.  This
simplifies the logic of __vma_adjust().

Link: https://lkml.kernel.org/r/20230120162650.984577-47-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   74 ++++++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-dup_vma_anon-helper
+++ a/mm/mmap.c
@@ -618,6 +618,29 @@ again:
 }
 
 /*
+ * dup_anon_vma() - Helper function to duplicate anon_vma
+ * @dst: The destination VMA
+ * @src: The source VMA
+ *
+ * Returns: 0 on success.
+ */
+static inline int dup_anon_vma(struct vm_area_struct *dst,
+			       struct vm_area_struct *src)
+{
+	/*
+	 * Easily overlooked: when mprotect shifts the boundary, make sure the
+	 * expanding vma has anon_vma set if the shrinking vma had, to cover any
+	 * anon pages imported.
+	 */
+	if (src->anon_vma && !dst->anon_vma) {
+		dst->anon_vma = src->anon_vma;
+		return anon_vma_clone(dst, src);
+	}
+
+	return 0;
+}
+
+/*
  * vma_expand - Expand an existing VMA
  *
  * @vmi: The vma iterator
@@ -642,15 +665,12 @@ int vma_expand(struct vma_iterator *vmi,
 	struct vma_prepare vp;
 
 	if (next && (vma != next) && (end == next->vm_end)) {
-		remove_next = true;
-		if (next->anon_vma && !vma->anon_vma) {
-			int error;
+		int ret;
 
-			vma->anon_vma = next->anon_vma;
-			error = anon_vma_clone(vma, next);
-			if (error)
-				return error;
-		}
+		remove_next = true;
+		ret = dup_anon_vma(vma, next);
+		if (ret)
+			return ret;
 	}
 
 	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
@@ -739,10 +759,11 @@ int __vma_adjust(struct vma_iterator *vm
 	struct file *file = vma->vm_file;
 	bool vma_changed = false;
 	long adjust_next = 0;
-	struct vm_area_struct *exporter = NULL, *importer = NULL;
 	struct vma_prepare vma_prep;
 
 	if (next) {
+		int error = 0;
+
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -777,15 +798,14 @@ int __vma_adjust(struct vma_iterator *vm
 					   end != remove2->vm_end);
 			}
 
-			exporter = next;
-			importer = vma;
-
 			/*
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove2 != NULL && !next->anon_vma)
-				exporter = remove2;
+			if (remove != NULL && !next->anon_vma)
+				error = dup_anon_vma(vma, remove2);
+			else
+				error = dup_anon_vma(vma, remove);
 
 		} else if (end > next->vm_start) {
 			/*
@@ -793,9 +813,8 @@ int __vma_adjust(struct vma_iterator *vm
 			 * mprotect case 5 shifting the boundary up.
 			 */
 			adjust_next = (end - next->vm_start);
-			exporter = next;
-			importer = vma;
-			VM_WARN_ON(expand != importer);
+			VM_WARN_ON(expand != vma);
+			error = dup_anon_vma(vma, next);
 		} else if (end < vma->vm_end) {
 			/*
 			 * vma shrinks, and !insert tells it's not
@@ -803,24 +822,11 @@ int __vma_adjust(struct vma_iterator *vm
 			 * mprotect case 4 shifting the boundary down.
 			 */
 			adjust_next = -(vma->vm_end - end);
-			exporter = vma;
-			importer = next;
-			VM_WARN_ON(expand != importer);
-		}
-
-		/*
-		 * Easily overlooked: when mprotect shifts the boundary,
-		 * make sure the expanding vma has anon_vma set if the
-		 * shrinking vma had, to cover any anon pages imported.
-		 */
-		if (exporter && exporter->anon_vma && !importer->anon_vma) {
-			int error;
-
-			importer->anon_vma = exporter->anon_vma;
-			error = anon_vma_clone(importer, exporter);
-			if (error)
-				return error;
+			VM_WARN_ON(expand != next);
+			error = dup_anon_vma(next, vma);
 		}
+		if (error)
+			return error;
 	}
 
 	if (vma_iter_prealloc(vmi))
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


