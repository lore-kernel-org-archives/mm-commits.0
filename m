Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABE0255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744880; cv=none; b=WdDjiybd9d+xAPO1Q2kz1WBe7toVeuvKG/F7dXT4lduLZtWJQ/eHX36VIdGZV3QTnl0rygTDU7OcCuZ+B2Y8nU5UjOJgsVFWjoDI7DK9iL3wjYJvqpHtZV0JifNJ9U4LgG2D4Ahmv5EmXR9YJgock7e5e1oLNwFtuCODqJf0N2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744880; c=relaxed/simple;
	bh=wcXZVhlCf+DqNZVzrQmW26B653qbGulb5TMnhuwjhy8=;
	h=Date:To:From:Subject:Message-Id; b=GDhunUWFR6ZuyCN+ufZmD0HqXaJk2aiHHo1SqSBIfwdpZTC2LGPTq1q7izGyd4XJcjCEfP2/kmUlLs6oKcDddl+UOZNHEuZ/KvmB5XqiD+UAJQHgw98tRZsujmhOAcG8N/4OqYqMoLrPj3Fb1/pTmAdj23xhm2/GpG9qhi4YbWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTvO6DEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTvO6DEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5422FC4CEF7;
	Sun, 29 Mar 2026 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744880;
	bh=wcXZVhlCf+DqNZVzrQmW26B653qbGulb5TMnhuwjhy8=;
	h=Date:To:From:Subject:From;
	b=oTvO6DEZwn/VfnID/w5JFj5zB2VFfP2fnN1QgUxJB/BdXwL9BdAVJ2R4ATPxcqFDK
	 ACo42d8a2EcYFAyzK9SLFO/d20m2bnojJw+7/Lb4KYKSP07a/UueLcPFxGDWDnOEYT
	 3X3TJgT+M2rAtPsOi76hagj7USc1JQPllTk2t4QQ=
Date: Sat, 28 Mar 2026 17:41:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch removed from -mm tree
Message-Id: <20260329004120.5422FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: refactor anon_enabled_store() with set_anon_enabled_mode()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: refactor anon_enabled_store() with set_anon_enabled_mode()
Date: Tue, 17 Mar 2026 08:33:57 -0700

Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
anon_enabled_store() into a new set_anon_enabled_mode() helper that loops
over an orders[] array, setting the bit for the selected mode and clearing
the others.

Introduce enum anon_enabled_mode and anon_enabled_mode_strings[] for the
per-order anon THP setting.

Use sysfs_match_string() with the anon_enabled_mode_strings[] table to
replace the if/else chain of sysfs_streq() calls.

The helper uses __test_and_set_bit()/__test_and_clear_bit() to track
whether the state actually changed, so start_stop_khugepaged() is only
called when needed.  When the mode is unchanged,
set_recommended_min_free_kbytes() is called directly to preserve the
watermark recalculation behavior of the original code.

Link: https://lkml.kernel.org/r/20260317-thp_logs-v7-2-31eb98fa5a8b@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   84 +++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode
+++ a/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobje
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS	= 0,
+	ANON_ENABLED_INHERIT	= 1,
+	ANON_ENABLED_MADVISE	= 2,
+	ANON_ENABLED_NEVER	= 3,
+};
+
+static const char * const anon_enabled_mode_strings[] = {
+	[ANON_ENABLED_ALWAYS]	= "always",
+	[ANON_ENABLED_INHERIT]	= "inherit",
+	[ANON_ENABLED_MADVISE]	= "madvise",
+	[ANON_ENABLED_NEVER]	= "never",
+};
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode)
+{
+	static unsigned long *enabled_orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_inherit,
+		&huge_anon_orders_madvise,
+	};
+	enum anon_enabled_mode m;
+	bool changed = false;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(enabled_orders); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(order, enabled_orders[m]);
+		else
+			changed |= __test_and_clear_bit(order, enabled_orders[m]);
+	}
+	spin_unlock(&huge_anon_orders_lock);
+
+	return changed;
+}
+
 static ssize_t anon_enabled_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(anon_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
-		int err;
+	if (set_anon_enabled_mode(order, mode)) {
+		int err = start_stop_khugepaged();
 
-		err = start_stop_khugepaged();
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
+
+	return count;
 }
 
 static struct kobj_attribute anon_enabled_attr =
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

