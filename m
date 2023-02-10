Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9146DC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjBJAys (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjBJAxz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49B97096C
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E18AB82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA277C433D2;
        Fri, 10 Feb 2023 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990399;
        bh=s+zqGA7nI9A/4nFQkdLv1+8EjjdleN2GLvLdCyVwp50=;
        h=Date:To:From:Subject:From;
        b=Toxv9ddOzwh06ykbMR138SeAPK6B73NofPs9d9kLmepeg3QAvnjimfUe75KtYdG09
         Um9TkjHH1T31SZJXOwVG2QkFm+epk2yNCmJpnF3tKnWJExpFf+QS2hjLXrdBKu5vaX
         zKZGCuZ26kBEaHEB3BqCBDu/k71ufZFLbmnlIQeQ=
Date:   Thu, 09 Feb 2023 16:53:19 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch removed from -mm tree
Message-Id: <20230210005319.DA277C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: move anon_vma setting in __vma_adjust()
has been removed from the -mm tree.  Its filename was
     mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: move anon_vma setting in __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:40 -0500

Move the anon_vma setting & warn_no up the function.  This is done to
clear up the locking later.

Link: https://lkml.kernel.org/r/20230120162650.984577-40-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-move-anon_vma-setting-in-__vma_adjust
+++ a/mm/mmap.c
@@ -682,6 +682,14 @@ int __vma_adjust(struct vma_iterator *vm
 	if (vma_iter_prealloc(vmi))
 		return -ENOMEM;
 
+	anon_vma = vma->anon_vma;
+	if (!anon_vma && adjust_next)
+		anon_vma = next->anon_vma;
+
+	if (anon_vma)
+		VM_WARN_ON(adjust_next && next->anon_vma &&
+			   anon_vma != next->anon_vma);
+
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 	if (file) {
 		mapping = file->f_mapping;
@@ -703,12 +711,7 @@ int __vma_adjust(struct vma_iterator *vm
 		}
 	}
 
-	anon_vma = vma->anon_vma;
-	if (!anon_vma && adjust_next)
-		anon_vma = next->anon_vma;
 	if (anon_vma) {
-		VM_WARN_ON(adjust_next && next->anon_vma &&
-			   anon_vma != next->anon_vma);
 		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vma);
 		if (adjust_next)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


