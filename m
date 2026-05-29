Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D505836E466
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027613; cv=none; b=cRxHtiz8p/JBKdXUGDssymXuQCM5Are8uQP8fuGiFhhpV1SJm1ST9Hm5SWlkfrV9eongMFKdBG9oswDxRCfWebnZ3LjkO5vh827oI1y/M/RwY8waty3of+bgQBwYa305ULS/erzkAHRk59JI4rvP2D4fAJAmPwRRUMwCnkwmdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027613; c=relaxed/simple;
	bh=KJuk1Ac/vSZ7AGXMHT3nVksjhu2b7crNLe76FNOR4Yo=;
	h=Date:To:From:Subject:Message-Id; b=ATdEQqiWjk3PCS2+tw/IrLzErRuAM4hu3pcB0OsLkHwAEgadcCTDDTCz26L2OgLUsZjDn13Z43Q0YGx+6zLSxlDeSSSxMLlL74DIhoEXTKraw2z7qIMr81dbyYWfWlYs99n4ZN/qSHSnvvce22JXGr1/vWEoQjhfPLWhE4mnsbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F1DGedJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F1DGedJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D61F00898;
	Fri, 29 May 2026 04:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027611;
	bh=NGhFa7J60Yre6EGjXrhCd9aYGwTJE9fnQa7ZLasKKIA=;
	h=Date:To:From:Subject;
	b=F1DGedJPsGLOfbQMKFTPn6P0EIuTChQf67gucY+z64fPx6bEPHMvEfjnlSYT6jRZ+
	 yO6UoMPRawyPfjkKmpExQA3TMGAJspLP8m6Fv58TJ45qY65Xrd1RXEC3VDxE5g/+qw
	 xjaCiNF/DHY1dPq12G8zLUXK4BcTWeAy9LeS0za8=
Date: Thu, 28 May 2026 21:06:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch removed from -mm tree
Message-Id: <20260529040651.A73D61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: use sysfs_match_string() in defrag_store()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


