Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3432B9AC
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 04:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771562317; cv=none; b=rUL8SrqM3XMjW+WsuFW3rTmKLuQGfMrypP8zkS+9HaPsGJhwWf/dtqBjebmUmf3lnIYFggLPIy8myCEb70YTysi+fsq53HyL5ryiV+JGZaqziS/0hVYTeQYXg3H6GAnKkMi4qR7oLsduogxcm+HbZUC/BhJvgVW4OJqPp1sjWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771562317; c=relaxed/simple;
	bh=+2SnZ+kkzayiCd6S6xSYAqIoZadHr+75HRaIS9UCe50=;
	h=Date:To:From:Subject:Message-Id; b=K9Wp2C/iRpUwDUMYDl/6G+tEfBekkRdh1GVJT3ANDW0sbt1p2wIukDuF67gNniTIA9d3ZEfTxbbJVBOakum/IuW1EPmdPyCckBmPxy4Mqh8eqf7LEKgIFLMLq1mCxzaeJGROGYB5A0mPCQBYmXCw4vsRLAU8E82IoEEFweGAXj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0zVgJSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0zVgJSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683FFC116D0;
	Fri, 20 Feb 2026 04:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771562316;
	bh=+2SnZ+kkzayiCd6S6xSYAqIoZadHr+75HRaIS9UCe50=;
	h=Date:To:From:Subject:From;
	b=n0zVgJSv2zS40HN3PHcy3Mpz2OIuDx6/cz6uePnEJJyChqQ0fwPmQGkXCCg4NWSYG
	 vcPDvl1tYQwAKAbvxSe4AHfioZFnOLT4MS/p/DAevIxyl+rEp8iWRZ533+bIR+bcpt
	 9NIuV0JHyOfIvMut0TinWBQTt4YlE4H+UuD4CG0s=
Date: Thu, 19 Feb 2026 20:38:35 -0800
To: mm-commits@vger.kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-introduce-hierarchical-per-cpu-counters-fix.patch added to mm-new branch
Message-Id: <20260220043836.683FFC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-introduce-hierarchical-per-cpu-counters-fix
has been added to the -mm mm-new branch.  Its filename is
     lib-introduce-hierarchical-per-cpu-counters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-introduce-hierarchical-per-cpu-counters-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-introduce-hierarchical-per-cpu-counters-fix
Date: Thu Feb 19 08:12:23 PM PST 2026

export things to modules for lib/tests/percpu_counter_tree_kunit.ko

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter_tree.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/lib/percpu_counter_tree.c~lib-introduce-hierarchical-per-cpu-counters-fix
+++ a/lib/percpu_counter_tree.c
@@ -297,6 +297,7 @@ int percpu_counter_tree_init(struct perc
 {
 	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init);
 
 /**
  * percpu_counter_tree_destroy_many() - Destroy many per-CPU counter trees.
@@ -321,6 +322,7 @@ void percpu_counter_tree_destroy(struct
 {
 	return percpu_counter_tree_destroy_many(counter, 1);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy);
 
 static
 long percpu_counter_tree_carry(long orig, long res, long inc, unsigned long bit_mask)
@@ -423,7 +425,7 @@ void percpu_counter_tree_add(struct perc
 		return;
 	percpu_counter_tree_add_slowpath(counter, inc);
 }
-
+EXPORT_SYMBOL_GPL(percpu_counter_tree_add);
 
 static
 long percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counter)
@@ -450,6 +452,7 @@ long percpu_counter_tree_precise_sum(str
 {
 	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(counter->bias);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
 
 static
 int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy_pos)
@@ -491,6 +494,7 @@ int percpu_counter_tree_approximate_comp
 			     a->approx_accuracy_range.over + b->approx_accuracy_range.under,
 			     a->approx_accuracy_range.under + b->approx_accuracy_range.over);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare);
 
 /**
  * percpu_counter_tree_approximate_compare_value - Approximated comparison of a counter tree against a given value.
@@ -514,6 +518,7 @@ int percpu_counter_tree_approximate_comp
 			     counter->approx_accuracy_range.under,
 			     counter->approx_accuracy_range.over);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare_value);
 
 /**
  * percpu_counter_tree_precise_compare - Precise comparison of two counter trees.
@@ -582,6 +587,7 @@ int percpu_counter_tree_precise_compare(
 		return 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare);
 
 /**
  * percpu_counter_tree_precise_compare_value - Precise comparison of a counter tree against a given value.
@@ -619,6 +625,7 @@ int percpu_counter_tree_precise_compare_
 		return 1;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare_value);
 
 static
 void percpu_counter_tree_set_bias(struct percpu_counter_tree *counter, long bias)
@@ -657,6 +664,7 @@ size_t percpu_counter_tree_items_size(vo
 		return 0;
 	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
 }
+EXPORT_SYMBOL_GPL(percpu_counter_tree_items_size);
 
 static void __init calculate_accuracy_topology(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
lib-introduce-hierarchical-per-cpu-counters-fix.patch

