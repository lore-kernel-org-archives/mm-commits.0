Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0D407599
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723660; cv=none; b=Rbi4EO8QKtTAK7Mbp/N6w3tTaaifINdWiAs6cmlpnIbW9oH5EFkajz84ZKBSRkv36rlvn4SZFVlD9U+Fz3weOWCmaGtBTxrNAY6k/qGzvrq+p5iXVFZqKpFe0b/rmiLn0hzixgDOMxDXwrAR8GTDhreLnHd/zaIcAQs03aWZZkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723660; c=relaxed/simple;
	bh=pg0zpkS93bTdrhnRTGgFVB5ErSbP9Azppkr3CeresJo=;
	h=Date:To:From:Subject:Message-Id; b=e5vibxGq3bKNTbNqJPFtZXjkHfF9dL24HhzTMmpcZzNerN1WH/qkVEPyX+8n256BK+kHripmqkklN3RKcpoxA7R061iP/joCb3Tgr+b6H8eBmPTWifVbukTBuh2cBkmmKAKm2miwUg/USzcuT/VLNw5Lrs1QfhuOapZA9KoMsKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t4OI3EE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t4OI3EE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DA41F000E9;
	Fri, 10 Jul 2026 22:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723658;
	bh=6rJVrE/1eMC6/84sdKr9Qqgk3ykGIjYaOMU70PTC++Y=;
	h=Date:To:From:Subject;
	b=t4OI3EE9DNI5SWca4G6CKb9vXDoIpFGD9B4+ljdJ1rO4pt8ZmZfU8Pl9biEDJG52C
	 rERBEUi0W4bXlvEIj2jsusvyb+bTArtSUbcuY60ARRl4UzLf4iET2ppEiRub/lbw0U
	 bcCulq2wkadjlhCrPWm2sBK32PxHxpvnXn7Kn6vY=
Date: Fri, 10 Jul 2026 15:47:38 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-output-compared-expression-on-assert_.patch added to mm-new branch
Message-Id: <20260710224738.85DA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-output-compared-expression-on-assert_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-output-compared-expression-on-assert_.patch

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

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

