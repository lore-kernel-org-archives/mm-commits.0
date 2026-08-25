Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB334887E
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622864; cv=none; b=WCR9Eej74MkJeyOroWK4qHIfBYCKvaVLfqw3EEIKsqWmha/mEvTqOad+VDco3GIMcyqcC83bOXA/V9FNK2AVZ+wvW/8ueCNsB/q9yDHLFx945VPzlpnstK219VFmYDP9c8JDf7FfF1qC2/hZ6z2aRLSD5vZqvKipBnEN3jA+I7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622864; c=relaxed/simple;
	bh=ZydQ6bGSmTzxQTsNWHQDcl9N+6ANxgKsvuuRBxu33Cc=;
	h=Date:To:From:Subject:Message-Id; b=oRqglcqgPGMyu7/GCN8C/IyBsOQWmjeOvZUg1lx9odDrJk/eJv9H6iDsfPRd0hUYNjHCXZmWJy5kQQsxH8GLwcGw4aD9wsPGjA6oiMTqy7vXDU5lUgGz2y5DIyuutOGvl5d21McI/8EwKL9lzTD+cdr+Z7SxZZFAZMM8CWanz0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PmX2yrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PmX2yrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1761F000E9;
	Tue, 25 Aug 2026 01:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622863;
	bh=3u2dy/nbCeJwIwAcP8im635BWShm/1/6WlPhGNGyZwc=;
	h=Date:To:From:Subject;
	b=0PmX2yrLsO2N+WXh45yJN5cR97sN1MCRLNLRfCU2hegQy/fJz8kT5YqJGugscLCF3
	 6Y6ONFlyQ3ZnoZrboAPONsmcca9PZOkD3cF4TjrsyKkGRM8vp4RuxxhqxsAhj/BzvI
	 +RFr7ZFwgGvLuCFMCxYnfa6ItBgXVzsRBC976ZAU=
Date: Mon, 24 Aug 2026 18:54:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch removed from -mm tree
Message-Id: <20260825015423.3A1761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Mon, 27 Jul 2026 10:52:18 +0100

The hole_punch case verifies that guard regions survive MADV_REMOVE and
that the backing range is punched out.  MADV_REMOVE delegates the hole
punch to the backing filesystem, which may reject the operation with
EOPNOTSUPP.

That result means the test cannot establish the state whose guard
semantics it intends to validate.  Treating the missing filesystem
capability as a guard-region failure creates a false regression.

Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP. 
Preserve the assertion for all other errors so failures on supported
configurations remain visible.

Link: https://lore.kernel.org/20260727095225.372655-3-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
 {
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	int i, ret;
 
 	if (variant->backing == ANON_BACKED)
 		SKIP(return, "Truncation test specific to file-backed");
@@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
 	}
 
 	/* Now hole punch the guarded region. */
-	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
-			  MADV_REMOVE), 0);
+	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
+	if (ret == -1 && errno == EOPNOTSUPP) {
+		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+		SKIP(return, "MADV_REMOVE not supported by filesystem");
+	}
+	ASSERT_EQ(ret, 0);
 
 	/* Ensure guard regions remain. */
 	for (i = 0; i < 10; i++) {
_

Patches currently in -mm which might be from usama.anjum@arm.com are


