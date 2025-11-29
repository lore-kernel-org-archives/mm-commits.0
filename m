Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF5B257459;
	Sat, 29 Nov 2025 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764439095; cv=none; b=U15DEdaBPQLq88Qxl5gUJjOg2nPg543V8iqgLRGWZCDbkfx3lOwbVYD+ET0wAnGe76ubK9rajrzNmolhQweWMu2e0bkA4vyi8CxuWXvOvimDUOrQX9QMK1H5MLQZQC+Xh5nWWunHa68WgTgXS/yZskMDMiS79oT9yPrJHWHA1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764439095; c=relaxed/simple;
	bh=F9PzxWJcm8Dr2q97EL2L8b6dlYERtrGM1VC8ZI1y2Xg=;
	h=Date:To:From:Subject:Message-Id; b=pV/A+aeCRlfEpzWx/BPx4x0hQro6rxQLSmkna9C5XhFltL1HLhswkx1osTYwCFquMoXpCocc7WatxWS1RD5VObGz6PNehbJQ2LKjUkT/GlAuXVhHc5U97NURS0IqwSqQF8dkJFXjzxIs3j9p53HiZhfW7I2P9NEqDIXDBlAhrfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ErYftYKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ErYftYKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318EC4CEF7;
	Sat, 29 Nov 2025 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764439095;
	bh=F9PzxWJcm8Dr2q97EL2L8b6dlYERtrGM1VC8ZI1y2Xg=;
	h=Date:To:From:Subject:From;
	b=ErYftYKHSSWzG/TntlsVE+WGSV9J0y2mpy7aiuOechJECUmJKc8QflMqz6cQ8B3fH
	 SwtkPQhBhLfLUPJIvKXl1rT+8ucpCTp/u7CUj0bFxEjBpF3jryof7iEazk53fqUCqN
	 6vgz7+2/lwWPRnsHDhexQf0XzQchsnBcgaU3Uhts=
Date: Sat, 29 Nov 2025 09:58:14 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peter.senna@linux.intel.com,koen.koning@intel.com,jan.sokolowski@intel.com,christian.koenig@amd.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + idr-fix-idr_alloc-returning-an-id-out-of-range.patch added to mm-hotfixes-unstable branch
Message-Id: <20251129175814.E318EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: idr: fix idr_alloc() returning an ID out of range
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     idr-fix-idr_alloc-returning-an-id-out-of-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/idr-fix-idr_alloc-returning-an-id-out-of-range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: idr: fix idr_alloc() returning an ID out of range
Date: Fri, 28 Nov 2025 16:18:32 +0000

If you use an IDR with a non-zero base, and specify a range that lies
entirely below the base, 'max - base' becomes very large and
idr_get_free() can return an ID that lies outside of the requested range.

Link: https://lkml.kernel.org/r/20251128161853.3200058-1-willy@infradead.org
Fixes: 6ce711f27500 ("idr: Make 1-based IDRs more efficient")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jan Sokolowski <jan.sokolowski@intel.com>
Reported-by: Koen Koning <koen.koning@intel.com>
Reported-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6449
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c                           |    2 ++
 tools/testing/radix-tree/idr-test.c |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/lib/idr.c~idr-fix-idr_alloc-returning-an-id-out-of-range
+++ a/lib/idr.c
@@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void
 
 	if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
 		idr->idr_rt.xa_flags |= IDR_RT_MARKER;
+	if (max < base)
+		return -ENOSPC;
 
 	id = (id < base) ? 0 : id - base;
 	radix_tree_iter_init(&iter, id);
--- a/tools/testing/radix-tree/idr-test.c~idr-fix-idr_alloc-returning-an-id-out-of-range
+++ a/tools/testing/radix-tree/idr-test.c
@@ -57,6 +57,26 @@ void idr_alloc_test(void)
 	idr_destroy(&idr);
 }
 
+void idr_alloc2_test(void)
+{
+	int id;
+	struct idr idr = IDR_INIT_BASE(idr, 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
+	assert(id == 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	idr_destroy(&idr);
+}
+
 void idr_replace_test(void)
 {
 	DEFINE_IDR(idr);
@@ -409,6 +429,7 @@ void idr_checks(void)
 
 	idr_replace_test();
 	idr_alloc_test();
+	idr_alloc2_test();
 	idr_null_test();
 	idr_nowait_test();
 	idr_get_next_test(0);
_

Patches currently in -mm which might be from willy@infradead.org are

idr-fix-idr_alloc-returning-an-id-out-of-range.patch
mm-fix-vma_start_write_killable-signal-handling.patch

