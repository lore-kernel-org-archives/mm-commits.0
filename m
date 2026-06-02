Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DEF3C3443
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439205; cv=none; b=qu3ZZAt/+HJFXzELCiuBfeexOantmQzhmTblEzpR70V0wbV7g76FwWBmVAJqQWKwF65KGtU4llfQcS1VUOdvqmA1jtR1PkSg7jF5zdyewsxy9dvqQ3x0pKQa1lDReEg2vTUEhvQlsruQ2t7HiRASPaZsraj2msSRzsLRwrjdOew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439205; c=relaxed/simple;
	bh=kvx7ohWUkAQAus2rwaNLkjOFJjKkcGh6ZwBZcSaUuvk=;
	h=Date:To:From:Subject:Message-Id; b=RhhG+t/Yl5tTXYPQPmNAmvykxWGGEcDPUh/mJ1WyQKS8ULoUXGuyaZdu6NBLpz2k8HFajvqGC+7VhLexpih4zdJLwwXw9V8+FWdj3189tT2hCc5FNnkaTbFx3wn2y8YtSKVNclNB9dxnM7rFUw0JziSTC6P3Tn0G/smjEjSika0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pWI414w+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pWI414w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0181F00893;
	Tue,  2 Jun 2026 22:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439203;
	bh=e1idb4/IemBMh8NiJdrGfqkIk2Q13x9H3oPSA3UM/dA=;
	h=Date:To:From:Subject;
	b=pWI414w++5PM2zdyqSUv0lGHx23vKrx0WyHxt19TeVU9bwhh70ISTfqSrydUwQMhz
	 1/nbJYulFflO3hiJmT2SW7Q1fD/dGJkOc3rm6w/OAkTR8zv6R5+ZXZAlyHy4CaMZib
	 TQumnRoK6FG9VEgVvuz/dRKLe90PyK5Kexzm9KjA=
Date: Tue, 02 Jun 2026 15:26:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch removed from -mm tree
Message-Id: <20260602222643.BC0181F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
has been removed from the -mm tree.  Its filename was
     mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Mon, 25 May 2026 10:26:59 +0000

Patch series "refactors thpsize_shmem_enabled_store() and
thpsize_shmem_enabled_show()", v4.


This patch (of 2):

Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
anon_enabled_store() with set_anon_enabled_mode()"), refactor
thpsize_shmem_enabled_store() using sysfs_match_string().  This eliminates
the duplicated spin_lock/unlock(), set/clear_bit(), calls across all
branches, reducing code duplication.

Behavioral change:
Call start_stop_khugepaged() only when the mode actually changes.
If unchanged, call set_recommended_min_free_kbytes() to preserve
legacy watermark behavior. This avoids unnecessary khugepaged restarts.

Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
all test cases passed.

Link: https://lore.kernel.org/20260525102700.68707-1-ranxiaokai627@163.com
Link: https://lore.kernel.org/20260525102700.68707-2-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  107 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 47 deletions(-)

--- a/mm/shmem.c~mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string
+++ a/mm/shmem.c
@@ -5463,6 +5463,29 @@ static ssize_t shmem_enabled_store(struc
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
 static DEFINE_SPINLOCK(huge_shmem_orders_lock);
 
+enum huge_mode {
+	HUGE_SHMEM_ENABLED_ALWAYS = 0,
+	HUGE_SHMEM_ENABLED_INHERIT,
+	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
+	HUGE_SHMEM_ENABLED_ADVISE,
+	HUGE_SHMEM_ENABLED_NEVER,
+};
+
+static const char * const huge_mode_strings[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
+	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
+	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
+	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
+};
+
+static unsigned long * const huge_mode_orders[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
+	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
+	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
+};
+
 static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
@@ -5483,63 +5506,53 @@ static ssize_t thpsize_shmem_enabled_sho
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool set_shmem_enabled_mode(int order, enum huge_mode mode)
+{
+	bool changed = false;
+	enum huge_mode idx;
+
+	spin_lock(&huge_shmem_orders_lock);
+	for (idx = 0; idx < ARRAY_SIZE(huge_mode_orders); idx++) {
+		if (idx == mode)
+			changed |= !__test_and_set_bit(order, huge_mode_orders[idx]);
+		else
+			changed |= __test_and_clear_bit(order, huge_mode_orders[idx]);
+	}
+	spin_unlock(&huge_shmem_orders_lock);
+
+	return changed;
+}
+
 static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_always);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		/* Do not override huge allocation policy with non-PMD sized mTHP */
-		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
-			return -EINVAL;
-
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_inherit);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "within_size")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		set_bit(order, &huge_shmem_orders_within_size);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "advise")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		set_bit(order, &huge_shmem_orders_madvise);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_shmem_orders_lock);
-		clear_bit(order, &huge_shmem_orders_always);
-		clear_bit(order, &huge_shmem_orders_inherit);
-		clear_bit(order, &huge_shmem_orders_within_size);
-		clear_bit(order, &huge_shmem_orders_madvise);
-		spin_unlock(&huge_shmem_orders_lock);
-	} else {
-		ret = -EINVAL;
-	}
+	mode = sysfs_match_string(huge_mode_strings, buf);
+	if (mode < 0)
+		return mode;
+
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
+	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (set_shmem_enabled_mode(order, mode)) {
 		int err = start_stop_khugepaged();
-
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode hasn't changed
+		 * to preserve the legacy behavior, as this is always called
+		 * inside start_stop_khugepaged().
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+
+	return count;
 }
 
 struct kobj_attribute thpsize_shmem_enabled_attr =
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


