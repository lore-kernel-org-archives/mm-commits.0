Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E37B3750B1
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773261696; cv=none; b=mf5KIPD+qAB5CFKoYfkAsW/ww+Be5UuDjjVcRhVfsIf45Q347JSyO6yiaOE3IwXKgt4Q1AZmVhgLQdnbH1qz8ZNqYeQaCZnz89l/Cs+eQQtuDAzZewcbF0D3lUCS1sn/copLc/5eGvzMi8MSENFAG4GyOkFtaCNRUGz4SOckNhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773261696; c=relaxed/simple;
	bh=k/m+rLrn8Lhwo51SmltiZG+nP2BUratiyiQ2m4yW2p0=;
	h=Date:To:From:Subject:Message-Id; b=W+pbzM9aMK7LR6dAEzA5i/zC8JvPfl4MXLK39ZxSxjWqraKcSHDEtfHuvoJ0p4UzQfW1MHpGUBHgmyyOIlEFQnGpj4/E9xDSDo2lFQTpCeCYM9lC6iIsbRcRJkG+X8+JfCg2R41W+hA2WQZC9MHH+D7NgWpyAkEiqglfO1Ibd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXO0dqF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXO0dqF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE01C4CEF7;
	Wed, 11 Mar 2026 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773261696;
	bh=k/m+rLrn8Lhwo51SmltiZG+nP2BUratiyiQ2m4yW2p0=;
	h=Date:To:From:Subject:From;
	b=HXO0dqF+UoWiT1+BfWGiRo5CQ+xt1MzD6Gz2V3tsIDY7dtlf3HHIK5ev+I0E29rr+
	 4rnWk+w6CojwC2Hf5e77z1jz0sjqNulOMMAyQjCxqkb3GVR4vcbRFVRhEBtddPcqMe
	 FTIp2nBTb94EwQJuC5E7sa2RsQXat6z9kwRM1zSE=
Date: Wed, 11 Mar 2026 13:41:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-correct-invalid-map-count-check.patch added to mm-new branch
Message-Id: <20260311204135.EBE01C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: correct invalid map count check
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-correct-invalid-map-count-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-correct-invalid-map-count-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/mremap: correct invalid map count check
Date: Wed, 11 Mar 2026 17:24:36 +0000

Patch series "mm: improve map count checks".

Firstly, in mremap(), it appears that our map count checks have been overly
conservative - there is simply no reason to require that we have headroom
of 4 mappings prior to moving the VMA, we only need headroom of 2 VMAs
since commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()").

Likely the original headroom of 4 mappings was a mistake, and 3 was
actually intended.

Next, we access sysctl_max_map_count in a number of places without being
all that careful about how we do so.

We introduce a simple helper that READ_ONCE()'s the field
(get_sysctl_max_map_count()) to ensure that the field is accessed
correctly.  The WRITE_ONCE() side is already handled by the sysctl procfs
code in proc_int_conv().

We also move this field to internal.h as there's no reason for anybody
else to access it outside of mm.  Unfortunately we have to maintain the
extern variable, as mmap.c implements the procfs code.

Finally, we are accessing current->mm->map_count without holding the mmap
write lock, which is also not correct, so this series ensures the lock is
head before we access it.

We also abstract the check to a helper function, and add ASCII diagrams to
explain why we're doing what we're doing.


This patch (of 3):

We currently check to see, if on moving a VMA when doing mremap(), if it
might violate the sys.vm.max_map_count limit.

This was introduced in the mists of time prior to 2.6.12.

At this point in time, as now, the move_vma() operation would copy the VMA
(+1 mapping if not merged), then potentially split the source VMA upon
unmap.

Prior to commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), a VMA split would check whether
mm->map_count >= sysctl_max_map_count prior to a split before it ran.

On unmap of the source VMA, if we are moving a partial VMA, we might split
the VMA twice.

This would mean, on invocation of split_vma() (as was), we'd check whether
mm->map_count >= sysctl_max_map_count with a map count elevated by one,
then again with a map count elevated by two, ending up with a map count
elevated by three.

At this point we'd reduce the map count on unmap.

At the start of move_vma(), there was a check that has remained throughout
mremap()'s history of mm->map_count >= sysctl_max_map_count - 3 (which
implies mm->mmap_count + 4 > sysctl_max_map_count - that is, we must have
headroom for 4 additional mappings).

After mm->map_count is elevated by 3, it is decremented by one once the
unmap completes. The mmap write lock is held, so nothing else will observe
mm->map_count > sysctl_max_map_count.

It appears this check was always incorrect - it should have either be one
of 'mm->map_count > sysctl_max_map_count - 3' or 'mm->map_count >=
sysctl_max_map_count - 2'.

After commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
temporarily exceeded in munmap()"), the map count check on split is
eliminated in the newly introduced __split_vma(), which the unmap path
uses, and has that path check whether mm->map_count >=
sysctl_max_map_count.

This is valid since, net, an unmap can only cause an increase in map count
of 1 (split both sides, unmap middle).

Since we only copy a VMA and (if MREMAP_DONTUNMAP is not set) unmap
afterwards, the maximum number of additional mappings that will actually be
subject to any check will be 2.

Therefore, update the check to assert this corrected value. Additionally,
update the check introduced by commit ea2c3f6f5545 ("mm,mremap: bail out
earlier in mremap_to under map pressure") to account for this.

While we're here, clean up the comment prior to that.

Link: https://lkml.kernel.org/r/cover.1773249037.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jianzhou Zhao <luckd0g@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/mm/mremap.c~mm-mremap-correct-invalid-map-count-check
+++ a/mm/mremap.c
@@ -1041,10 +1041,11 @@ static unsigned long prep_move_vma(struc
 	vm_flags_t dummy = vma->vm_flags;
 
 	/*
-	 * We'd prefer to avoid failure later on in do_munmap:
-	 * which may split one vma into three before unmapping.
+	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
+	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
+	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 2 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,20 +1805,15 @@ static unsigned long check_mremap_params
 		return -EINVAL;
 
 	/*
-	 * move_vma() need us to stay 4 maps below the threshold, otherwise
-	 * it will bail out at the very beginning.
-	 * That is a problem if we have already unmapped the regions here
-	 * (new_addr, and old_addr), because userspace will not know the
-	 * state of the vma's after it gets -ENOMEM.
-	 * So, to avoid such scenario we can pre-compute if the whole
-	 * operation has high chances to success map-wise.
-	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
-	 * split in 3 before unmapping it.
-	 * That means 2 more maps (1 for each) to the ones we already hold.
-	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * We may unmap twice before invoking move_vma(), that is if new_len <
+	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
+	 * a VMA located at the destination.
+	 *
+	 * In the worst case, both unmappings will cause splits, resulting in a
+	 * net increased map count of 2. In move_vma() we check for headroom of
+	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (current->mm->map_count + 4 > sysctl_max_map_count)
 		return -ENOMEM;
 
 	return 0;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

