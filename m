Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F351D7E5C
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802957; cv=none; b=qQGpgu0zNeiIz1sY+NrA57u2yEDX6YbuOzhzgffRtdFCdOM0z2Furd7rzrrDAp9QfgNdRV8OSC+UfDd44X6CoHlLVLh5IzCV03nwxuV/LIDY0ScoLwcf5/EbK7/3hyLUGnCuUGACzc7MxnzNXIR1Qw+V9k/BFRI6NlYEWq5W55g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802957; c=relaxed/simple;
	bh=FFTed6qS7B/aMWaE5KGqPHFPBzUrKSZ9v9+7YROq+z0=;
	h=Date:To:From:Subject:Message-Id; b=crda4uaXVbQkJHapFAOXiZjtHtVGShzq4T3zv+hwkw/3nv4WKmcBSKZWmTVMSMdCn5jpL8rcNRkrXzl1ROn33lF60m6MBTQ9Qwfi2YQegT+UQam6pdSVHWtUGcUjpBoIKhFtK8Fr34snENY0MRzTRmIsqJ59Sa8jA0PZSRuRQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YiyaLX6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YiyaLX6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104F9C4CED6;
	Tue, 10 Dec 2024 03:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733802957;
	bh=FFTed6qS7B/aMWaE5KGqPHFPBzUrKSZ9v9+7YROq+z0=;
	h=Date:To:From:Subject:From;
	b=YiyaLX6jcd0oZS7mMBFMIrBya50W44btNgUcKX9brU4wvqpo7mj5Grf4+PV6ANO1j
	 loVrfN/qTEgPYyvR9daQz++itVmgNSpQ8vkRefvOsYRUyp5dklHWer73HaesN3At4C
	 xicFxy5kwLxyLx5GAQQszASJWhItWYpQ8Cy8kFuk=
Date: Mon, 09 Dec 2024 19:55:56 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,mjguzik@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch added to mm-unstable branch
Message-Id: <20241210035557.104F9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
Date: Mon Dec  9 07:53:02 PM PST 2024

add comment from David

Link: https://lkml.kernel.org/r/f5a65bf5-5105-4376-9c1c-164a15a4ab79@redhat.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/page_ref.h~mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
+++ a/include/linux/page_ref.h
@@ -234,8 +234,15 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page))
+	if (!page_is_fake_head(page)) {
+		/*
+		 * atomic_add_unless() will currently never modify the value
+		 * if it already is u. If that ever changes, we'd have to have
+		 * a separate check here, such that we won't be writing to
+		 * write-protected vmemmap areas.
+		 */
 		ret = atomic_add_unless(&page->_refcount, nr, u);
+	}
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

