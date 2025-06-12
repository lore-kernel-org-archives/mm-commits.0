Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C24115C158;
	Thu, 12 Jun 2025 05:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706985; cv=none; b=Qv2bCxUhlMXOi/Ll7ajNMi5/StqsXZTycqT2urbwOcd6c2o97CG90v67kTA71WMhKk9PfhS7Ay+zYglfbM8gl6zqnJwCAbgRmo2uh6ALTrvd3cPSl1VajpmZVoFLDHtc6MJDwcqPLO8zKGBywqvnGvxHbfr/jB3Ex2v0Lk901Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706985; c=relaxed/simple;
	bh=0vNftP0sOASz65g+dOts/fE0CC9DdEXWm0pE0/OYyUo=;
	h=Date:To:From:Subject:Message-Id; b=GbHFOAzOit6FGuTuxT4YSdR1Wi3EuXMWOqRmfeESK5hWBBgMlUsqBoc4AhkYWrHLVaXi3TB/6k1EetI3wvz2T4RmbBGWQhQVcU25ediWv3qZGB4gJBpAn9DRux+MPNBElZDNV3rqOyMHH6ovk2d0bhuCVb/ETHTUJZr8ZSo4n88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X8CTcbb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X8CTcbb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B056DC4CEEA;
	Thu, 12 Jun 2025 05:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706984;
	bh=0vNftP0sOASz65g+dOts/fE0CC9DdEXWm0pE0/OYyUo=;
	h=Date:To:From:Subject:From;
	b=X8CTcbb8CHcVXQT+waUZJHM26udDnubNMt2M9+21u7dm4ppUsIFmarvpmQmIMqJjR
	 oTcuj0waDdJZlx7S2m/zQaOvUgqM/opPLwblye2vdCIiyMpdosgv4H3R4XlPW6Ulxk
	 jSDfqTu70iCU1zfCZX+ZQYqNsRsrhH99Mvx/GayQ=
Date: Wed, 11 Jun 2025 22:43:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch removed from -mm tree
Message-Id: <20250612054304.B056DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: reset VMA iterator on commit_merge() OOM failure
has been removed from the -mm tree.  Its filename was
     mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: reset VMA iterator on commit_merge() OOM failure
Date: Fri, 6 Jun 2025 13:50:32 +0100

While an OOM failure in commit_merge() isn't really feasible due to the
allocation which might fail (a maple tree pre-allocation) being 'too small
to fail', we do need to handle this case correctly regardless.

In vma_merge_existing_range(), we can theoretically encounter failures
which result in an OOM error in two ways - firstly dup_anon_vma() might
fail with an OOM error, and secondly commit_merge() failing, ultimately,
to pre-allocate a maple tree node.

The abort logic for dup_anon_vma() resets the VMA iterator to the initial
range, ensuring that any logic looping on this iterator will correctly
proceed to the next VMA.

However the commit_merge() abort logic does not do the same thing.  This
resulted in a syzbot report occurring because mlockall() iterates through
VMAs, is tolerant of errors, but ended up with an incorrect previous VMA
being specified due to incorrect iterator state.

While making this change, it became apparent we are duplicating logic -
the logic introduced in commit 41e6ddcaa0f1 ("mm/vma: add give_up_on_oom
option on modify/merge, use in uffd release") duplicates the
vmg->give_up_on_oom check in both abort branches.

Additionally, we observe that we can perform the anon_dup check safely on
dup_anon_vma() failure, as this will not be modified should this call
fail.

Finally, we need to reset the iterator in both cases, so now we can simply
use the exact same code to abort for both.

We remove the VM_WARN_ON(err != -ENOMEM) as it would be silly for this to
be otherwise and it allows us to implement the abort check more neatly.

Link: https://lkml.kernel.org/r/20250606125032.164249-1-lorenzo.stoakes@oracle.com
Fixes: 47b16d0462a4 ("mm: abort vma_modify() on merge out of memory failure")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6842cc67.a00a0220.29ac89.003b.GAE@google.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/vma.c~mm-vma-reset-vma-iterator-on-commit_merge-oom-failure
+++ a/mm/vma.c
@@ -967,26 +967,9 @@ static __must_check struct vm_area_struc
 		err = dup_anon_vma(next, middle, &anon_dup);
 	}
 
-	if (err)
+	if (err || commit_merge(vmg))
 		goto abort;
 
-	err = commit_merge(vmg);
-	if (err) {
-		VM_WARN_ON(err != -ENOMEM);
-
-		if (anon_dup)
-			unlink_anon_vmas(anon_dup);
-
-		/*
-		 * We've cleaned up any cloned anon_vma's, no VMAs have been
-		 * modified, no harm no foul if the user requests that we not
-		 * report this and just give up, leaving the VMAs unmerged.
-		 */
-		if (!vmg->give_up_on_oom)
-			vmg->state = VMA_MERGE_ERROR_NOMEM;
-		return NULL;
-	}
-
 	khugepaged_enter_vma(vmg->target, vmg->flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -995,6 +978,9 @@ abort:
 	vma_iter_set(vmg->vmi, start);
 	vma_iter_load(vmg->vmi);
 
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 	/*
 	 * This means we have failed to clone anon_vma's correctly, but no
 	 * actual changes to VMAs have occurred, so no harm no foul - if the
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

