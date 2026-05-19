Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ADE345CAF
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779218573; cv=none; b=MQ+fDkPqbsOZtioBF4ww9BkeLwSMpHiI5haeu1941RtaGgUuP48pCNjQFnsKAzU/imKzjU8K4UtA/bE7k70w8ezvt8sWV+TPZ5BRU03DzQPppndZsbHiDf2cOYWS+chVAcy+lopehgmPXhKSenr0fbwX8eYy19RZQ6iJffD0Aq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779218573; c=relaxed/simple;
	bh=GWQDeEpoTquTt2xxqWQSobbYXuYC8rlYSY4NpaLatPc=;
	h=Date:To:From:Subject:Message-Id; b=F/MBeZWh0ozwytEMyHf9pFYVcIuKz4/qduq5+vpiaFF1cbCUYGdyO3daZ5CSxuHW9zvq9O80bNaTvyc+mKIl86pKZLBqE0xs/TCTc9JeWLNBshTVPF08e+RAId3hKHHraqkdJHtAQuKLm5ZgF3QPu8H/qU6p/XH8OLSUptzxHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pK91MFca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pK91MFca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E111F000E9;
	Tue, 19 May 2026 19:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779218572;
	bh=Klo32X/MeAMsb7fPEfyoqjFxT+nxHU/SSjlvqUKJMWg=;
	h=Date:To:From:Subject;
	b=pK91MFcamMYSGVBYixTXRxGMXlDEhcden1h4Byb6WTDc7rlQPI+uDeSAWbLImN69W
	 FlwjAwJ92ALFRyZTLxkGHJjhQac90yVjtZ7tlzXVk+Z72SudH2Pi9iiy9BQb52Xuzi
	 HcM5PZTYIhSYyOsoWUCfIctaIEiKvc+GjjvmaG08=
Date: Tue, 19 May 2026 12:22:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch added to mm-new branch
Message-Id: <20260519192252.19E111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: shmem: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Mon, 18 May 2026 12:32:37 +0000

Patch series "refactors thpsize_shmem_enabled_store() and
thpsize_shmem_enabled_show()", v3.


This patch (of 2):

Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
anon_enabled_store() with set_anon_enabled_mode()"), refactor
thpsize_shmem_enabled_store() using sysfs_match_string().  This eliminates
the duplicated spin_lock/unlock(), set/clear_bit(), calls across all
branches, reducing code duplication.

Behavioral change:
Call start_stop_khugepaged() only when the mode actually changes.  If
unchanged, call set_recommended_min_free_kbytes() to preserve legacy
watermark behavior.  This avoids unnecessary khugepaged restarts.

Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
all test cases passed.

Link: https://lore.kernel.org/20260518123238.56344-1-ranxiaokai627@163.com
Link: https://lore.kernel.org/20260518123238.56344-2-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>
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
 
+enum huge_shmem_enabled_mode {
+	HUGE_SHMEM_ENABLED_ALWAYS = 0,
+	HUGE_SHMEM_ENABLED_INHERIT,
+	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
+	HUGE_SHMEM_ENABLED_ADVISE,
+	HUGE_SHMEM_ENABLED_NEVER,
+};
+
+static const char * const huge_shmem_enabled_mode_strings[] = {
+	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
+	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
+	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
+	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
+	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
+};
+
+static unsigned long * const huge_shmem_orders_by_mode[] = {
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
 
+static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
+{
+	bool changed = false;
+	enum huge_shmem_enabled_mode idx;
+
+	spin_lock(&huge_shmem_orders_lock);
+	for (idx = 0; idx < ARRAY_SIZE(huge_shmem_orders_by_mode); idx++) {
+		if (idx == mode)
+			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[idx]);
+		else
+			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[idx]);
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
+	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
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

mm-shmem-refactor-thpsize_shmem_enabled_store-with-sysfs_match_string.patch
mm-shmem-refactor-thpsize_shmem_enabled_show-with-helper-arrays.patch

