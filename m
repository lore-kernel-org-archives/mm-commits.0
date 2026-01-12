Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092C2FF65B;
	Mon, 12 Jan 2026 19:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246098; cv=none; b=gWwjMb4IOY/ROds6/lvar+l/qEcibrfoRLPU+iShMQbh6BXw8EC0j3MhFQDkYCLqn3pGLKqHTtO3oCApPPG3ZOo3sDK0Tb26EMNeGIVk0Nlp6Abdxb0E+qGvA4qsGvgwomKtrqOOhN006Fk6KZbmIac6kaei8zH+Wzfihy57jeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246098; c=relaxed/simple;
	bh=RX0Sv+nwwGP5jlmTmIvwmhFwdFZM6lqTlF9ZMSWDv0w=;
	h=Date:To:From:Subject:Message-Id; b=rhrDAIHkUNGIv09sD590dtszNwHBltnwRT0BKK5k7zs7PNtumDyVmgdCiytdSJPu5+RAG9USxOaVCG1RQ34izHE4FyaoCOhUBXZ08OaN3w7Cz19VE3dCnnI2R7NR2xEzQbdXOHzrYNe90nt6RdKlMDHhAyfKkNoRNqG9GcCicI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cUOvzy8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cUOvzy8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845DBC116D0;
	Mon, 12 Jan 2026 19:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768246097;
	bh=RX0Sv+nwwGP5jlmTmIvwmhFwdFZM6lqTlF9ZMSWDv0w=;
	h=Date:To:From:Subject:From;
	b=cUOvzy8DS7jBfB6sfhSsACJ8m44bbOuhy3t2BfrVQvyLhWYSQZMwU5ybuoiOl1SZC
	 ZnlIP+sfn65KMAaxNMgwzjiVH1h3oWG3yMvXX7fnX4oKFDQI/2tlgI/3su9+Dmrs6G
	 lo0FT57N9Tv6ajMxyYXuXPu67TvAl6tbYatMQ3cM=
Date: Mon, 12 Jan 2026 11:28:16 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,hdanton@sina.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch added to mm-new branch
Message-Id: <20260112192817.845DBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
Date: Mon, 12 Jan 2026 16:06:12 +0530

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node
+++ a/mm/vmalloc.c
@@ -2273,11 +2273,14 @@ decay_va_pool_node(struct vmap_node *vn,
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2287,6 +2290,11 @@ kasan_release_vmalloc_node(struct vmap_n
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch
mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch
ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch
ocfs2-validate-inline-data-i_size-during-inode-read.patch
ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

