Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FB34A795;
	Tue, 23 Dec 2025 19:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517838; cv=none; b=ezPXPXoBZNFXkU2rmcBrnJEEs38/JdmawiZ8/MWNCLm50Y499qe+ahYfXAo76PNdM8JD3hSEFC6VcjTdD9lfvP+5Su7Bry6w74YiudkljlvjQwUdfLi2wPrNvQYAc6IqHHkemSP0FBYdGgXWFhWoqOJsbCBOT0xTtCFq8M1X6B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517838; c=relaxed/simple;
	bh=J5e8hfWuaT4XVshPRDUbfOz+Djs1I8yAoVwt1CsuwZo=;
	h=Date:To:From:Subject:Message-Id; b=LoOGq9pEdogcEtOFsTC/DUbELQlfGew+SLHa3BNPp3n9pOSXle7amA50mbYJDiYmyaqzsdQhP/C7vnP4Ky/KNjPo+bpnR1dFHlq6TYilADcqzJgnKrEFCqqelxF1hEKEPMApq2PgoHIu4tr7lBBfzge2fm8tsJuOnHZwR24r1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=00F+bwxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="00F+bwxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F41C113D0;
	Tue, 23 Dec 2025 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517837;
	bh=J5e8hfWuaT4XVshPRDUbfOz+Djs1I8yAoVwt1CsuwZo=;
	h=Date:To:From:Subject:From;
	b=00F+bwxPrChUO4pJ5pAgk0dAJ2Ya7kH75GwDgNRqTnzmFaWQh8JMy3voUCev02oTC
	 L2V4LJd2TXIO/ZOvhIJKY4ZepWAgQb6v3lyeo1zZ+YQ8dMZoXWeM8sfLwdSWXiBj6n
	 Il/fly7qQreYaPXpY6WgV5iKKFLSrbLc2m80rtwE=
Date: Tue, 23 Dec 2025 11:23:57 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peter.senna@linux.intel.com,koen.koning@intel.com,jan.sokolowski@intel.com,christian.koenig@amd.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] idr-fix-idr_alloc-returning-an-id-out-of-range.patch removed from -mm tree
Message-Id: <20251223192357.A3F41C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: idr: fix idr_alloc() returning an ID out of range
has been removed from the -mm tree.  Its filename was
     idr-fix-idr_alloc-returning-an-id-out-of-range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


