Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D41186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538276; cv=none; b=psniNY4f5rsiM0eLzc1tKqnFKjnZRndugb4ufr+rkmKsJPvV2kGXfljjz9QPy9XR/d72/BHEpVi57/UAw98f2qxl1/Tq+ODHUg2/mTV6PHGW/E9/8eeP6zR1kcz9zDya2xC2JAa0Ng6mXITTb2OHEyKKz1tnSeqasd8pv8xk/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538276; c=relaxed/simple;
	bh=wEvfAKF/3NSsr73063CrW5TTMj0h+Q68zwps29ODFAU=;
	h=Date:To:From:Subject:Message-Id; b=BjjhmQFC0s7m8XdXFy4m0oL/3iCYrwWAAHVXQKEesGYDgoC4DDnfF1sw8kHlS/Ylg2NxnkAsSEYLYfsV5oQegQEYUsI0skOp6o3kvT+6FJn+1G37sliYrZ8Z7FQ/BIxalBvIdP1z6Bp31Evs7DTmqI2YtrZx6OsCTXP1EJ6fLFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwHeEtTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwHeEtTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1F3C4CEF4;
	Thu,  7 Aug 2025 03:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538275;
	bh=wEvfAKF/3NSsr73063CrW5TTMj0h+Q68zwps29ODFAU=;
	h=Date:To:From:Subject:From;
	b=DwHeEtTLl7TbxdmIBkZubGGHeuWhSgmVEGRqADHvs8sDAdY2RsVlSRrGy+Gp4mTI+
	 PP6RYNrcYK1sm3bcK6VbfbgYZ66O22k0aBYcMR6jKmHcejUPlM+JUe2FLpMQekwZ2z
	 KPhKRuBwuVR4W8CrWcrYJ9DsEnubBj1ZoyKgAuhk=
Date: Wed, 06 Aug 2025 20:44:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-wunused-family-of-flags.patch added to mm-new branch
Message-Id: <20250807034435.CD1F3C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add -Wunused family of flags
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-wunused-family-of-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-wunused-family-of-flags.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: add -Wunused family of flags
Date: Thu, 31 Jul 2025 21:01:28 +0500

Add -Wunused family of flags and fix all the warnings coming because of
argc and argv.  Remove them if they aren't being used entirely.  Use
__unused compiler attribute with argc where argv is being used.

Link: https://lkml.kernel.org/r/20250731160132.1795351-5-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                |    2 +-
 tools/testing/selftests/mm/compaction_test.c       |    2 +-
 tools/testing/selftests/mm/cow.c                   |    2 +-
 tools/testing/selftests/mm/droppable.c             |    2 +-
 tools/testing/selftests/mm/gup_longterm.c          |    2 +-
 tools/testing/selftests/mm/hugepage-vmemmap.c      |    2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |    2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |    2 +-
 tools/testing/selftests/mm/madv_populate.c         |    2 +-
 tools/testing/selftests/mm/map_populate.c          |    2 +-
 tools/testing/selftests/mm/memfd_secret.c          |    2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |    2 +-
 tools/testing/selftests/mm/mlock2-tests.c          |    2 +-
 tools/testing/selftests/mm/on-fault-limit.c        |    2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 +-
 tools/testing/selftests/mm/soft-dirty.c            |    2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        |    2 +-
 tools/testing/selftests/mm/virtual_address_range.c |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -203,7 +203,7 @@ int set_zero_hugepages(unsigned long *in
 	return ret;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct rlimit lim;
 	struct map_list *list = NULL, *entry;
--- a/tools/testing/selftests/mm/cow.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/cow.c
@@ -1857,7 +1857,7 @@ static int tests_per_non_anon_test_case(
 	return tests;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct thp_settings default_settings;
 
--- a/tools/testing/selftests/mm/droppable.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/droppable.c
@@ -15,7 +15,7 @@
 
 #include "../kselftest.h"
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	size_t alloc_size = 134217728;
 	size_t page_size = getpagesize();
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -504,7 +504,7 @@ static int tests_per_test_case(void)
 	return 3 + nr_hugetlbsizes;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int i;
 
--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -87,7 +87,7 @@ static int check_page_flags(unsigned lon
 	return 0;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	void *addr;
 	unsigned long pfn;
--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -57,7 +57,7 @@ void read_fault_pages(void *addr, unsign
 	}
 }
 
-int main(int argc, char **argv)
+int main(int __unused argc, char **argv)
 {
 	unsigned long free_hugepages;
 	void *addr, *addr2;
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -216,7 +216,7 @@ static void test_soft_offline_common(int
 			 enable_soft_offline);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(2);
--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -281,7 +281,7 @@ static int system_has_softdirty(void)
 #endif
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int nr_tests = 16;
 	int err;
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/Makefile
@@ -20,7 +20,6 @@ endif
 # thus tricking Make (and you!) into believing that All Is Well, in subsequent
 # make invocations:
 .DELETE_ON_ERROR:
-
 # Avoid accidental wrong builds, due to built-in rules working just a little
 # bit too well--but not quite as well as required for our situation here.
 #
@@ -35,6 +34,7 @@ MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 CFLAGS += -Wunreachable-code
+CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -76,7 +76,7 @@ static int child_f(int sock, unsigned lo
 	return ksft_cnt.ksft_pass;
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int sock[2], child, ret;
 	FILE *ftmp;
--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -299,7 +299,7 @@ static void prepare(void)
 
 #define NUM_TESTS 6
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int fd;
 
--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -425,7 +425,7 @@ static void test_mlockall(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int ret, size = 3 * getpagesize();
 	void *map;
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -236,7 +236,7 @@ static void test_mlock_outof_limit(char
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	char *p = NULL;
 
--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -28,7 +28,7 @@ static void test_limit(void)
 	munlockall();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	ksft_print_header();
 	ksft_set_plan(1);
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -528,7 +528,7 @@ static void (*pkey_tests[])(void) = {
 	test_pkru_sigreturn
 };
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	int i;
 
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -194,7 +194,7 @@ static void test_mprotect_file(int pagem
 	test_mprotect(pagemap_fd, pagesize, false);
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	int pagemap_fd;
 	int pagesize;
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -334,7 +334,7 @@ static const struct testcase testcases[]
 	},
 };
 
-int main(int argc, char **argv)
+int main(void)
 {
 	struct thp_settings settings;
 	int i, j, plan = 0;
--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-add-wunused-family-of-flags
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -200,7 +200,7 @@ static int validate_complete_va_space(vo
 	return 0;
 }
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	char *ptr[NR_CHUNKS_LOW];
 	char **hptr;
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

