Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212CC3C108E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896800; cv=none; b=VwC6NFzpzcAFK6RR0Hs42HlwEkdeAro5yzPTj09NR8i5WNlN5q0s0b4kpJAVS97oEvVB7mTmZ9MeNNK+IBtNl40mODocviATIZJpoy9Q9iahGrrKOaynv2PW5YeSy8OOkhuhqtcMNi3S2nbu69FjemSmqkL75Jm3Wb2E46mH8bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896800; c=relaxed/simple;
	bh=xig10D3n0gH6yIDLxbuq61ZB3pONucSnO0vOL4ci2EQ=;
	h=Date:To:From:Subject:Message-Id; b=U/QOrv4Eaa7IBJ6cjoAw/6HC8U5J2L0QqFEdHcjpPbmL463EVzQFr/tCmpOhy0614oi5lBdOD0DCLxuceZCHkSLS7HYVIdSvXlxEpTQ24Dl2oKCiXVvkxHRh5adVFn2n9YSBD++YCrSWo0czqnN6FpI0BS2PJL5NVd6zMR4ieqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQPobzIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQPobzIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE401F00A3A;
	Wed,  5 Aug 2026 02:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896798;
	bh=gKdPZNWLFJryXEGwf19cAuO2sb3L/9kGYJo8zi1NzqU=;
	h=Date:To:From:Subject;
	b=rQPobzIFVuy6oJsgrp4/Jrk8g8Hk4p5LhYng8FBeb/7gInMTasrlSuA6NSJSItfpS
	 AkPkaVGeGbz4NV5/WFc9BJt9SJ8F7+nCHp7F6jEQalWi5VqjwTymkALBJpJqm8Ftgm
	 cCNG5jmFtGW9hyuhgO0ObXJymRXenE+CxmSOm5q8=
Date: Tue, 04 Aug 2026 19:26:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-output-compared-expression-on-assert_.patch removed from -mm tree
Message-Id: <20260805022637.DDE401F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-output-compared-expression-on-assert_.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
Date: Fri, 10 Jul 2026 21:17:14 +0100

Update the macros to output the compared values at hex for easier debugging
when test asserts fail.

We have to be careful not to re-evaluate expressions as they may have
side-effects. So update the code to take local copies and use these for
both the test and the debug output.

Also remove unused IS_SET() macro.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/shared.h |   38 +++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/tools/testing/vma/shared.h~tools-testing-vma-output-compared-expression-on-assert_
+++ a/tools/testing/vma/shared.h
@@ -21,19 +21,35 @@
 		}							\
 	} while (0)
 
-#define ASSERT_TRUE(_expr)						\
-	do {								\
-		if (!(_expr)) {						\
-			fprintf(stderr,					\
-				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
-				__FILE__, __LINE__, __FUNCTION__, #_expr); \
-			return false;					\
-		}							\
+#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
+	do {								   \
+		if (!(_expr)) {						   \
+			fprintf(stderr,					   \
+				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
+				_fmt ".\n",				   \
+				__FILE__, __LINE__, __FUNCTION__, #_expr   \
+				__VA_OPT__(,) __VA_ARGS__);		   \
+			return false;					   \
+		}							   \
 	} while (0)
 
+#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
+
+#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
 #define ASSERT_FALSE(_expr) ASSERT_TRUE(!(_expr))
-#define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
-#define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
+#define ASSERT_EQ(_val1, _val2) do {				 \
+	__typeof__(_val1) __val1 = (_val1);			 \
+	__typeof__(_val2) __val2 = (_val2);			 \
+	__ASSERT_TRUE(__val1 == __val2, " (0x%llx != 0x%llx)",	 \
+		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
+	} while (0)
+
+#define ASSERT_NE(_val1, _val2) do {				 \
+	__typeof__(_val1) __val1 = (_val1);			 \
+	__typeof__(_val2) __val2 = (_val2);			 \
+	__ASSERT_TRUE(__val1 != __val2, " (0x%llx == 0x%llx)",	 \
+		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
+	} while (0)
 
 #define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
 	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
@@ -53,8 +69,6 @@
 #define ASSERT_FLAGS_NONEMPTY(_flags) \
 	ASSERT_FALSE(vma_flags_empty(_flags))
 
-#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
-
 extern bool fail_prealloc;
 
 /* Override vma_iter_prealloc() so we can choose to fail it. */
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

