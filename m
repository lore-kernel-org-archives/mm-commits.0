Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5630E82E
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773003974; cv=none; b=h36uAaHnsjcaFRfPbpTciHKzfATh6my44MXemtxqaa1Fl07nAgDRGXMpurc4hs/qCT+KNLpGGEm93FU8Ty4GdSkOOhvCedix2k6ubEOmTlC8ebv52If4sjT9PFaW2GL6lCDIShzX5C2rTtqsT9SbXxcf2GYNKiOsun24jkD6fK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773003974; c=relaxed/simple;
	bh=HKofCSvgfYM3EImwfc0eNDyCi7yPXOFCs1Z4+uiZn7A=;
	h=Date:To:From:Subject:Message-Id; b=J1txfEdGy2CcEBcJ0BhQ8+1OTf8BeyBHWXPwjYZjtGNPeTLHEsD57q9ITASKhwaXKZwG15/KNcyGMV1Lw59R6AGnMa8sLvk4Ow01AwbwP9C94xCeCVHgSCVDHqi98Ero2ne59hGF0tLTU5S4qljKoicWV1y9jbpWtPqS3k4+j24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgHhO4hU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgHhO4hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC95BC116C6;
	Sun,  8 Mar 2026 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773003974;
	bh=HKofCSvgfYM3EImwfc0eNDyCi7yPXOFCs1Z4+uiZn7A=;
	h=Date:To:From:Subject:From;
	b=QgHhO4hUoC8Eju0KHNlfT8CJUcAO6BOUSomvzrqqVcU7hBYofpn+xgaBEIcwTyea1
	 73RNeiIm+hiRKxcaOl++6p2motGRKrvIaZVNC59XvB6AsU0psC0AhlAKpPKpteDoiY
	 gnrUCc8X7Dmw8e0WBgqeEPticxyARSQf+a8d5hYM=
Date: Sun, 08 Mar 2026 14:06:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-refactor-enabled_store-with-change_enabled.patch added to mm-new branch
Message-Id: <20260308210613.EC95BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: refactor enabled_store() with change_enabled()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-refactor-enabled_store-with-change_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-refactor-enabled_store-with-change_enabled.patch

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
Subject: mm: huge_memory: refactor enabled_store() with change_enabled()
Date: Sat, 07 Mar 2026 08:08:07 -0800

Refactor enabled_store() to use a new change_enabled() helper.  Introduce
a separate enum global_enabled_mode and global_enabled_mode_strings[],
mirroring the anon_enabled_mode pattern from the previous commit.

A separate enum is necessary because the global THP setting does not
support "inherit", only "always", "madvise", and "never".  Reusing
anon_enabled_mode would leave a NULL gap in the string array, causing
sysfs_match_string() to stop early and fail to match entries after the
gap.

The helper uses the same loop pattern as change_anon_orders(), iterating
over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed.

Link: https://lkml.kernel.org/r/20260307-thp_logs-v3-3-a45d2c8f3685@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   63 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-enabled_store-with-change_enabled
+++ a/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_m
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS,
+	GLOBAL_ENABLED_MADVISE,
+	GLOBAL_ENABLED_NEVER,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool change_enabled(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	bool changed = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(thp_flags); i++) {
+		if (i == mode)
+			changed |= !test_and_set_bit(thp_flags[i],
+						     &transparent_hugepage_flags);
+		else
+			changed |= test_and_clear_bit(thp_flags[i],
+						      &transparent_hugepage_flags);
+	}
+
+	return changed;
+}
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(global_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (change_enabled(mode)) {
 		int err = start_stop_khugepaged();
+
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+	return count;
 }
 
 static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);
_

Patches currently in -mm which might be from leitao@debian.org are

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-change_anon_orders.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch

