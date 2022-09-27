Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054BBC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiI0Cwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiI0Cu5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565ACFA0F4
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15456615A3
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DA3C433D6;
        Tue, 27 Sep 2022 02:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246946;
        bh=7/qJttqGK4xGliZy09y4rjRYhGUFkK7dGzDRpWdJO9k=;
        h=Date:To:From:Subject:From;
        b=XI/VnJV3xWxdc5tE0nUqrSGNyMMoNBENPADVgIcT0nNmAjPijNccPJ+BF7sWzBXii
         FFleOECS9l4RsshoPTasAmTJE7rhuK70U/aob90M96k+Hy8ozAosRxRYMRukuV7zxF
         WwdFboUhEBLrUvvE30b0zZtYPAjXyDefymTAoQMM=
Date:   Mon, 26 Sep 2022 19:49:05 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-vma_lookup-to-use-mtree_load.patch removed from -mm tree
Message-Id: <20220927024906.67DA3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert vma_lookup() to use mtree_load()
has been removed from the -mm tree.  Its filename was
     mm-convert-vma_lookup-to-use-mtree_load.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: convert vma_lookup() to use mtree_load()
Date: Tue, 6 Sep 2022 19:48:51 +0000

Unlike the rbtree, the Maple Tree will return a NULL if there's nothing at
a particular address.

Since the previous commit dropped the vmacache, it is now possible to
consult the tree directly.

Link: https://lkml.kernel.org/r/20220906194824.2110408-27-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-convert-vma_lookup-to-use-mtree_load
+++ a/include/linux/mm.h
@@ -2795,12 +2795,7 @@ struct vm_area_struct *find_vma_intersec
 static inline
 struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma = find_vma(mm, addr);
-
-	if (vma && addr < vma->vm_start)
-		vma = NULL;
-
-	return vma;
+	return mtree_load(&mm->mm_mt, addr);
 }
 
 static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


