Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DACC41604
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B692224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709316;
	bh=0HoqqJ7YRmDERxs19bH5cSnqYqP5rwMS2L1q3rBIGhE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oiS0vBtIayOh3A6IzU5M+8K5iLmN3/wIHuggBrm6WPxP/K4g14d3BYUZEmeyTFj7I
	 j4ZF7g69VkI3pUu1piCnxs2RJ173KyfOzgnxr9QnU4264I4cOgMH/z03rn5P9yaKmO
	 Kh/1UVAmPsnlVllR+Viw4Wgv7JErJ4vYFvWbMu5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgJNVBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbgJNVBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB99A20725;
        Wed, 14 Oct 2020 21:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709287;
        bh=0HoqqJ7YRmDERxs19bH5cSnqYqP5rwMS2L1q3rBIGhE=;
        h=Date:From:To:Subject:From;
        b=xNriBB6ALvIaT682zTlmJHP//NX1BIqkndd9+PQM9c7Ah0PUqdL/zfigabDXhKUJF
         UU+mZ5l6MBidgIuF4KXWqpzwppym9CESSZk6glosq3NBY7DGV9wHKlcp+LNc/kfzjv
         XxuOlQzKwSFHpkgQUIOYXU8Vk2v4jHjChDweq7ww=
Date:   Wed, 14 Oct 2020 14:01:26 -0700
From:   akpm@linux-foundation.org
To:     areber@redhat.com, christian.brauner@ubuntu.com,
        christian@kellner.me, cyphar@cyphar.com, ebiederm@xmission.com,
        linmiaohe@huawei.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, shakeelb@google.com, surenb@google.com,
        tglx@linutronix.de
Subject:  [merged]
 mm-use-helper-function-mapping_allow_writable.patch removed from -mm tree
Message-ID: <20201014210126.Pe0zk5sEP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use helper function mapping_allow_writable()
has been removed from the -mm tree.  Its filename was
     mm-use-helper-function-mapping_allow_writable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: use helper function mapping_allow_writable()

Commit 4bb5f5d9395b ("mm: allow drivers to prevent new writable mappings")
changed i_mmap_writable from unsigned int to atomic_t and add the helper
function mapping_allow_writable() to atomic_inc i_mmap_writable.  But it
forgot to use this helper function in dup_mmap() and __vma_link_file().

Link: https://lkml.kernel.org/r/20200917112736.7789-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Kellner <christian@kellner.me>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Adrian Reber <areber@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 mm/mmap.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~mm-use-helper-function-mapping_allow_writable
+++ a/kernel/fork.c
@@ -559,7 +559,7 @@ static __latent_entropy int dup_mmap(str
 				atomic_dec(&inode->i_writecount);
 			i_mmap_lock_write(mapping);
 			if (tmp->vm_flags & VM_SHARED)
-				atomic_inc(&mapping->i_mmap_writable);
+				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_interval_tree_insert_after(tmp, mpnt,
--- a/mm/mmap.c~mm-use-helper-function-mapping_allow_writable
+++ a/mm/mmap.c
@@ -621,7 +621,7 @@ static void __vma_link_file(struct vm_ar
 		if (vma->vm_flags & VM_DENYWRITE)
 			atomic_dec(&file_inode(file)->i_writecount);
 		if (vma->vm_flags & VM_SHARED)
-			atomic_inc(&mapping->i_mmap_writable);
+			mapping_allow_writable(mapping);
 
 		flush_dcache_mmap_lock(mapping);
 		vma_interval_tree_insert(vma, &mapping->i_mmap);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

