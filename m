Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5869C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbjDFCpV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbjDFCoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C0C768F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEB8964222
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ECBC433EF;
        Thu,  6 Apr 2023 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749093;
        bh=I8SiUYpdFmLATlnTTpa/d2t5qHb68xaQlOBay+0HaFM=;
        h=Date:To:From:Subject:From;
        b=LBLOOkTzWM5f8CDY8pDlgjh9GGmfBiuaQtIU1SIvTzDPu/OqJWs23cFUEKESc0yg3
         O4RkJtXr7d93FHDhN7trTirJXax1eKGjc55SFgkIEyWIO48PgIMf000kOmBJMnvz3Q
         dKWMS5xUDnZ9z77G/ZDBRaV+omXQTnS/Zv+Ba3eE=
Date:   Wed, 05 Apr 2023 19:44:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch removed from -mm tree
Message-Id: <20230406024453.15ECBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: initialize mid and next in natural order
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: initialize mid and next in natural order
Date: Thu, 9 Mar 2023 12:12:53 +0100

It is more intuitive to go from prev to mid and then next.  No functional
change.

Link: https://lkml.kernel.org/r/20230309111258.24079-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order
+++ a/mm/mmap.c
@@ -912,10 +912,11 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	next = find_vma(mm, prev ? prev->vm_end : 0);
-	mid = next;
-	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
-		next = find_vma(mm, next->vm_end);
+	mid = find_vma(mm, prev ? prev->vm_end : 0);
+	if (mid && mid->vm_end == end)			/* cases 6, 7, 8 */
+		next = find_vma(mm, mid->vm_end);
+	else
+		next = mid;
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

