Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF023EF671
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054753; cv=none; b=WEas1dPVgm2tIvxNmH8Y1Jaf1wroZTrQv5XiLq7GOwORuph3TsgN5n8bQIWFsFsj+2TfEGYWXfPfMwGdqPhbjRCvIAM+aOdFZkpLwBc19fwpSISulfUKTt4ThSRxY5T5TssZA7EQ9Yu2SJfwy+tES/lC+B39lineQkJdJ37HQGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054753; c=relaxed/simple;
	bh=XHjVbNtt7RHA1zQ2UKaHtAOjIkKTTLzva/YyHzAjWlM=;
	h=Date:To:From:Subject:Message-Id; b=otvF+tszq4PR3iSpyuu6kaF9qOAb8cQPJTO9AK1Pu7Txq8+qWO40eF8wXFPxpHumpZLx+PT8mGMo0awUI0CbL/gby1g46w6vD1eYoLigBBr9n8ebvLjyDyDXdYakwFhV85Gjfboza/0hQoXRnjC/7Jcc+xSnEhx3k5JJ+mjmu0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+Oo45eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+Oo45eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11CEC2BCB0;
	Fri, 24 Apr 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777054752;
	bh=XHjVbNtt7RHA1zQ2UKaHtAOjIkKTTLzva/YyHzAjWlM=;
	h=Date:To:From:Subject:From;
	b=z+Oo45eoIYL5XNGt8gV8YvwuNLh80MUgZuFS/yzn5ieJDq9Yc5zPSIT8EQ13lDRV0
	 /HcLf+iIHb/lwly+Bzj4M4F0fepJ5P/YopRxa9VSsj4EXOvq0PIbe32JHimvM1dvrC
	 8QI1S9xA6V8wbJ6CHRWu9BtTbbJ/tITgYhqvF7UI=
Date: Fri, 24 Apr 2026 11:19:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch added to mm-new branch
Message-Id: <20260424181912.D11CEC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: use sysfs_match_string() in defrag_store()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: use sysfs_match_string() in defrag_store()
Date: Wed, 08 Apr 2026 08:47:00 -0700

Patch series "mm: huge_memory: clean up defrag sysfs with shared", v2.

Refactor defrag_store() and defrag_show() to use shared data tables
instead of duplicated if/else chains.

Patch 1 introduces an enum defrag_mode, a defrag_mode_strings[] table, and
a defrag_flags[] mapping array, then rewrites defrag_store() to use
sysfs_match_string() with a loop over defrag_flags[].

Patch 2 refactors defrag_show() to use the same arrays, replacing its
hardcoded if/else chain of test_bit() calls and string literals.

This follows the same pattern applied to anon_enabled_store() in commit
522dfb4ba71f ("mm: huge_memory: refactor anon_enabled_store() with
change_anon_orders()").


This patch (of 2):

Replace the if/else chain of sysfs_streq() calls in defrag_store() with
sysfs_match_string() and a defrag_mode_strings[] table.

Introduce enum defrag_mode and defrag_flags[] array mapping each mode to
its corresponding transparent_hugepage_flag.  The store function now loops
over defrag_flags[], setting the bit for the selected mode and clearing
the others.  When mode is DEFRAG_NEVER (index 4), no index in the
4-element defrag_flags[] matches, so all flags are cleared.

Note that the enum ordering (always, defer, defer+madvise, madvise, never)
differs from the original if/else chain order in defrag_store() (always,
defer+madvise, defer, madvise, never).  This is intentional to match the
display order used by defrag_show().

This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
refactor anon_enabled_store() with change_anon_orders()") which applied
the same sysfs_match_string() pattern to anon_enabled_store().

Link: https://lore.kernel.org/20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org
Link: https://lore.kernel.org/20260408-thp_defrag-v2-1-bc544c1bde4e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   60 +++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-sysfs_match_string-in-defrag_store
+++ a/mm/huge_memory.c
@@ -429,6 +429,29 @@ ssize_t single_hugepage_flag_store(struc
 	return count;
 }
 
+enum defrag_mode {
+	DEFRAG_ALWAYS = 0,
+	DEFRAG_DEFER,
+	DEFRAG_DEFER_MADVISE,
+	DEFRAG_MADVISE,
+	DEFRAG_NEVER,
+};
+
+static const char * const defrag_mode_strings[] = {
+	[DEFRAG_ALWAYS]		= "always",
+	[DEFRAG_DEFER]		= "defer",
+	[DEFRAG_DEFER_MADVISE]	= "defer+madvise",
+	[DEFRAG_MADVISE]	= "madvise",
+	[DEFRAG_NEVER]		= "never",
+};
+
+static const enum transparent_hugepage_flag defrag_flags[] = {
+	[DEFRAG_ALWAYS]		= TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
+	[DEFRAG_DEFER]		= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
+	[DEFRAG_DEFER_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
+	[DEFRAG_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+};
+
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
@@ -456,34 +479,19 @@ static ssize_t defrag_store(struct kobje
 			    struct kobj_attribute *attr,
 			    const char *buf, size_t count)
 {
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer+madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
+	int mode, m;
+
+	mode = sysfs_match_string(defrag_mode_strings, buf);
+	if (mode < 0)
 		return -EINVAL;
 
+	for (m = 0; m < ARRAY_SIZE(defrag_flags); m++) {
+		if (m == mode)
+			set_bit(defrag_flags[m], &transparent_hugepage_flags);
+		else
+			clear_bit(defrag_flags[m], &transparent_hugepage_flags);
+	}
+
 	return count;
 }
 static struct kobj_attribute defrag_attr = __ATTR_RW(defrag);
_

Patches currently in -mm which might be from leitao@debian.org are

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

