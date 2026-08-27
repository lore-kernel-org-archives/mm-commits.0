Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41602282F29;
	Thu, 27 Aug 2026 03:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802143; cv=none; b=UAbtqQqojXGJp7+/Ke+QNbV7n1eDtQ1GPxb0z3uCU4RNK+NUCo746gQVBOC5hnlzbUbbSW3foWmztnxLtnUbZYxEK2i2M6H6ZI2zMgxMUBiJAX2PMptfZuBH9bRhCJ48VBwHFpITGW5U7hECVeoLfCdhAbXylpKDObWARndI5pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802143; c=relaxed/simple;
	bh=TCFJmpAOJ0/g4qYRlZzzBW4rTpK+LCl8iFxmAe2tVvA=;
	h=Date:To:From:Subject:Message-Id; b=COKcqEF7v26w+rB1z5543bA1ynIfvZLfBVSCyq6XGszZ0Dm9YyBaSbKgUl7BqflIQwlHsIMLQvJOPdA/fGkZfuwBrlo0ecLwvS0Tcw3QPQRi/u2yg5J/tB5HbaCKmIe4YScIFQW55AmSh44UIqVCc/LEF6uRejE1eF3NXqtreYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hq03bEYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hq03bEYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78111F000E9;
	Thu, 27 Aug 2026 03:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787802141;
	bh=2je84qf+S2pflcI+01dAh5z8yP8Itf7kLEicUcEAqis=;
	h=Date:To:From:Subject;
	b=hq03bEYIMPH+byExtgel4hMClMJ8OlTDCsfo+LRZdqIVYY3HXORGnYDoI5wM/E3yy
	 vZIzJeL4lZNqovp5dg9DHoz+NHYDPFABsx7NbyuytyfTIzzb/mWYU9HMEREXtc4ZT0
	 ODYOl5ckDO+8XvLdhgn0oj0gQHMC8IOvKGHq+s5A=
Date: Wed, 26 Aug 2026 20:42:21 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch added to mm-new branch
Message-Id: <20260827034221.B78111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: skip percpu counter allocation when profiling is disabled
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Mon, 17 Aug 2026 14:27:25 +0800

Patch series "alloc_tag: fix a leak and a deadlock around
shutdown_mem_profiling()", v2.

Two fixes for issues reported by sashiko:

  1. percpu counter leak on modules loaded after profiling is disabled.
  2. AB-BA deadlock between module load and /proc/allocinfo readers.


This patch (of 2):

After shutdown_mem_profiling() clears mem_profiling_support,
needs_section_mem() returns false, so later modules have their codetag
section placed as regular data and never enter the alloc_tag maple tree. 
codetag_load_module() still called load_module(), which allocated a percpu
counter for every tag; release_module_tags() could not find these modules
on unload, so the counters leaked.

Return -EOPNOTSUPP from load_module() when profiling is off:
codetag_module_init() drops the module's cmod, no counters are allocated
and the module loads without its tags.  codetag_unload_module() now always
calls free_section_mem(), since a module whose module_load() returned
-EOPNOTSUPP is not in the idr but may still hold a reserved section.

Link: https://lore.kernel.org/20260817062726.106511-1-hao.ge@linux.dev
Link: https://lore.kernel.org/20260817062726.106511-2-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c  |   10 ++++++++--
 mm/alloc_tag.c |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/lib/codetag.c~alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled
+++ a/lib/codetag.c
@@ -240,7 +240,9 @@ static int codetag_module_init(struct co
 
 	if (err < 0) {
 		kfree(cmod);
-		return err;
+		/* -EOPNOTSUPP means we can load the module without its tag. */
+		if (err != -EOPNOTSUPP)
+			return err;
 	}
 
 	return 0;
@@ -388,7 +390,11 @@ void codetag_unload_module(struct module
 			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
-		if (found && cttype->desc.free_section_mem)
+		/*
+		 * A module whose module_load() returned -EOPNOTSUPP is not
+		 * in the idr but may still hold reserved section memory.
+		 */
+		if (cttype->desc.free_section_mem)
 			cttype->desc.free_section_mem(mod, true);
 	}
 	mutex_unlock(&codetag_lock);
--- a/mm/alloc_tag.c~alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled
+++ a/mm/alloc_tag.c
@@ -975,6 +975,10 @@ static int load_module(struct module *mo
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* Profiling disabled: load the module without its tags. */
+	if (!mem_profiling_support)
+		return -EOPNOTSUPP;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
 		return 0;
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

