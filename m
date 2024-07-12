Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFAD127E0F;
	Fri, 12 Jul 2024 22:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824891; cv=none; b=YHy7vP3cKCEZ0XTe/cpikBaEb+BQ+asvotGw9qW1mui1hXXtEli/zfDlyDyrLlrs2QJk2kicxrp5kQSaMepVaXQYGWdPCu3YNOo96xOZrHFsgqA4O+7w2lzG3QY/aRwKP8P35MY5cgDlfTWvR9XZ1NLxG6M/cMfX2mse1zBM7LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824891; c=relaxed/simple;
	bh=5ocFppO2ke6Eau1+Lz3iN7f80NvUKRn5NiwblW5uOBY=;
	h=Date:To:From:Subject:Message-Id; b=eENf+MOosoOMoMOMmJpTuzvYYg6oAUCcMmhVAtkm9mWpfCK10t72D8sKDQrOA377lvVSMrD5Hkmtl8HERNdlIz6Aa1uyzvGVYfe69x7iu03w1JJewFgXFnfkxSdGbiV4AFhHyDhikFB5oNv8toiRiwmIolMflFoc8lmelPITVHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2umoIpnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2umoIpnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22915C32782;
	Fri, 12 Jul 2024 22:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824891;
	bh=5ocFppO2ke6Eau1+Lz3iN7f80NvUKRn5NiwblW5uOBY=;
	h=Date:To:From:Subject:From;
	b=2umoIpnnyPJt2vqBMD1N8MeVKclg9SRe77LjwT3NET6p+f68gcceHP1WsApJC9Gcu
	 Q75O80FEF80kHgqn5eeMS9AgPNiOjTdnQDivvXF5xyzXuGguHXp33JKZA15dzmMw13
	 lwG23/55IOoAvaeFD7QKtf9yv2Ww6neH1N91QPI4=
Date: Fri, 12 Jul 2024 15:54:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shy828301@gmail.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-khugepaged-activation-policy.patch removed from -mm tree
Message-Id: <20240712225451.22915C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix khugepaged activation policy
has been removed from the -mm tree.  Its filename was
     mm-fix-khugepaged-activation-policy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: fix khugepaged activation policy
Date: Thu, 4 Jul 2024 10:10:50 +0100

Since the introduction of mTHP, the docuementation has stated that
khugepaged would be enabled when any mTHP size is enabled, and disabled
when all mTHP sizes are disabled.  There are 2 problems with this; 1. 
this is not what was implemented by the code and 2.  this is not the
desirable behavior.

Desirable behavior is for khugepaged to be enabled when any PMD-sized THP
is enabled, anon or file.  (Note that file THP is still controlled by the
top-level control so we must always consider that, as well as the PMD-size
mTHP control for anon).  khugepaged only supports collapsing to PMD-sized
THP so there is no value in enabling it when PMD-sized THP is disabled. 
So let's change the code and documentation to reflect this policy.

Further, per-size enabled control modification events were not previously
forwarded to khugepaged to give it an opportunity to start or stop. 
Consequently the following was resulting in khugepaged eroneously not
being activated:

  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  echo always > /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled

[ryan.roberts@arm.com: v3]
  Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240704091051.2411934-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Closes: https://lore.kernel.org/linux-mm/7a0bbe69-1e3d-4263-b206-da007791a5c4@redhat.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   11 ++----
 include/linux/huge_mm.h                    |   12 ------
 mm/huge_memory.c                           |    7 ++++
 mm/khugepaged.c                            |   33 ++++++++++++++-----
 4 files changed, 38 insertions(+), 25 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-fix-khugepaged-activation-policy
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -202,12 +202,11 @@ PMD-mappable transparent hugepage::
 
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
-khugepaged will be automatically started when one or more hugepage
-sizes are enabled (either by directly setting "always" or "madvise",
-or by setting "inherit" while the top-level enabled is set to "always"
-or "madvise"), and it'll be automatically shutdown when the last
-hugepage size is disabled (either by directly setting "never", or by
-setting "inherit" while the top-level enabled is set to "never").
+khugepaged will be automatically started when PMD-sized THP is enabled
+(either of the per-size anon control or the top-level control are set
+to "always" or "madvise"), and it'll be automatically shutdown when
+PMD-sized THP is disabled (when both the per-size anon control and the
+top-level control are "never")
 
 Khugepaged controls
 -------------------
--- a/include/linux/huge_mm.h~mm-fix-khugepaged-activation-policy
+++ a/include/linux/huge_mm.h
@@ -128,18 +128,6 @@ static inline bool hugepage_global_alway
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
-static inline bool hugepage_flags_enabled(void)
-{
-	/*
-	 * We cover both the anon and the file-backed case here; we must return
-	 * true if globally enabled, even when all anon sizes are set to never.
-	 * So we don't need to look at huge_anon_orders_inherit.
-	 */
-	return hugepage_global_enabled() ||
-	       READ_ONCE(huge_anon_orders_always) ||
-	       READ_ONCE(huge_anon_orders_madvise);
-}
-
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
--- a/mm/huge_memory.c~mm-fix-khugepaged-activation-policy
+++ a/mm/huge_memory.c
@@ -502,6 +502,13 @@ static ssize_t thpsize_enabled_store(str
 	} else
 		ret = -EINVAL;
 
+	if (ret > 0) {
+		int err;
+
+		err = start_stop_khugepaged();
+		if (err)
+			ret = err;
+	}
 	return ret;
 }
 
--- a/mm/khugepaged.c~mm-fix-khugepaged-activation-policy
+++ a/mm/khugepaged.c
@@ -413,6 +413,26 @@ static inline int hpage_collapse_test_ex
 	       test_bit(MMF_DISABLE_THP, &mm->flags);
 }
 
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * We cover both the anon and the file-backed case here; file-backed
+	 * hugepages, when configured in, are determined by the global control.
+	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 */
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+	    hugepage_global_enabled())
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
+		return true;
+	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct khugepaged_mm_slot *mm_slot;
@@ -449,7 +469,7 @@ void khugepaged_enter_vma(struct vm_area
 			  unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
-	    hugepage_flags_enabled()) {
+	    hugepage_pmd_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
 					    PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
@@ -2462,8 +2482,7 @@ breakouterloop_mmap_lock:
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) &&
-		hugepage_flags_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2536,7 +2555,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_flags_enabled())
+	if (hugepage_pmd_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2567,7 +2586,7 @@ static void set_recommended_min_free_kby
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_flags_enabled()) {
+	if (!hugepage_pmd_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2617,7 +2636,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_flags_enabled()) {
+	if (hugepage_pmd_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2643,7 +2662,7 @@ fail:
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_flags_enabled() && khugepaged_thread)
+	if (hugepage_pmd_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


