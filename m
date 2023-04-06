Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2B9C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbjDFDEP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjDFDDv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE58E93F9
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFF4762D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDCBC433EF;
        Thu,  6 Apr 2023 03:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750220;
        bh=On5jggQ+9YtxbFCQhTRJo65LJDWQdtyzHSpor+dpUcY=;
        h=Date:To:From:Subject:From;
        b=dXw+0+c8C2SPgFH514CSNSTIFNsH638+Yed4Cn9SA74fo4Y/zIBgZN+kwlz7lEU5b
         NH6D22RU/A8ykjsl4z+rhnfxwNL3J+h3JjFLbfekdEtEYJphZ4qyRjG+XhG6sYcsnB
         ea5gGfnwE5mXppzBiAb1gUCwcMuXAbf/3X4eTKOU=
Date:   Wed, 05 Apr 2023 20:03:39 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        sfr@canb.auug.org.au, pasha.tatashin@soleen.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        laurent.dufour@fr.ibm.com, jgg@ziepe.ca, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch removed from -mm tree
Message-Id: <20230406030340.1EDCBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: write-lock VMAs in vma_prepare before modifying them
has been removed from the -mm tree.  Its filename was
     mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: write-lock VMAs in vma_prepare before modifying them
Date: Mon, 27 Feb 2023 09:36:15 -0800

Write-lock all VMAs which might be affected by a merge, split, expand or
shrink operations.  All these operations use vma_prepare() before making
the modifications, therefore it provides a centralized place to perform
VMA locking.

[surenb@google.com: remove unnecessary vp->vma check in vma_prepare]
  Link: https://lkml.kernel.org/r/20230301022720.1380780-1-surenb@google.com
  Link: https://lore.kernel.org/r/202302281802.J93Nma7q-lkp@intel.com/
Link: https://lkml.kernel.org/r/20230227173632.3292573-17-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Laurent Dufour <laurent.dufour@fr.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/mmap.c~mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them
+++ a/mm/mmap.c
@@ -502,6 +502,15 @@ static inline void init_vma_prep(struct
  */
 static inline void vma_prepare(struct vma_prepare *vp)
 {
+	vma_start_write(vp->vma);
+	if (vp->adj_next)
+		vma_start_write(vp->adj_next);
+	/* vp->insert is always a newly created VMA, no need for locking */
+	if (vp->remove)
+		vma_start_write(vp->remove);
+	if (vp->remove2)
+		vma_start_write(vp->remove2);
+
 	if (vp->file) {
 		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
 
_

Patches currently in -mm which might be from surenb@google.com are


