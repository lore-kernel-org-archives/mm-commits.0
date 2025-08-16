Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42231F462C
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325280; cv=none; b=tmKF58bpolx5aHMahPFc1YM4BnJRjSb115wnvOidPZUPF1X3vXaIPL1kCSk1Z+XQQJb8ccLeQhUFaapWFVk/Af/hRcXAGOjzy/nFmMU+AFHbbGo7HolGw+CkFWv6eUagAFqHqVvKUMqQ7r8EYKrKJ8q9o0kSw02+Ck0JQ5KieY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325280; c=relaxed/simple;
	bh=MnysFDTj2pAQgtffDkIsmJZgBkbhfiXG6LW/lQCB5zo=;
	h=Date:To:From:Subject:Message-Id; b=F6Rx3GCw08oKp3Zfmg5lWNPqR9lX0cVqeTs2tAos1Z6nUzRuiKaj3UDDXs/M9wtC+NQUBUADetHr+LpCqsy992yPTHoa9Mu/gkqTlCJFt204ynI/0gM3XOtOMTHvicEtP+kyNou3BMD7vTSOOYw55nfIYV39aKeKFjVxUqKnvR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRa86POG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRa86POG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DA5C4CEEF;
	Sat, 16 Aug 2025 06:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325277;
	bh=MnysFDTj2pAQgtffDkIsmJZgBkbhfiXG6LW/lQCB5zo=;
	h=Date:To:From:Subject:From;
	b=lRa86POGh4uXRFoGM7y8BzotcKj76pKQS4jNv2pmrhcnr+PmOYGCZyImfBoUbU4Py
	 nbjcObceXgY6xXUWHnVH/sfDcPJXiqYahLXLUIKo+C/hDkNu5ylCE45xR38+GoIMjU
	 ZgSSvs8AjnNbVYS/NdTo5RIvh3MsLzmlRLECSd1Q=
Date: Fri, 15 Aug 2025 23:21:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-extract-sz2ord-function-into-vm_utilh.patch added to mm-new branch
Message-Id: <20250816062117.D1DA5C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: extract sz2ord function into vm_util.h
has been added to the -mm mm-new branch.  Its filename is
     selftest-mm-extract-sz2ord-function-into-vm_utilh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-extract-sz2ord-function-into-vm_utilh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftest/mm: extract sz2ord function into vm_util.h
Date: Fri, 15 Aug 2025 14:54:57 +0100

The function already has 2 uses and will have a 3rd one in prctl
selftests.  The pagesize argument is added into the function, as it's not
a global variable anymore.  No functional change intended with this patch.

Link: https://lkml.kernel.org/r/20250815135549.130506-6-usamaarif642@gmail.com
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c                  |    8 ++++----
 tools/testing/selftests/mm/split_huge_page_test.c |    2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c       |    4 ++--
 tools/testing/selftests/mm/vm_util.h              |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/cow.c
@@ -52,7 +52,7 @@ static int detect_thp_sizes(size_t sizes
 	if (!pmdsize)
 		return 0;
 
-	orders = 1UL << sz2ord(pmdsize);
+	orders = 1UL << sz2ord(pmdsize, pagesize);
 	orders |= thp_supported_orders();
 
 	for (i = 0; orders && count < max; i++) {
@@ -1211,8 +1211,8 @@ static void run_anon_test_case(struct te
 		size_t size = thpsizes[i];
 		struct thp_settings settings = *thp_current_settings();
 
-		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
-		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_NEVER;
+		settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		thp_push_settings(&settings);
 
 		if (size == pmdsize) {
@@ -1863,7 +1863,7 @@ int main(void)
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
-		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
+		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
 		thp_save_settings();
 		thp_push_settings(&default_settings);
 
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -544,7 +544,7 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
 	nr_pages = pmd_pagesize / pagesize;
-	max_order =  sz2ord(pmd_pagesize);
+	max_order =  sz2ord(pmd_pagesize, pagesize);
 	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -82,9 +82,9 @@ static void *alloc_one_folio(size_t size
 		struct thp_settings settings = *thp_current_settings();
 
 		if (private)
-			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+			settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		else
-			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
+			settings.shmem_hugepages[sz2ord(size, pagesize)].enabled = SHMEM_ALWAYS;
 
 		thp_push_settings(&settings);
 
--- a/tools/testing/selftests/mm/vm_util.h~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -127,9 +127,9 @@ static inline void log_test_result(int r
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
-static inline int sz2ord(size_t size)
+static inline int sz2ord(size_t size, size_t pagesize)
 {
-	return __builtin_ctzll(size / getpagesize());
+	return __builtin_ctzll(size / pagesize);
 }
 
 void *sys_mremap(void *old_address, unsigned long old_size,
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

