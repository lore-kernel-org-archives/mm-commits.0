Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8EEC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbjDFDER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbjDFDDw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B719A975E
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A4964218
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB428C433EF;
        Thu,  6 Apr 2023 03:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750222;
        bh=cE3JIshJpFxLp7xumY5oYYkVk7Kn1qJM2r+xyTkVkXo=;
        h=Date:To:From:Subject:From;
        b=i+elttA6Bcf6B/wtB7i74t7S/lNAEVBaNCZoRBRzlGT8wGPGMYxRlJkqddRs3RPfc
         YfY1KAQJwjDmbmzzIWgjkQ/z6osZLaoHmb8ISI33W3BK5hhvCLV14jGQ1P+qANv+4c
         2VTkVvOpHF57e6RoU+j+eDN9aWJqbJU+3CwBC3e8=
Date:   Wed, 05 Apr 2023 20:03:42 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, 42.hyeyoo@gmail.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-write-lock-vmas-before-removing-them-from-vma-tree.patch removed from -mm tree
Message-Id: <20230406030342.AB428C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: write-lock VMAs before removing them from VMA tree
has been removed from the -mm tree.  Its filename was
     mm-write-lock-vmas-before-removing-them-from-vma-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: write-lock VMAs before removing them from VMA tree
Date: Mon, 27 Feb 2023 09:36:17 -0800

Write-locking VMAs before isolating them ensures that page fault handlers
don't operate on isolated VMAs.

[surenb@google.com: mm/nommu: remove unnecessary VMA locking]
  Link: https://lkml.kernel.org/r/20230301190457.1498985-1-surenb@google.com
  Link: https://lore.kernel.org/all/Y%2F8CJQGNuMUTdLwP@localhost/
Link: https://lkml.kernel.org/r/20230227173632.3292573-19-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-write-lock-vmas-before-removing-them-from-vma-tree
+++ a/mm/mmap.c
@@ -2270,6 +2270,7 @@ int split_vma(struct vma_iterator *vmi,
 static inline int munmap_sidetree(struct vm_area_struct *vma,
 				   struct ma_state *mas_detach)
 {
+	vma_start_write(vma);
 	mas_set_range(mas_detach, vma->vm_start, vma->vm_end - 1);
 	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
 		return -ENOMEM;
_

Patches currently in -mm which might be from surenb@google.com are


