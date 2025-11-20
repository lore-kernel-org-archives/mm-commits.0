Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27D13644D1
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675104; cv=none; b=W5cCqYBuQoQwqrROHyNQFACKa/5+e7QsxBznyV7wsruFHuTFKxSFcwpFAUxHpcffr12hYjfmoLzq8yeAg67XuNSeEfZ53Ch0jAew1j41ZYUW3/3na3LMI+fbvMtBBbsM3xiZLLj8suxHIr+lZ2G0b0a1EjiKAQ/avuwyJdy4qmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675104; c=relaxed/simple;
	bh=zOewCKSeb1in8QWFzPhvGZJTsoFoU7Vs0zYO0j3/7Bs=;
	h=Date:To:From:Subject:Message-Id; b=uH08uL7n4jgQaCH8fqUigcEzNwmmTGk89cY9N2nDJgBlqTL0jaCxt4yK1BWCYPItdqH2iodcgoVPaHLNxxBURI6sk1gBHFmG66OnEeVycyLXPTRhM/c3vIldPi+m+tslHLygIAj1zGHn76UXDI7f+KXYocks0p9CJMQY8V3/e2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M5bK+TW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M5bK+TW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6ACC4CEF1;
	Thu, 20 Nov 2025 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675104;
	bh=zOewCKSeb1in8QWFzPhvGZJTsoFoU7Vs0zYO0j3/7Bs=;
	h=Date:To:From:Subject:From;
	b=M5bK+TW/mXFDM8mPI19gP8wrfZIUW7JUIpn/FeZGpLnNjyNtxzmAXWM+6C0nz24dF
	 0EfZUiS9mAgd+HgsZJx/HuZkAsj19f5EsTgy06TT7WyZfirf67YbeSk/1irXT+HKYv
	 z540ysu9zLH5TjEYS7BzwD7Y7A6GMZdVXhf8eRb0=
Date: Thu, 20 Nov 2025 13:45:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,chriscli@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-vma_start_write_killable-in-dup_mmap.patch removed from -mm tree
Message-Id: <20251120214504.3D6ACC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use vma_start_write_killable() in dup_mmap()
has been removed from the -mm tree.  Its filename was
     mm-use-vma_start_write_killable-in-dup_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use vma_start_write_killable() in dup_mmap()
Date: Mon, 10 Nov 2025 20:32:02 +0000

Allow waiting for the VMA write lock to be interrupted by fatal signals. 
The explicit check for fatal_signal_pending() can be removed as it is
checked during vma_start_write_killable().  Improves the latency of
killing the task as we do not wait for the reader to finish before
checking for signals.

Link: https://lkml.kernel.org/r/20251110203204.1454057-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Li <chriscli@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-use-vma_start_write_killable-in-dup_mmap
+++ a/mm/mmap.c
@@ -1747,7 +1747,9 @@ __latent_entropy int dup_mmap(struct mm_
 	for_each_vma(vmi, mpnt) {
 		struct file *file;
 
-		vma_start_write(mpnt);
+		retval = vma_start_write_killable(mpnt);
+		if (retval < 0)
+			goto loop_out;
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
 						    mpnt->vm_end, GFP_KERNEL);
@@ -1758,14 +1760,6 @@ __latent_entropy int dup_mmap(struct mm_
 			continue;
 		}
 		charge = 0;
-		/*
-		 * Don't duplicate many vmas if we've been oom-killed (for
-		 * example)
-		 */
-		if (fatal_signal_pending(current)) {
-			retval = -EINTR;
-			goto loop_out;
-		}
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

