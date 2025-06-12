Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD2D770FE
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749693453; cv=none; b=JXtIkUuP5w0qNyZRnphsYZVOsEuoWnsRtkes4UNnDwQNgYhs2/v9aboiIiT+QCMxHhSPuPZTAk2umV9SDvX5lNt/b3ByZt8WOgSR9GPqH00DYGrxe0/696kx59Xg4VeHKLJZalXUn8+WRfBjznNAAMESpbXMDIK4Wv4map2ef2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749693453; c=relaxed/simple;
	bh=aN8I4bzOAuy+Wgwe75HqwmHMCY0AjYUDiOpbt6rUL5k=;
	h=Date:To:From:Subject:Message-Id; b=VZk09aRxa7GhbwUQe5k0UWJbOZpeyaHAOIwdYaxyjJfHrNbrFDXn+YWyyzpO0GbHQ2mY0oyTz6t26DZerwD+02Em4UP2+ijdAQJ4sktFpE4AoOkHW5QCzA91HZx5DCEQnv/NxVSSNxNhZNWKOwzN1uVr7PHJOEckr3JECroWzK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHEiYZo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHEiYZo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD85C4CEE3;
	Thu, 12 Jun 2025 01:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749693452;
	bh=aN8I4bzOAuy+Wgwe75HqwmHMCY0AjYUDiOpbt6rUL5k=;
	h=Date:To:From:Subject:From;
	b=jHEiYZo1bJnQgSKVIjGuyT+2u1GnKVMxjXY70AtBrsktRVsYgfkwVTHpa6DjZszwg
	 Aa2eDRLpuK05Gz1gbOhba4zpQmW343tecsbmZ/8YOQe8uirQm2r97TWjQ8TSwiIqiz
	 6jv29L9jdXcd3H0r+slEnL5fJl/9oFp6pBRzBdxs=
Date: Wed, 11 Jun 2025 18:57:32 -0700
To: mm-commits@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,corbet@lwn.net,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch added to mm-nonmm-unstable branch
Message-Id: <20250612015732.BAD85C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/core-api: min_heap: document _eqaware variants of min-heap APIs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Documentation/core-api: min_heap: document _eqaware variants of min-heap APIs
Date: Wed, 11 Jun 2025 05:55:15 +0800

Add documentation for equality-aware variants of min-heap maintenance
functions, which use a top-down sift_down strategy.  These variants,
suffixed with _eqaware, reduce the number of comparisons to O(1) in
workloads with many elements of equal priority and can be used as drop-in
replacements for their standard counterparts.

Link: https://lkml.kernel.org/r/20250610215516.1513296-8-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Robert Pang <robertpang@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/min_heap.rst |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/Documentation/core-api/min_heap.rst~documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis
+++ a/Documentation/core-api/min_heap.rst
@@ -30,6 +30,26 @@ more expensive. As with the non-inline v
 macro wrappers for inline functions instead of directly calling the functions
 themselves.
 
+Equality-Aware Heap Maintenance
+-------------------------------
+
+In some workloads, a large number of elements in the heap may be equal under
+the user-defined comparison function. For such cases, the standard
+``min_heap_sift_down()`` implementation, which uses the bottom-up heapify
+strategy, can be inefficient. While bottom-up heapify reduces the number of
+comparisons by approximately 50% for randomly ordered data, it may perform up
+to :math:`2 \times \log_2(n)` comparisons in the presence of many equal
+elements.
+
+To address this, equality-aware versions of heap maintenance APIs are provided.
+These versions use the traditional top-down heapify strategy, which performs
+better - sometimes requiring only :math:`\mathcal{O}(1)` comparisons - when
+many elements are equal.
+
+The equality-aware APIs are suffixed with ``_eqaware``, and serve as drop-in
+replacements for their standard counterparts when equal elements are expected.
+
+
 Data Structures
 ===============
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch
lib-min_heap-add-equal-elements-aware-sift_down-variant.patch
lib-min_heap-add-typedef-for-sift_down-function-pointer.patch
lib-min_heap-add-eqaware-variant-of-min_heapify_all.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop.patch
lib-min_heap-add-eqaware-variant-of-min_heap_pop_push.patch
lib-min_heap-add-eqaware-variant-of-min_heap_del.patch
documentation-core-api-min_heap-document-_eqaware-variants-of-min-heap-apis.patch
bcache-fix-the-tail-io-latency-regression-by-using-equality-aware-min-heap-api.patch

