Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5D9345EC5
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 00:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786494527; cv=none; b=VwTfLCLyi9wCTMoX3gX0ojA8xY6MVX0K97tY8xEPxuIktcLWgAT3tB71AORno54DtFqiE2UO+yTziJpJxzPfBIVswLQDughfFkuNqWPrHoC0bhCf9BfWkzvbSy4ZyYm/3743ASI/6kXzy6tljR8uFwRca93cJtP1sVWfv+wJF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786494527; c=relaxed/simple;
	bh=OtAedqKYNmxqWlPLZIwZMo6lx7wZNUtbNc8QpIThtj4=;
	h=Date:To:From:Subject:Message-Id; b=PkgUyPdPqFya9XhY5w9GIMAZ09PTVdd3jXzRIZvRCaMPKB0raFcHbD6cpWeeEpoHB35oWGrdtBir00ANg5vOPAztwksSmQxaruYGIFagdtE6tKTnIB7ywAF9C2dfbvV//x60N+8JJyxe2V4BzHF+3lCJfxWhDPnTO4xBr4sgEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SeJF/c4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SeJF/c4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5931F00A3A;
	Wed, 12 Aug 2026 00:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786494525;
	bh=W3O7IGo3ZRtzVO2BS0stGfSTcpPV1klXVf31jekvw4s=;
	h=Date:To:From:Subject;
	b=SeJF/c4cRpYaWUzASE3eQ+Cl31wA/q0gourDurv47y2XJ9Q2x0TJKAjiPVPHq7K2Q
	 X6fvuhGuJFLqo4GkGpvzBFY86U4/G8JJG1xUoJF5Wp1Cmdc0litHXLL9qc9ddXwQnp
	 KbJKyiH6YA8A0rA29AO5Do6aQqcLywojbNdIGdtQ=
Date: Tue, 11 Aug 2026 17:28:45 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch added to mm-new branch
Message-Id: <20260812002845.6D5931F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
Date: Tue Aug 11 05:23:28 PM PDT 2026

WARN_ON_ONCE() if the handler didn't set ->locked, per Stanislav

Link: https://lore.kernel.org/anu1N-DOnQwxO1kF@skinsburskii
Cc: David Hildenbrand <david@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix
+++ a/mm/hmm.c
@@ -670,8 +670,10 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			if (hmm_vma_walk->locked)	/* needed by sparse */
+			if (hmm_vma_walk->locked)    /* needed by sparse */
 				*hmm_vma_walk->locked = false;
+			else
+				WARN_ON_ONCE(1);    /* broken fault handler */
 			return HMM_FAULT_UNLOCKED;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

