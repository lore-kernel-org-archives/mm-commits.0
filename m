Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4223D153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410850; cv=none; b=ZxZau+JX1PMKIQ58SLjgzyRZ97QIJq603J//vQxQE698tdgFMqKcKC9AJEj7QPwKiM1xrzAeb62L9r7uauLhqMVtASMZp/ZmOVcCMN9uwiUD0BFS3xKVM4uMcaE/getlrjuvP/Akscm2iuBVhBPs+CzijLd0o+eQgXJjo2G5cz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410850; c=relaxed/simple;
	bh=PJX/v5ukucF7HLK/0gQr6tNyi/1VXGjrPJh0uWPEkxY=;
	h=Date:To:From:Subject:Message-Id; b=SOkCWjOO56bsEbDw6YvCwfzBueZLxRUnb2D7AwueT78Wqc1k7WXwtlp9DsEbx7KZZ4GbZbQ/DAseUFCMHChqTcRkUEMKgCiWHPWSr0YMJw6FQ6Kmla+26nHON0Tq5j/oAe0CIRYl+Sf9vmSNR8C9zlkcsLhCKvIPuXH+nyDvTF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZN2SZty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZN2SZty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05F3C4CED3;
	Sat,  1 Feb 2025 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410849;
	bh=PJX/v5ukucF7HLK/0gQr6tNyi/1VXGjrPJh0uWPEkxY=;
	h=Date:To:From:Subject:From;
	b=dZN2SZty2VTA8ixuggAIr/fhXBu30H1dm/WDPgijjnHKS7U8yNKBnRoalEhK3kkVp
	 VJNrVAztAT6cJlaVcGaBCgfVjyz2ahLsOXNTk1gSKess6tCPG4brBTqMpRj92Kl3VE
	 mvEYO+gMm8ZsuVdV20kDl2by2ZBgSYjWtC6LKVBw=
Date: Sat, 01 Feb 2025 03:54:09 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,peterz@infradead.org,oleg@redhat.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch removed from -mm tree
Message-Id: <20250201115409.B05F3C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: be more careful about dup_mmap() failures and uprobe registering
has been removed from the -mm tree.  Its filename was
     kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: kernel: be more careful about dup_mmap() failures and uprobe registering
Date: Mon, 27 Jan 2025 12:02:21 -0500

If a memory allocation fails during dup_mmap(), the maple tree can be left
in an unsafe state for other iterators besides the exit path.  All the
locks are dropped before the exit_mmap() call (in mm/mmap.c), but the
incomplete mm_struct can be reached through (at least) the rmap finding
the vmas which have a pointer back to the mm_struct.

Up to this point, there have been no issues with being able to find an
mm_struct that was only partially initialised.  Syzbot was able to make
the incomplete mm_struct fail with recent forking changes, so it has been
proven unsafe to use the mm_struct that hasn't been initialised, as
referenced in the link below.

Although 8ac662f5da19f ("fork: avoid inappropriate uprobe access to
invalid mm") fixed the uprobe access, it does not completely remove the
race.

This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on the
oom side (even though this is extremely unlikely to be selected as an oom
victim in the race window), and sets MMF_UNSTABLE to avoid other potential
users from using a partially initialised mm_struct.

When registering vmas for uprobe, skip the vmas in an mm that is marked
unstable.  Modifying a vma in an unstable mm may cause issues if the mm
isn't fully initialised.

Link: https://lore.kernel.org/all/6756d273.050a0220.2477f.003d.GAE@google.com/
Link: https://lkml.kernel.org/r/20250127170221.1761366-1-Liam.Howlett@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++++
 kernel/fork.c           |   17 ++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/kernel/events/uprobes.c~kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering
+++ a/kernel/events/uprobes.c
@@ -28,6 +28,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/workqueue.h>
 #include <linux/srcu.h>
+#include <linux/oom.h>          /* check_stable_address_space */
 
 #include <linux/uprobes.h>
 
@@ -1260,6 +1261,9 @@ register_for_each_vma(struct uprobe *upr
 		 * returns NULL in find_active_uprobe_rcu().
 		 */
 		mmap_write_lock(mm);
+		if (check_stable_address_space(mm))
+			goto unlock;
+
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
 		    file_inode(vma->vm_file) != uprobe->inode)
--- a/kernel/fork.c~kernel-be-more-careful-about-dup_mmap-failures-and-uprobe-registering
+++ a/kernel/fork.c
@@ -760,7 +760,8 @@ loop_out:
 		mt_set_in_rcu(vmi.mas.tree);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
-	} else if (mpnt) {
+	} else {
+
 		/*
 		 * The entire maple tree has already been duplicated. If the
 		 * mmap duplication fails, mark the failure point with
@@ -768,8 +769,18 @@ loop_out:
 		 * stop releasing VMAs that have not been duplicated after this
 		 * point.
 		 */
-		mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-		mas_store(&vmi.mas, XA_ZERO_ENTRY);
+		if (mpnt) {
+			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
+			mas_store(&vmi.mas, XA_ZERO_ENTRY);
+			/* Avoid OOM iterating a broken tree */
+			set_bit(MMF_OOM_SKIP, &mm->flags);
+		}
+		/*
+		 * The mm_struct is going to exit, but the locks will be dropped
+		 * first.  Set the mm_struct as unstable is advisable as it is
+		 * not fully initialised.
+		 */
+		set_bit(MMF_UNSTABLE, &mm->flags);
 	}
 out:
 	mmap_write_unlock(mm);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


