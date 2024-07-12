Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFB73501;
	Fri, 12 Jul 2024 22:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824464; cv=none; b=d6VfzEb0ptszyu963Mg+EB1pS7RTEh1pHl+Y+Vo0wDaBNTU12qXTcLZGgQ5QDEWhOcITxLDWS6uzN8JuwabNjRIhNan1qEfJzFc5/LHD0SgLrZV81ao9b3zCBk4UCdaAF2/cEUo+RT++n4xfap5oQYf4xNR8xcP6xgM5HmyFk6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824464; c=relaxed/simple;
	bh=gRiU7/EA212cMOIQDo8UkzabmqYFQWqDAGTwQzizaK8=;
	h=Date:To:From:Subject:Message-Id; b=mq+pGmlyAs6fZq94qv6yUsxabkyFg/Wi97UeFU9EToj6Z7t+HMt0YNJjw8Zz8rfvVOy6IoYPRxaiD9fokBKw5C1RmE+b9hXC3NHEjwww/gNAB3hqh6hl8FFQB7IspRc13FQumBB6iHObqEXEK7nRcIxFobZJ0TLinHWbg5B3baQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MrdPFDm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MrdPFDm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FF7C32782;
	Fri, 12 Jul 2024 22:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824464;
	bh=gRiU7/EA212cMOIQDo8UkzabmqYFQWqDAGTwQzizaK8=;
	h=Date:To:From:Subject:From;
	b=MrdPFDm6KMDv1vtDtqMdZVGF4mo62x/vftOQ7FpHuwPRhGowOEGLGCCUpu2H3vkV6
	 VokYNjgqMcyao1nMCpuR8eiGwGL6TF1o1OnkYiHEU0Jn067V7RZfHF1VrftmNFmAI4
	 JMzSJtiyQGKlY5UuMIwgYVnNKXCgKtStYjEJiHu4=
Date: Fri, 12 Jul 2024 15:47:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shy828301@gmail.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-khugepaged-activation-policy-v3.patch removed from -mm tree
Message-Id: <20240712224744.01FF7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-khugepaged-activation-policy-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-khugepaged-activation-policy-v3.patch

This patch was dropped because it was folded into mm-fix-khugepaged-activation-policy.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-fix-khugepaged-activation-policy-v3
Date: Fri, 5 Jul 2024 11:28:48 +0100

- Make hugepage_pmd_enabled() out-of-line static in khugepaged.c (per Andrew)
- Refactor hugepage_pmd_enabled() for better readability (per Andrew)

Link: https://lkml.kernel.org/r/20240705102849.2479686-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Closes: https://lore.kernel.org/linux-mm/7a0bbe69-1e3d-4263-b206-da007791a5c4@redhat.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   13 -------------
 mm/khugepaged.c         |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-fix-khugepaged-activation-policy-v3
+++ a/include/linux/huge_mm.h
@@ -128,19 +128,6 @@ static inline bool hugepage_global_alway
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
-static inline bool hugepage_pmd_enabled(void)
-{
-	/*
-	 * We cover both the anon and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 */
-	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && hugepage_global_enabled()) ||
-	       test_bit(PMD_ORDER, &huge_anon_orders_always) ||
-	       test_bit(PMD_ORDER, &huge_anon_orders_madvise) ||
-	       (test_bit(PMD_ORDER, &huge_anon_orders_inherit) && hugepage_global_enabled());
-}
-
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
--- a/mm/khugepaged.c~mm-fix-khugepaged-activation-policy-v3
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
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-fix-khugepaged-activation-policy.patch
mm-shmem-rename-mthp-shmem-counters.patch

