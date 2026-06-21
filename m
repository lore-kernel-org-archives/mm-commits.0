Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11136F8E3
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067177; cv=none; b=M5xxK7o77lM5zchlfkvgnrM/NcCVt0zwoAl7YvgCee9HkPKzSNMZtvEGpYuZsk30gvQZaADaSzmkfZUe4MPHcCkG1IUITKKFwBfOum6NY7BkiF26hxY87WRLr1nRSBJCAnfw3OQffR7bmHl+m/E3QQ6MQCJZ9+Cyf/9WwBZnDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067177; c=relaxed/simple;
	bh=t21Bwhr/ynXzMTVYbcXnLYJH5bkf0J/OWchVBzvfSRM=;
	h=Date:To:From:Subject:Message-Id; b=GNwMceYq/tmQUFclSLXQ25JVaBk3VW8CJc3bhAUK67dJheCPaMxxrKtxIfV+Oak1LCBkP/J9A1rT7fng27L9U558he0CMDQo8La3+3RmCA5th9Tr8/UXM0KoEcRDyH9KqDYmceQ71WMGLQlPW6w3iCsWfNV3C70HajPUOxk/jLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gPkBR11O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gPkBR11O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDADA1F000E9;
	Sun, 21 Jun 2026 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067176;
	bh=xxXkLpBMkePGgRrwkxrE+Y+XUCQ6F2GdBuaEnX5X14Y=;
	h=Date:To:From:Subject;
	b=gPkBR11OmscNWKyc8c/Lj8wphtoYov4P+OXSdAZ9J8Rs5giyui+2DCZ+inA2rY4V/
	 3BqsHdYfxk8yTKt9uAdDV/WFTzSghz+13hWZszWBuUJELEbURihRowpp/XZokmIs5v
	 k/cpKhtiwIklf9wbgiP+XJ5vc1g40NRcgnCgKIME=
Date: Sun, 21 Jun 2026 11:39:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-migration-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183935.EDADA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: migration: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-migration-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: migration: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:29 +0300

migration skips HugeTLB tests if there are no free huge pages prepared by
a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Since kselftest_harness runs fixture setup and the tests in child
processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
that runs in the main process and add verification that there are enough
free huge pages to the tests that use them.

Reset signal handlers to defaults in FIXTURE_SETUP() so that sending
SIGTERM and SIGHUP during the tests won't cause restoration of HugeTLB
settings.

Link: https://lore.kernel.org/20260511162840.375890-46-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-migration-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/migration.c
@@ -23,6 +23,8 @@
 #define MAX_RETRIES	100
 #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
+HUGETLB_SETUP_DEFAULT_PAGES(1)
+
 FIXTURE(migration)
 {
 	pthread_t *threads;
@@ -32,10 +34,23 @@ FIXTURE(migration)
 	int n2;
 };
 
+static void reset_signals(void)
+{
+	struct sigaction sa = { .sa_handler = SIG_DFL };
+
+	sigemptyset(&sa.sa_mask);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SIGHUP, &sa, NULL);
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGQUIT, &sa, NULL);
+}
+
 FIXTURE_SETUP(migration)
 {
 	int n;
 
+	reset_signals();
+
 	if (numa_available() < 0)
 		SKIP(return, "NUMA not available");
 	self->nthreads = numa_num_task_cpus() - 2;
@@ -288,6 +303,9 @@ TEST_F_TIMEOUT(migration, private_anon_h
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -316,6 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
_

Patches currently in -mm which might be from rppt@kernel.org are


