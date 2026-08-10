Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47B353A69
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393430; cv=none; b=jD8E710YsPeMYtw82GY8ZX6BDk1SU6iceQrQKIKE7pqSTujR02HKyfImEy6mSR6I1wen+57bsqaCXG/5XNE2NoQerbpAg46XVNk3oi/sBQtpdYy0Zoc/L6Saqn/HZyiEOhNw4xdWMkileZhFXKewqm/r0wSueqjYfJeK1K2azg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393430; c=relaxed/simple;
	bh=T7syBRLjZcpo0dYU6Ejm6cYBUEHkD+wo/cEm37cmUg8=;
	h=Date:To:From:Subject:Message-Id; b=FbTssvBL1XlVEWUOiHcItNydgiR+YwTZNm/xQG1NW7JpGAPvjgSQ8oPjayfvI9oabObvyrrBk8CxsHxVDmBNkhbymfAhOeeol2tpy/lwR5UJCG+jUE1q43/6kKV7OKlEr7LhXbc/v79fC2bD9Sf/VF+Ub549Xz3KaHZw3azrlMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDAsGKHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDAsGKHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA1F1F000E9;
	Mon, 10 Aug 2026 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786393428;
	bh=rONA/Gs5KuV8y2es2kS9mTLytHFXcf0KcalbbBFz3f8=;
	h=Date:To:From:Subject;
	b=lDAsGKHVadHnowy6Zr2PspeAKP1i6wzMwqTpyN4n+t2JR8dmOOWJ2oy+l4rGABUL8
	 bJNGxp3vnyeMGgexQscEqOz0ZN4vrcoXQWXuAOYGvaD+iTh2a3vcHCYcFyRp49N2m/
	 ybfrY0eBmcH3FLF6lBOpUpsVS8ARAJZpu9j4aj7E=
Date: Mon, 10 Aug 2026 13:23:48 -0700
To: mm-commits@vger.kernel.org,skinsburskii@gmail.com,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch added to mm-new branch
Message-Id: <20260810202348.8EA1F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
has been added to the -mm mm-new branch.  Its filename is
     mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch

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
Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
Date: Mon Aug 10 01:16:37 PM PDT 2026

mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Stanislav says this can't happen.  Waste a few cycles to make the warning
go away.

Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
+++ a/mm/hmm.c
@@ -670,7 +670,8 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->locked)	/* needed by sparse */
+				*hmm_vma_walk->locked = false;
 			return HMM_FAULT_UNLOCKED;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

