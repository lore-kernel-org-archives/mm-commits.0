Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC3EC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjBJAy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBJAxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7686F8E7
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A88D561B7A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A270C433D2;
        Fri, 10 Feb 2023 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990392;
        bh=2DX6wbwFR/KQKgYT2lk0nW5IqCMG2nrDJtK059PljkY=;
        h=Date:To:From:Subject:From;
        b=VSSnYp2IuG6hG3ej7s0GzB8SC77hDBQ5qV/0eYXHlWcm8hO8P74Jn0RF5nkVmTSWX
         3N1uSGdScfIgc2Qkn1wLCWPgBkjq6gK0TjbkZArE31xciKhoxs12RA4H7C9wPSq649
         bKda+2z/IJ7aOzAeC22Ko2XUatfVTbR4s8mZFx9k=
Date:   Thu, 09 Feb 2023 16:53:11 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch removed from -mm tree
Message-Id: <20230210005312.0A270C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unnecessary write to vma iterator in __vma_adjust()
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: remove unnecessary write to vma iterator in __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:35 -0500

If the vma start address is going to change due to an insert, then it is
safe to not write the vma to the tree.  The write of the insert vma will
alter the tree as necessary.

Link: https://lkml.kernel.org/r/20230120162650.984577-35-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust
+++ a/mm/mmap.c
@@ -719,10 +719,12 @@ int __vma_adjust(struct vma_iterator *vm
 	}
 
 	if (start != vma->vm_start) {
-		if ((vma->vm_start < start) &&
-		    (!insert || (insert->vm_end != start))) {
-			vma_iter_clear(vmi, vma->vm_start, start);
-			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
+		if (vma->vm_start < start) {
+			if (!insert || (insert->vm_end != start)) {
+				vma_iter_clear(vmi, vma->vm_start, start);
+				vma_iter_set(vmi, start);
+				VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
+			}
 		} else {
 			vma_changed = true;
 		}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


