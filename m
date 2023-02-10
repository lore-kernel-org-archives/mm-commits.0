Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F05C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjBJAxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjBJAww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32E66E995
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E1A661C32
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F29C433EF;
        Fri, 10 Feb 2023 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990369;
        bh=a1wmJRyEU5CFiO8gHqxuzCbEe8Cc5TC5MWoer2M+cwM=;
        h=Date:To:From:Subject:From;
        b=OmSK2NkynU8/hlNePlJamzwlxCwZen58g5/jEURPUN4An+ZcigF5npPEod2/Wy9Q4
         0XR2xE1Y5AOPnIy+tkveZVk6BWg95IxDH2Ks9r1FfaY5I38gKzyJ0VknrwaC3ORs5G
         7SpPzUMV3zfyBl7C5YD4TbEc8YUc1pBW10dqpBJU=
Date:   Thu, 09 Feb 2023 16:52:49 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] coredump-convert-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005249.A3F29C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: coredump: convert to vma iterator
has been removed from the -mm tree.  Its filename was
     coredump-convert-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: coredump: convert to vma iterator
Date: Fri, 20 Jan 2023 11:26:20 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-20-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/coredump.c~coredump-convert-to-vma-iterator
+++ a/fs/coredump.c
@@ -1111,14 +1111,14 @@ whole:
  * Helper function for iterating across a vma list.  It ensures that the caller
  * will visit `gate_vma' prior to terminating the search.
  */
-static struct vm_area_struct *coredump_next_vma(struct ma_state *mas,
+static struct vm_area_struct *coredump_next_vma(struct vma_iterator *vmi,
 				       struct vm_area_struct *vma,
 				       struct vm_area_struct *gate_vma)
 {
 	if (gate_vma && (vma == gate_vma))
 		return NULL;
 
-	vma = mas_next(mas, ULONG_MAX);
+	vma = vma_next(vmi);
 	if (vma)
 		return vma;
 	return gate_vma;
@@ -1146,7 +1146,7 @@ static bool dump_vma_snapshot(struct cor
 {
 	struct vm_area_struct *gate_vma, *vma = NULL;
 	struct mm_struct *mm = current->mm;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 	int i = 0;
 
 	/*
@@ -1167,7 +1167,7 @@ static bool dump_vma_snapshot(struct cor
 		return false;
 	}
 
-	while ((vma = coredump_next_vma(&mas, vma, gate_vma)) != NULL) {
+	while ((vma = coredump_next_vma(&vmi, vma, gate_vma)) != NULL) {
 		struct core_vma_metadata *m = cprm->vma_meta + i;
 
 		m->start = vma->vm_start;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


