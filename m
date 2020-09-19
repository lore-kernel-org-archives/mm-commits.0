Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B9CC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626C821D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486393;
	bh=peEaQHTikV9XM6gAhvoNEGDMpdKLEmzs6y5+xMcPdt0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DdERHR6tWDJQhkUmanHO4KlvXZrDrWRJDh4Bc3b28NjZ/AH1MgOysY493MU+ccfwo
	 rZSI5OvC7ebUF/DXCZ0XgdjaoUYa8tLqJwV6VCJbTolGaOwqKpLMg4DLjhN4d6iKt+
	 5WlV9GLvZuF4Jrq2wsPSkix1CKrgfjpd/6A3v0Ls=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgISDdM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgISDdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:33:12 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E84621707;
        Sat, 19 Sep 2020 03:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486391;
        bh=peEaQHTikV9XM6gAhvoNEGDMpdKLEmzs6y5+xMcPdt0=;
        h=Date:From:To:Subject:From;
        b=flRPNgB0nWEpA6/w3VIwkF114ZgB+X7iTWuALUQTt/NmUA0GsRFebcc6SUs1sCEmg
         0/B3eWGqisLtnkLg7SP9w3s90Tjsgrj1XNdtVvs/0sI7IuykY/Q9LTuzMq+nXRVORU
         bCjleCu+9y+IKxkl4GSMSSw9yUUBelrYwgEVL82M=
Date:   Fri, 18 Sep 2020 20:33:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, surenb@google.com,
        shakeelb@google.com, peterz@infradead.org, mingo@kernel.org,
        ebiederm@xmission.com, cyphar@cyphar.com, christian@kellner.me,
        christian.brauner@ubuntu.com, areber@redhat.com,
        linmiaohe@huawei.com
Subject:  + mm-use-helper-function-mapping_allow_writable.patch added
 to -mm tree
Message-ID: <20200919033310.sVR9G%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use helper function mapping_allow_writable()
has been added to the -mm tree.  Its filename is
     mm-use-helper-function-mapping_allow_writable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-helper-function-mapping_allow_writable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-helper-function-mapping_allow_writable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -558,7 +558,7 @@ static __latent_entropy int dup_mmap(str
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

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

