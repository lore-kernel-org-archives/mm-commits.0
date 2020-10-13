Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6A1C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9083C21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633253;
	bh=eZx/+p9pjZeGQMZf+/wF0I2y51pqHOUQEod/u8TRQ14=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jBu6gu5AWjgcCgEG5wUqrXg92fccPIeYI+i1Da8DL5jYXi0P3NcfrtHRtS+9kSyGG
	 DA18W+qO0sZrfSNGMSMGtWBFnF/Pp8k+EskisJjlpvb8r2m+JHNkCsNq5dou1N+FjT
	 Au1HTjTwkcU6Wi8xLs0Ovapm0QGW/hoJEE/zvLwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgJMXyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJMXyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20245208B3;
        Tue, 13 Oct 2020 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633252;
        bh=eZx/+p9pjZeGQMZf+/wF0I2y51pqHOUQEod/u8TRQ14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BRRfxGkGQq+OX6PyPQSw8nPB1ck6ywOICVHUpP6rJQsp8zrysrdoPDoYFBAzfj2S7
         cWjLDzkeTnpgbXwZvaa1ApoKXschV39uvW8nU7w4tOwQoyRDmVhAbjdPKI4u1wIttm
         ZBe1+D//l4NPv9C75fR+eFD7rNsHew/f9figTY28=
Date:   Tue, 13 Oct 2020 16:54:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, areber@redhat.com,
        christian.brauner@ubuntu.com, christian@kellner.me,
        cyphar@cyphar.com, ebiederm@xmission.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, shakeelb@google.com, surenb@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 106/181] mm: use helper function
 mapping_allow_writable()
Message-ID: <20201013235410.0lyDYA9ho%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
