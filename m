Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820EB3B811F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068140; cv=none; b=Tmog35dFpuIFutzBwhuXXmjihCeN2IYNWxb0DXLnu8gOk/ARb7Yew/WOadprCI4sdS8f1JE0YPJE0W14jVA6G0xOpSqScI2g3gZjkX47Pn5R2ZQlJg3Q8UHJpTEmgwNdq5+TM1mTrYmvFHE03zcqLh5+tTFciE2B2XvYM9NHgw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068140; c=relaxed/simple;
	bh=4+lyV+joxArh120zDslSI5CpuAfpiLGL1CpEQS8o0QA=;
	h=Date:To:From:Subject:Message-Id; b=jq8X2zhd5X00Vqw7inwIFwvYVPeTCl59Z8/M8X5daHBm1+ZBMRr9iNb8HOzvRttvFA8lPZ7McMJQ3U3GGy2cwOyMoYwVyaGx1hetNzHf1GPoKSCK/rP7e2YR5UKA3L+PO5oMWIQKPuMEJEGggXqxS1pHx2KYeHgNGFklVIO9T8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjpLApHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjpLApHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC81F00A3A;
	Fri,  7 Aug 2026 02:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068138;
	bh=qdhq1QIog9Rftws1/veBba+vB7gcQCt7Tosjze2Ivbk=;
	h=Date:To:From:Subject;
	b=WjpLApHTp7SmG6DZQJJ4yVN/0de48AiVA57Vvzyej21mf9w8Reke+NPhjwsdvF9Uh
	 I1SLOgwvepZ/EDBnuDjfspdqufy36N/x72RBa44V3I166l/3r2G1NJn33+OHYbfYSG
	 uEzAZDH3/tXwuNGmrw/RZuo/cEssZXGruTytdqoA=
Date: Thu, 06 Aug 2026 19:02:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,yanlonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-map_failed-for-mmap-error-check.patch removed from -mm tree
Message-Id: <20260807020218.57DC81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use MAP_FAILED for mmap error check
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-map_failed-for-mmap-error-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: longlong yan <yanlonglong@kylinos.cn>
Subject: selftests/mm: use MAP_FAILED for mmap error check
Date: Mon, 20 Jul 2026 14:34:39 +0800

Replace the direct comparison with (void *)-1 with the standard MAP_FAILED
macro when checking mmap()

Link: https://lore.kernel.org/20260720063439.522-1-yanlonglong@kylinos.cn
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |  106 +++++++++++-----------
 1 file changed, 53 insertions(+), 53 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-use-map_failed-for-mmap-error-check
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -234,7 +234,7 @@ static void test_seal_addseal(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	ret = sys_mseal(ptr, size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -250,7 +250,7 @@ static void test_seal_unmapped_start(voi
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* munmap 2 pages from ptr. */
 	ret = sys_munmap(ptr, 2 * page_size);
@@ -278,7 +278,7 @@ static void test_seal_unmapped_middle(vo
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* munmap 2 pages from ptr + page. */
 	ret = sys_munmap(ptr + page_size, 2 * page_size);
@@ -310,7 +310,7 @@ static void test_seal_unmapped_end(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* unmap last 2 pages. */
 	ret = sys_munmap(ptr + 2 * page_size, 2 * page_size);
@@ -339,7 +339,7 @@ static void test_seal_multiple_vmas(void
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split the vma into 3. */
 	ret = sys_mprotect(ptr + page_size, 2 * page_size,
@@ -370,7 +370,7 @@ static void test_seal_split_start(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split at middle */
 	ret = sys_mprotect(ptr, 2 * page_size, PROT_READ | PROT_WRITE);
@@ -395,7 +395,7 @@ static void test_seal_split_end(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split at middle */
 	ret = sys_mprotect(ptr, 2 * page_size, PROT_READ | PROT_WRITE);
@@ -420,7 +420,7 @@ static void test_seal_invalid_input(void
 	int ret;
 
 	setup_single_address(8 * page_size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	ret = clean_single_address(ptr + 4 * page_size, 4 * page_size);
 	FAIL_TEST_IF_FALSE(!ret);
 
@@ -455,7 +455,7 @@ static void test_seal_zero_length(void)
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	ret = sys_mprotect(ptr, 0, PROT_READ | PROT_WRITE);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -505,7 +505,7 @@ static void test_seal_twice(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	ret = sys_mseal(ptr, size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -525,7 +525,7 @@ static void test_seal_mprotect(bool seal
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr, size);
@@ -549,7 +549,7 @@ static void test_seal_start_mprotect(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr, page_size);
@@ -579,7 +579,7 @@ static void test_seal_end_mprotect(bool
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr + page_size, 3 * page_size);
@@ -609,7 +609,7 @@ static void test_seal_mprotect_unalign_l
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr, page_size * 2 - 1);
@@ -638,7 +638,7 @@ static void test_seal_mprotect_unalign_l
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	if (seal) {
 		ret =  seal_single_address(ptr, page_size * 2 + 1);
 		FAIL_TEST_IF_FALSE(!ret);
@@ -666,7 +666,7 @@ static void test_seal_mprotect_two_vma(b
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
@@ -701,7 +701,7 @@ static void test_seal_mprotect_two_vma_w
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split as two vma. */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
@@ -748,7 +748,7 @@ static void test_seal_mprotect_partial_m
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* seal one page. */
 	if (seal) {
@@ -780,7 +780,7 @@ static void test_seal_mprotect_partial_m
 	 */
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr + page_size, page_size);
@@ -810,7 +810,7 @@ static void test_seal_mprotect_two_vma_w
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -853,7 +853,7 @@ static void test_seal_mprotect_split(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -890,7 +890,7 @@ static void test_seal_mprotect_merge(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split one page. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -924,7 +924,7 @@ static void test_seal_munmap(bool seal)
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -955,7 +955,7 @@ static void test_seal_munmap_two_vma(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect to split */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
@@ -996,7 +996,7 @@ static void test_seal_munmap_vma_with_ga
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	ret = sys_munmap(ptr + page_size, page_size * 2);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1028,7 +1028,7 @@ static void test_seal_munmap_partial_acr
 	int prot;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr + page_size, page_size);
@@ -1058,7 +1058,7 @@ static void test_munmap_start_freed(bool
 	int prot;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* unmap the first page. */
 	ret = sys_munmap(ptr, page_size);
@@ -1097,7 +1097,7 @@ static void test_munmap_end_freed(bool s
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* unmap last page. */
 	ret = sys_munmap(ptr + page_size * 3, page_size);
@@ -1128,7 +1128,7 @@ static void test_munmap_middle_freed(boo
 	int prot;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* unmap 2 pages in the middle. */
 	ret = sys_munmap(ptr + page_size, page_size * 2);
@@ -1172,7 +1172,7 @@ static void test_seal_mremap_shrink(bool
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1201,7 +1201,7 @@ static void test_seal_mremap_expand(bool
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	/* ummap last 2 pages. */
 	ret = sys_munmap(ptr + 2 * page_size, 2 * page_size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1233,9 +1233,9 @@ static void test_seal_mremap_move(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	setup_single_address(size, &newPtr);
-	FAIL_TEST_IF_FALSE(newPtr != (void *)-1);
+	FAIL_TEST_IF_FALSE(newPtr != MAP_FAILED);
 	ret = clean_single_address(newPtr, size);
 	FAIL_TEST_IF_FALSE(!ret);
 
@@ -1266,7 +1266,7 @@ static void test_seal_mmap_overwrite_pro
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1294,7 +1294,7 @@ static void test_seal_mmap_expand(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	/* ummap last 4 pages. */
 	ret = sys_munmap(ptr + 8 * page_size, 4 * page_size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1325,7 +1325,7 @@ static void test_seal_mmap_shrink(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1354,9 +1354,9 @@ static void test_seal_mremap_shrink_fixe
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	setup_single_address(size, &newAddr);
-	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
+	FAIL_TEST_IF_FALSE(newAddr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1385,9 +1385,9 @@ static void test_seal_mremap_expand_fixe
 	void *ret2;
 
 	setup_single_address(page_size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	setup_single_address(size, &newAddr);
-	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
+	FAIL_TEST_IF_FALSE(newAddr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(newAddr, size);
@@ -1416,9 +1416,9 @@ static void test_seal_mremap_move_fixed(
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 	setup_single_address(size, &newAddr);
-	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
+	FAIL_TEST_IF_FALSE(newAddr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(newAddr, size);
@@ -1445,7 +1445,7 @@ static void test_seal_mremap_move_fixed_
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1476,7 +1476,7 @@ static void test_seal_mremap_move_dontun
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1505,7 +1505,7 @@ static void test_seal_mremap_move_dontun
 	void *ret2;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1517,7 +1517,7 @@ static void test_seal_mremap_move_dontun
 	 * use allocate/free to similate that.
 	 */
 	setup_single_address(size, &ptr2);
-	FAIL_TEST_IF_FALSE(ptr2 != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr2 != MAP_FAILED);
 	ret = sys_munmap(ptr2, size);
 	FAIL_TEST_IF_FALSE(!ret);
 
@@ -1547,7 +1547,7 @@ static void test_seal_merge_and_split(vo
 
 	/* (24 RO) */
 	setup_single_address(24 * page_size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	/* use mprotect(NONE) to set out boundary */
 	/* (1 NONE) (22 RO) (1 NONE) */
@@ -1637,7 +1637,7 @@ static void test_seal_discard_ro_anon_on
 	int ret;
 
 	setup_single_address_rw(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1669,7 +1669,7 @@ static void test_seal_discard_ro_anon_on
 	SKIP_TEST_IF_FALSE(pkey_supported());
 
 	setup_single_address_rw(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	pkey = sys_pkey_alloc(0, PKEY_UNRESTRICTED);
 	FAIL_TEST_IF_FALSE(pkey > 0);
@@ -1751,7 +1751,7 @@ static void test_seal_discard_ro_anon_on
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_SHARED;
 
 	ptr = mmap(NULL, size, PROT_READ, mapflags, -1, 0);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1779,7 +1779,7 @@ static void test_seal_discard_ro_anon(bo
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr, size);
@@ -1809,7 +1809,7 @@ static void test_seal_discard_across_vma
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr + page_size, page_size);
@@ -1840,7 +1840,7 @@ static void test_seal_madvise_nodiscard(
 	int ret;
 
 	setup_single_address(size, &ptr);
-	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
 		ret = seal_single_address(ptr, size);
_

Patches currently in -mm which might be from yanlonglong@kylinos.cn are


