Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B7536F8F4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067179; cv=none; b=HUutO+kRywgF5QF6xOzfqCksYg4CsdnUAb5HohAjDjjoLOzINJbkIZ4HBY2NZIqfCCGsNjjmderDMYFnsVAL2vjfnvgzkicfTmMP4+Z8xWVngB1jaw3/QPxU78OupzSgPlO+ugmdNWbBMAL3MTV49oZtG3Joah0yYVP0n1jW6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067179; c=relaxed/simple;
	bh=ZiMnJiKXWPV1Bss+ufX1un1CI/O7kCQp5OziR8+mqHA=;
	h=Date:To:From:Subject:Message-Id; b=XujFKRBTQVaPgE6X0teMrHoUTjc6RsOsBzfg8u9iQXjPkUAmzwZjMVqnG5c/IrtibYywX4+VOiznKF7Z5Qrvn9xSrM8kSJsZ1KiSV49yqAGlcml7M8Lpv23AWa18sZl6U7XZIynHHAWpWG68luNy29P8TKg1AWJ89SlOuZ1h1AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXrmFmtm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXrmFmtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E111F000E9;
	Sun, 21 Jun 2026 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067178;
	bh=vJNYuJuE0YDHOK6lzDS2TLp46iA1O/miJvqzEgYWnlU=;
	h=Date:To:From:Subject;
	b=hXrmFmtmf723K2bP6zL+N4m7BwSCGE/tPjuD+kCCSksIcbYGJ8wbBkSO6GRYU9fuA
	 E/hQJdkBL7VRMVr6I14v8JfsrLbHBolFh10gvM9t2maD46g4XSCrQcYeivZRbpfHrC
	 LdjZX6f1VqaAQwzj95JeQhw7xvfE9N0rrXTsvRtw=
Date: Sun, 21 Jun 2026 11:39:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch removed from -mm tree
Message-Id: <20260621183938.92E111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: protection_keys: use library code for HugeTLB setup
has been removed from the -mm tree.  Its filename was
     selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: protection_keys: use library code for HugeTLB setup
Date: Mon, 11 May 2026 19:28:31 +0300

protection_keys open codes setup of HugeTLB pages.

Replace it with the library functions from hugepage_setup.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test.

Link: https://lore.kernel.org/20260511162840.375890-48-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
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
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |   50 ++++-------------
 1 file changed, 14 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-use-library-code-for-hugetlb-setup
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -62,6 +62,7 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
+#if CONTROL_TRACING > 0
 static void cat_into_file(char *str, char *file)
 {
 	int fd = open(file, O_RDWR);
@@ -87,7 +88,6 @@ static void cat_into_file(char *str, cha
 	close(fd);
 }
 
-#if CONTROL_TRACING > 0
 static int warned_tracing;
 static int tracing_root_ok(void)
 {
@@ -710,50 +710,28 @@ static void *malloc_pkey_anon_huge(long
 }
 
 static int hugetlb_setup_ok;
-#define SYSFS_FMT_NR_HUGE_PAGES "/sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages"
 #define GET_NR_HUGE_PAGES 10
 static void setup_hugetlbfs(void)
 {
-	int err;
-	int fd;
-	char buf[256];
-	long hpagesz_kb;
-	long hpagesz_mb;
+	long hpagesz_mb = HPAGE_SIZE / 1024 / 1024;
+	unsigned long free_pages;
 
 	if (geteuid() != 0) {
 		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
-	cat_into_file(__stringify(GET_NR_HUGE_PAGES), "/proc/sys/vm/nr_hugepages");
-
 	/*
-	 * Now go make sure that we got the pages and that they
+	 * Make sure that we got the pages and that they
 	 * are PMD-level pages. Someone might have made PUD-level
 	 * pages the default.
 	 */
-	hpagesz_kb = HPAGE_SIZE / 1024;
-	hpagesz_mb = hpagesz_kb / 1024;
-	sprintf(buf, SYSFS_FMT_NR_HUGE_PAGES, hpagesz_kb);
-	fd = open(buf, O_RDONLY);
-	if (fd < 0) {
-		fprintf(stderr, "opening sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	/* -1 to guarantee leaving the trailing \0 */
-	err = read(fd, buf, sizeof(buf)-1);
-	close(fd);
-	if (err <= 0) {
-		fprintf(stderr, "reading sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	if (atoi(buf) != GET_NR_HUGE_PAGES) {
-		fprintf(stderr, "could not confirm %ldM pages, got: '%s' expected %d\n",
-			hpagesz_mb, buf, GET_NR_HUGE_PAGES);
+	hugetlb_save_settings();
+	hugetlb_set_nr_pages(HPAGE_SIZE, GET_NR_HUGE_PAGES);
+	free_pages = hugetlb_free_pages(HPAGE_SIZE);
+	if (free_pages < GET_NR_HUGE_PAGES) {
+		ksft_print_msg("could not confirm %ldM pages, got: '%lu' expected %d\n",
+			       hpagesz_mb, free_pages, GET_NR_HUGE_PAGES);
 		return;
 	}
 
@@ -1130,7 +1108,7 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	exit(0);
+	_exit(0);
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1509,18 +1487,18 @@ static void test_ptrace_modifies_pkru(in
 		 * checking
 		 */
 		if (__read_pkey_reg() != new_pkru)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to clear XSTATE_BV for PKRU */
 		raise(SIGSTOP);
 
 		if (__read_pkey_reg() != 0)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to examine PKRU */
 		raise(SIGSTOP);
 
-		exit(0);
+		_exit(0);
 	}
 
 	pkey_assert(child == waitpid(child, &status, 0));
_

Patches currently in -mm which might be from rppt@kernel.org are


