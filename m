Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D9370ADD
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067221; cv=none; b=CJDGa29VozDO31XggLnpOtK9G79YmXcc56pcOSUDIi/bHJ0XSn5AokW9dhNEKxdB84RSmeVQY+RtuBeuxB+70OXVgD99VTw5Zb+uTbiU1iRmK8GIeXUrgBssdK5bAciMVfywPFt6k934pgvYUDEDnDOEa9WgB8W3qwu67v09UDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067221; c=relaxed/simple;
	bh=7YKk8VzY2GNIj8JDlC01861a3smj+6mj+NnFs4DkSEk=;
	h=Date:To:From:Subject:Message-Id; b=PkrkPxJkp6iJARI7ASxZQvyWUf3VZiThc1rYvudnGPtOj+p8XaH0Q0SeiY9ABX/qEGNjnk1qzz0YlJxMXXEf927IaUhrW7/27yZKMhpw/MXRyP2BwVzvinSqONGexpiD7fp/N1i97iubesB/dnm3dQIkkDHVN+b3GXO5KzKq9Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tVgxO2oF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tVgxO2oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCAA1F000E9;
	Sun, 21 Jun 2026 18:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067220;
	bh=xHHyb5G8+Wb/DTW6q7nMCUBdbR01DMDpoQGViidWtzs=;
	h=Date:To:From:Subject;
	b=tVgxO2oFbotDAKdxIrotWEDEwQCSkFy6brn9BxM5y33MFTcJuWBibRfsNMEiyIa2h
	 3yVNDwiGB2j99QGKSI3InTeQii/UaQMRnVsupZHXuCuf0uxPwrePPBvTbyIAbg4BQS
	 6+MDa27gXt9vcqtciHoKT0zJ09BDG/FNchDB3MuY=
Date: Sun, 21 Jun 2026 11:40:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rcampbell@nvidia.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,david@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,alex.sierra@amd.com,aboorvad@linux.ibm.com,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-allow-pud-level-entries-in-compound-testcase-of-hmm-tests.patch removed from -mm tree
Message-Id: <20260621184020.7DCAA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: allow PUD-level entries in compound testcase of hmm tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-allow-pud-level-entries-in-compound-testcase-of-hmm-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: allow PUD-level entries in compound testcase of hmm tests
Date: Thu, 11 Jun 2026 09:11:00 +0530

Patch series "selftests/mm: assorted fixes for hmm-tests", v3.

This series fixes a few issues in hmm-tests that show up when page-size
and huge-page configuration differ from the hardcoded assumptions the
tests were written for (PMD/THP sizing, default hugepage size, and related
cases).

It also includes a fix to exclusive_cow: the test ignored the return value
of fork(), so both parent and child ran the same teardown path.


This patch (of 3):

The HMM compound testcase currently assumes only PMD-level mappings and
fails on systems where default_hugepagesz=1G is set, because the region is
then reported by the device at PUD level.

Determine the mapping level (PMD or PUD) the device reports for the first
page of the range and require every page to match that level exactly via
ASSERT_EQ().  This accepts PUD-level mappings while preserving the
expected/observed protection values printed on failure, and rejects a
fragmented mapping that mixes PMD- and PUD-level entries within the same
range (which a per-page OR check would have let pass).

Link: https://lore.kernel.org/20260611034102.1030738-1-aboorvad@linux.ibm.com
Link: https://lore.kernel.org/20260611034102.1030738-2-aboorvad@linux.ibm.com
Fixes: e478425bec93 ("mm/hmm: add tests for hmm_pfn_to_map_order()")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   32 +++++++++++++++++------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-allow-pud-level-entries-in-compound-testcase-of-hmm-tests
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -1602,8 +1602,8 @@ TEST_F(hmm2, snapshot)
 }
 
 /*
- * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
- * should be mapped by a large page table entry.
+ * Test the hmm_range_fault() handling of large pages (PMD or PUD)
+ * that should be mapped by a large page table entry.
  */
 TEST_F(hmm, compound)
 {
@@ -1613,6 +1613,7 @@ TEST_F(hmm, compound)
 	unsigned long default_hsize = default_huge_page_size();
 	int *ptr;
 	unsigned char *m;
+	unsigned char prot;
 	int ret;
 	unsigned long i;
 
@@ -1648,11 +1649,20 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw.  The region is backed by a single huge
+	 * page that the device reports either at PMD or at PUD level depending
+	 * on the configured default hugepage size.  Determine that level from
+	 * the first page and require every page in the range to match it
+	 * exactly, so that a fragmented mapping mixing levels (or a missing
+	 * large-page bit) is still caught and reported with its actual value.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_WRITE |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	/* Make the region read-only. */
 	ret = mprotect(buffer->ptr, size, PROT_READ);
@@ -1663,11 +1673,17 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw after mprotect(PROT_READ).  Same
+	 * approach as above: determine the mapping level from the first
+	 * page and require every page to match it exactly.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_READ |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_READ |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


