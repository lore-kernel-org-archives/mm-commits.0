Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292514900E
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 04:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730175568; cv=none; b=LytRZQm7PQ8agE7tm6qA4AtAa5jN8waV8HQueDEk2TnsiBiLwUfXRefcBdO/eCTs9rREK65HqEUf3exo4q1zs/Nl+f1jqZbfscASt8fCtRZwizL3OhmYjDjOpI8pbEPebNKovE7BJQW5fvpCnAtWUhwNjcq2JwDeqyX1BH6IuIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730175568; c=relaxed/simple;
	bh=5wZ8wfNwxSfCllPsxnp6eL9fJqeHnNmvNZHDT05drmM=;
	h=Date:To:From:Subject:Message-Id; b=AUIthBYUNtdrITMyS6rY36MJTe6af/VXl9ScY2YSCWt1VcjRFj1i90vH/RATtWojawVYL5sgZJMcxvJEiSrymxWLQXWoRojIFDo8L21uc7afhEvnEO7AMTH6WbmJisapca/W8SY1wxVG6fNQy9GDPwhCvlWe+vxxQgkvLKJdXgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfpEaipQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfpEaipQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222F3C4CECD;
	Tue, 29 Oct 2024 04:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730175568;
	bh=5wZ8wfNwxSfCllPsxnp6eL9fJqeHnNmvNZHDT05drmM=;
	h=Date:To:From:Subject:From;
	b=dfpEaipQswbkWuCVVW3Y45ReIohfj7/+HTdQ/K5hovzeRYPqpxkyhS3/LkzD9PCNx
	 Eq9DjZIcRnUTcg/qBbq0GyR7Pj2dXYSCDPpsVKktWkRtg/1W1jCoCCbhwZy+3zuVmh
	 uFjH6Cg63dXvGgcUidM01DJabgmFJrE71BbCqSwI=
Date: Mon, 28 Oct 2024 21:19:27 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entry-for-min-heap-library-code.patch added to mm-nonmm-unstable branch
Message-Id: <20241029041928.222F3C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add entry for min heap library code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-entry-for-min-heap-library-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entry-for-min-heap-library-code.patch

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
Subject: MAINTAINERS: add entry for min heap library code
Date: Sun, 27 Oct 2024 08:40:03 +0800

Add a new entry in the MAINTAINERS file for the min heap library code,
with myself as the maintainer.  I am pleased to take on the responsibility
of maintaining and reviewing patches for this library, as I am
well-acquainted with its details through recent contributions.

Link: https://lkml.kernel.org/r/20241027004003.987934-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-min-heap-library-code
+++ a/MAINTAINERS
@@ -15403,6 +15403,15 @@ F:	arch/arm/boot/dts/marvell/armada-xp-c
 F:	arch/arm/boot/dts/marvell/armada-xp-crs328-4c-20s-4s-bit.dts
 F:	arch/arm/boot/dts/marvell/armada-xp-crs328-4c-20s-4s.dts
 
+MIN HEAP
+M:	Kuan-Wei Chiu <visitorckw@gmail.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/core-api/min_heap.rst
+F:	include/linux/min_heap.h
+F:	lib/min_heap.c
+F:	lib/test_min_heap.c
+
 MIPI CCS, SMIA AND SMIA++ IMAGE SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch
lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch
lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch
lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch
lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch
perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch
dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch
bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch
documentation-core-api-add-min-heap-api-introduction.patch
maintainers-add-entry-for-min-heap-library-code.patch

