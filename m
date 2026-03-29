Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D357F255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744881; cv=none; b=aGyIBBC1QxTiD4xjltDsNEj6aDeYSq97WnSMtBOZbHoYngoFCFQZN0UPxfwv1V3w2047y9ug7McCsYd+sOOX8zWI3cyPfLCN6HpPZdTPbst4aXGNMniIv1Icj01jsDkcj1AcB/sniuFcz3fe3HV/cHaIKI8bDB5jX3coN/+izGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744881; c=relaxed/simple;
	bh=yUCmSYS1EbZKwGZ/nudQ/YXs5F5UbvTtwRcpGBjOmBg=;
	h=Date:To:From:Subject:Message-Id; b=AaJB4hoODBcz+nru6Znq9ZGeplVtCZqs3qKWQbnxBOlwI/MTzNyZREiRLvWUJ0Lm70JkmqfMK/XdsmTAACp4wEhbl1DTzKq5nLUQYfecR8fimB6+ubHP+YJTXWBbzOHE6iPDbQAD0XV0TqJfWodqSO6DQgppc6tpxlB9qvlFQW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMtRSaIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMtRSaIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5EDC4CEF7;
	Sun, 29 Mar 2026 00:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744881;
	bh=yUCmSYS1EbZKwGZ/nudQ/YXs5F5UbvTtwRcpGBjOmBg=;
	h=Date:To:From:Subject:From;
	b=GMtRSaIQ+1wFAz99cOaexVG9s24dVWYfEeWxjeLrE+LnEdb41dayFiTqv7ZSILCWO
	 I2eWqXlRW6FAdZjr2ShbwXeI7Hs8dSr6U+zb0mhEXpvW4d93MufSuY44VhXBtHoyOj
	 VRCunsxcpd7gEtugtV3Zjj9Vda5RTR5bcpfzr3uo=
Date: Sat, 28 Mar 2026 17:41:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch removed from -mm tree
Message-Id: <20260329004121.AD5EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: refactor enabled_store() with set_global_enabled_mode()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: refactor enabled_store() with set_global_enabled_mode()
Date: Tue, 17 Mar 2026 08:33:58 -0700

Refactor enabled_store() to use a new set_global_enabled_mode() helper. 
Introduce a separate enum global_enabled_mode and
global_enabled_mode_strings[], mirroring the anon_enabled_mode pattern
from the previous commit.

A separate enum is necessary because the global THP setting does not
support "inherit", only "always", "madvise", and "never".  Reusing
anon_enabled_mode would leave a NULL gap in the string array, causing
sysfs_match_string() to stop early and fail to match entries after the
gap.

The helper uses the same loop pattern as set_anon_enabled_mode(),
iterating over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed.

Link: https://lkml.kernel.org/r/20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   63 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode
+++ a/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_m
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS	= 0,
+	GLOBAL_ENABLED_MADVISE	= 1,
+	GLOBAL_ENABLED_NEVER	= 2,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool set_global_enabled_mode(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	enum global_enabled_mode m;
+	bool changed = false;
+
+	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
+		if (m == mode)
+			changed |= !test_and_set_bit(thp_flags[m],
+						     &transparent_hugepage_flags);
+		else
+			changed |= test_and_clear_bit(thp_flags[m],
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
+	if (set_global_enabled_mode(mode)) {
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

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

