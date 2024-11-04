Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42012290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695976; cv=none; b=kkeq6HlN8hRi17UUs0m3BkCu1u299qLtWE7RbdCU4bLfCbN9T+pHRBnuaFkzyiQvsH0SA/7f9afydptKCs1SNwdEux2tBd76asKDhCRX0eRtSC9sRuUf/6EaBQc2qwAGImIeSTrwFykNbs/I3dgsGq0eTCkgf8U55c4vaHRGEwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695976; c=relaxed/simple;
	bh=xg/bqiirW8hyWlhf3Vtw2k/8DvHtk27+SdeOQgpGOO0=;
	h=Date:To:From:Subject:Message-Id; b=Bhg86Yze2TLKtMwv6PAxRbaDbtA4RtNx9V8Y3xCP4EUS25gRf8KdJCwQ0dS4RU522GO57H4IVWTV4P7vtG8NMIzydiW2n3ZNI2ZD4jk3ETg472Ns/HZ27dT9kyjtbPaCm8Ll4oOeo08lwlH0QF3ZajcvlEWTPWNIG9/5ZhkUEbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dcxSHbe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dcxSHbe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC932C4CECE;
	Mon,  4 Nov 2024 04:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695975;
	bh=xg/bqiirW8hyWlhf3Vtw2k/8DvHtk27+SdeOQgpGOO0=;
	h=Date:To:From:Subject:From;
	b=dcxSHbe6Jt0Ni+ST1iWX9SICmjJRWuzXk4LJjvKmxv02g7dhhn8re7op+X5D5eV3O
	 rjPIlJTm4Lp7TlQU58sCug3u7URCZUmWKr8RFpkHlyrOdMcGDElwgW7m7m6I7mWdmq
	 JYxnp9lTrBXKiqn7S1nEfpiQ+BA6rIOwfGk+1mEg=
Date: Sun, 03 Nov 2024 20:52:55 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch removed from -mm tree
Message-Id: <20241104045255.BC932C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch

This patch was dropped because it was folded into mm-kasan-kmsan-copy_from-to_kernel_nofault.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
Date: Tue Oct 15 04:53:38 PM PDT 2024

fix comment layout, per checkpatch

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kmsan-copy_from-to_kernel_nofault-fix
+++ a/mm/kasan/kasan_test_c.c
@@ -1934,8 +1934,10 @@ static void copy_to_kernel_nofault_oob(s
 	char buf[128];
 	size_t size = sizeof(buf);
 
-	/* This test currently fails with the HW_TAGS mode.
-	 * The reason is unknown and needs to be investigated. */
+	/*
+	 * This test currently fails with the HW_TAGS mode. The reason is
+	 * unknown and needs to be investigated.
+	 */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
 
 	ptr = kmalloc(size - KASAN_GRANULE_SIZE, GFP_KERNEL);
@@ -1943,16 +1945,16 @@ static void copy_to_kernel_nofault_oob(s
 	OPTIMIZER_HIDE_VAR(ptr);
 
 	/*
-	* We test copy_to_kernel_nofault() to detect corrupted memory that is
-	* being written into the kernel. In contrast, copy_from_kernel_nofault()
-	* is primarily used in kernel helper functions where the source address
-	* might be random or uninitialized. Applying KASAN instrumentation to
-	* copy_from_kernel_nofault() could lead to false positives.
-	* By focusing KASAN checks only on copy_to_kernel_nofault(),
-	* we ensure that only valid memory is written to the kernel,
-	* minimizing the risk of kernel corruption while avoiding
-	* false positives in the reverse case.
-	*/
+	 * We test copy_to_kernel_nofault() to detect corrupted memory that is
+	 * being written into the kernel. In contrast,
+	 * copy_from_kernel_nofault() is primarily used in kernel helper
+	 * functions where the source address might be random or uninitialized.
+	 * Applying KASAN instrumentation to copy_from_kernel_nofault() could
+	 * lead to false positives.  By focusing KASAN checks only on
+	 * copy_to_kernel_nofault(), we ensure that only valid memory is
+	 * written to the kernel, minimizing the risk of kernel corruption
+	 * while avoiding false positives in the reverse case.
+	 */
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		copy_to_kernel_nofault(&buf[0], ptr, size));
 	KUNIT_EXPECT_KASAN_FAIL(test,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

