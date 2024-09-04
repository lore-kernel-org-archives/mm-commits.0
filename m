Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD378281
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423549; cv=none; b=d2sFGdG/ZBqqY2RLPum+kMg/6f/lQf12P2F3U7hllsLDwvjgmTlQBcUxlqpzkXZnTDGy3C+IPBHbd4RJ+gdImfxozh2IgQXk5hZkAH/t9+o0XLf9ZcBENGDEA6sYGvMsWTIZVCEaahbvbpL6vQ+7IfGnb1UmLTRP+kwrHwRzUUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423549; c=relaxed/simple;
	bh=/VwW1R5nhOnLzHSruEKI58Ky9rn20Csy3edn1sH3tSU=;
	h=Date:To:From:Subject:Message-Id; b=pGS1p+Z/ZlhYLXzDjuPCStuZRS+yQ2qPQrEG+2UQZv5NFL7K+b4J1h0aWc8IxsSY+EGBGvHGSYrR8oLtG7s3VNUuaZzkmt4ZpcDoQhdUO/G0SXzI0hmPcRMO1sXJAOb3vZvuBMY1K1W/aV5qEARcDlju7aFEe3mmdtlZh6+mw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EXdFyLNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EXdFyLNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7CDC4CEC2;
	Wed,  4 Sep 2024 04:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423548;
	bh=/VwW1R5nhOnLzHSruEKI58Ky9rn20Csy3edn1sH3tSU=;
	h=Date:To:From:Subject:From;
	b=EXdFyLNkUp0Bwdx6SX2bvBLzc1JQBhgIo4OC+14JRfKtfRGsPq/tcktA/o/9k1v9T
	 iryBWFcSmnSqn887RzwP6k6f6gvvc7Zf5nRMc6E6uncmkWlDQJn/0w3lJiM2hZinst
	 iVYZuAysayXcCS1MqVUD9emu9rv9H3BKmaQDfQwo=
Date: Tue, 03 Sep 2024 21:19:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-correctly-position-vma_iterator-in-__split_vma.patch removed from -mm tree
Message-Id: <20240904041908.CF7CDC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: correctly position vma_iterator in __split_vma()
has been removed from the -mm tree.  Its filename was
     mm-vma-correctly-position-vma_iterator-in-__split_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: correctly position vma_iterator in __split_vma()
Date: Fri, 30 Aug 2024 00:00:41 -0400

Patch series "Avoid MAP_FIXED gap exposure", v8.

It is now possible to walk the vma tree using the rcu read locks and is
beneficial to do so to reduce lock contention.  Doing so while a MAP_FIXED
mapping is executing means that a reader may see a gap in the vma tree
that should never logically exist - and does not when using the mmap lock
in read mode.  The temporal gap exists because mmap_region() calls
munmap() prior to installing the new mapping.

This patch set stops rcu readers from seeing the temporal gap by splitting
up the munmap() function into two parts.  The first part prepares the vma
tree for modifications by doing the necessary splits and tracks the vmas
marked for removal in a side tree.  The second part completes the
munmapping of the vmas after the vma tree has been overwritten (either by
a MAP_FIXED replacement vma or by a NULL in the munmap() case).

Please note that rcu walkers will still be able to see a temporary state
of split vmas that may be in the process of being removed, but the
temporal gap will not be exposed.  vma_start_write() are called on both
parts of the split vma, so this state is detectable.

If existing vmas have a vm_ops->close(), then they will be called prior to
mapping the new vmas (and ptes are cleared out).  Without calling
->close(), hugetlbfs tests fail (hugemmap06 specifically) due to resources
still being marked as 'busy'.  Unfortunately, calling the corresponding
->open() may not restore the state of the vmas, so it is safer to keep the
existing failure scenario where a gap is inserted and never replaced.  The
failure scenario is in its own patch (0015) for traceability.


This patch (of 21):

The vma iterator may be left pointing to the newly created vma.  This
happens when inserting the new vma at the end of the old vma (!new_below).

The incorrect position in the vma iterator is not exposed currently since
the vma iterator is repositioned in the munmap path and is not reused in
any of the other paths.

This has limited impact in the current code, but is required for future
changes.

Link: https://lkml.kernel.org/r/20240830040101.822209-2-Liam.Howlett@oracle.com
Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-correctly-position-vma_iterator-in-__split_vma
+++ a/mm/vma.c
@@ -177,7 +177,7 @@ void unmap_region(struct mm_struct *mm,
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
- * VMA Iterator will point to the end VMA.
+ * VMA Iterator will point to the original VMA.
  */
 static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		       unsigned long addr, int new_below)
@@ -246,6 +246,9 @@ static int __split_vma(struct vma_iterat
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
+	else
+		vma_prev(vmi);
+
 	return 0;
 
 out_free_mpol:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


