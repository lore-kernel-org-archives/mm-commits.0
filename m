Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9BD25771
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786504929; cv=none; b=m0XjEkwac+P4o9B98DTSYEMOfknvPLsZOdjkC948AOGVv/ccxOr95DlVtF+l+ccgrgkQJ4HUzoGUFMH+Q55iyJUMlamgQEefaQDPGAw5lfocfhOaNW3rL8hOVhNef3g/G8pS6MOUERdjPY2Tko9SMjXWJqyVoevCveVf4zBCzqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786504929; c=relaxed/simple;
	bh=jnucCEr6+k1lU1Vnf6xCrvkj3eC/Ero9nu0YkXuzl4Q=;
	h=Date:To:From:Subject:Message-Id; b=Cr0i9gCtGcfcP1s79ZbBlMFSsJGVVA1x3XuAv+8qk4bd8gRSXqTHt2gOY5GXl0KyjNkZsL5PqQ0WT27YCMiG5RCT46rN2xFyafEh+NAg2Rz5DQmknEPKxydL3fGU/U4e0X6aO6neg6wfTEROZHVUU2bhCJfr6C+Frb2QvKPHNxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SgZlj9Se; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SgZlj9Se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC19F1F00A3A;
	Wed, 12 Aug 2026 03:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786504927;
	bh=EJgfNFE7By2qPjOJgUYV+rdi6oWwrlJfNu1EFinXlys=;
	h=Date:To:From:Subject;
	b=SgZlj9SeLj/liKiOjLD108pOVLXa9RppoVMWIri3NdwpZGaFGj0p/f0+Ljx44zqro
	 Bl4DSlPxEWM48CApSN4IywdajY7pw8c/bNoSUVi3R0RnLmoMHbvDj1Lmm50WD/7EGb
	 KIbmcjX/xcZfx5cneQLAOO2N/kyG+VYyz10zHa5w=
Date: Tue, 11 Aug 2026 20:22:06 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch removed from -mm tree
Message-Id: <20260812032206.DC19F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch

This patch was dropped because it was folded into mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
Date: Tue Aug 11 06:18:29 PM PDT 2026

fix kerneldoc

Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/e7911812-9b99-4f94-be6b-597bf202ffeb@infradead.org
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
+++ a/include/linux/mm.h
@@ -2319,7 +2319,7 @@ static inline bool vma_flags_is_cow_mapp
 
 /**
  * vma_is_cow_mapping() - Is this VMA a CoW mapping?
- * @desc: The VMA to check.
+ * @vma: The VMA to check.
  *
  * See vma_flags_is_cow_mapping() for details.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

