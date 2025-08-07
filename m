Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32354186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538268; cv=none; b=NBeXbCT3VhaqwuB3UQJdlTZALVeZX6OzS7KpnHkyCkMx0u/tvZfi4y67k32aK+7pMXC0qhziUDqgrTjygBTfTDdMjaS2SGCLSp4fpbXLLhWftwRojJzFeGUwlRZYS0eeb3wuHaHCxs8WLk1lPEmnExSsJhbOV+/vRSQCq2U80ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538268; c=relaxed/simple;
	bh=0/dC+riaT8r614+HERRDWSZ9uV7lA/bd5MEbMv5JhjI=;
	h=Date:To:From:Subject:Message-Id; b=Wcr5ranRTSm4NAbBZS9uquwixmJQWNEgBVCpsttzF+1ku+4QKQDu0alpQsIFf0/24aNYnNDv977YVVDnjWqCAuNBUuULeTkb1oVwBJB2fDkvf2NxCLBj3VjOjXNVSumfU87bfLAUSMnClx49sT29xz8wBzbrZpJqX5gc3Dtk3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4amKMTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4amKMTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFECC4CEF4;
	Thu,  7 Aug 2025 03:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538267;
	bh=0/dC+riaT8r614+HERRDWSZ9uV7lA/bd5MEbMv5JhjI=;
	h=Date:To:From:Subject:From;
	b=V4amKMTtl/5H7pj5is4rdq+DIKfbRdlaMX+3GMOtgVBdrAnrlEUnq83LLm2LRwwYh
	 pRfVZSMSxd+U4krix3gEWMix1UmwGfjiRwrzbP6iCiBISb8tDmCILUnOVI63kOswl+
	 ov+7KNByO0ljV7NzhQBozmM8BuHq5/lVojmx7x0c=
Date: Wed, 06 Aug 2025 20:44:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-wunreachable-code-and-fix-warnings.patch added to mm-new branch
Message-Id: <20250807034427.9FFECC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add -Wunreachable-code and fix warnings
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-wunreachable-code-and-fix-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-wunreachable-code-and-fix-warnings.patch

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
Subject: selftests/mm: add -Wunreachable-code and fix warnings
Date: Thu, 31 Jul 2025 21:01:25 +0500

Patch series "selftests/mm: Add compiler flags and fix found warnings", v2.

Recently, I reviewed a patch on the mm/kselftest mailing list about a test
which had obvious type mismatch fix in it.  It was strange why that wasn't
caught during development and when patch was accepted.  This led me to
discover that those extra compiler options to catch these warnings aren't
being used.  When I added them, I found tens of warnings in just mm suite.

In this series, I'm adding these flags and fixing those warnings.  In the
last try several months ago [1], I'd patches for individual tests.  I've
made patches better by grouping the same type of fixes together.  Hence
there is no changelog for individual patches.


This patch (of 8):

Enable -Wunreachable-code flag to catch dead code and fix them.

1. Remove the dead code and write a comment instead:
hmm-tests.c:2033:3: warning: code will never be executed
[-Wunreachable-code]
                perror("Should not reach this\n");
                ^~~~~~

2. ksft_exit_fail_msg() calls exit(). Remove the dead code.
split_huge_page_test.c:301:3: warning: code will never be executed
[-Wunreachable-code]
                goto cleanup;
                ^~~~~~~~~~~~

3. Remove duplicate inline.
pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]
static inline __always_inline

Link: https://lkml.kernel.org/r/20250731160132.1795351-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20250731160132.1795351-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                |    1 +
 tools/testing/selftests/mm/hmm-tests.c             |    5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |    4 +---
 4 files changed, 5 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-add-wunreachable-code-and-fix-warnings
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2027,11 +2027,10 @@ TEST_F(hmm, hmm_cow_in_device)
 	if (pid == -1)
 		ASSERT_EQ(pid, 0);
 	if (!pid) {
-		/* Child process waitd for SIGTERM from the parent. */
+		/* Child process waits for SIGTERM from the parent. */
 		while (1) {
 		}
-		perror("Should not reach this\n");
-		exit(0);
+		/* Should not reach this */
 	}
 	/* Parent process writes to COW pages(s) and gets a
 	 * new copy in system. In case of device private pages,
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-wunreachable-code-and-fix-warnings
+++ a/tools/testing/selftests/mm/Makefile
@@ -34,6 +34,7 @@ endif
 MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-add-wunreachable-code-and-fix-warnings
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
  * syscall will attempt to access the PLT in order to call a library function
  * which is protected by MPK 0 which we don't have access to.
  */
-static inline __always_inline
+static __always_inline
 long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 {
 	unsigned long ret;
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-wunreachable-code-and-fix-warnings
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -297,10 +297,8 @@ void split_file_backed_thp(int order)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
-	if (status >= INPUT_MAX) {
+	if (status >= INPUT_MAX)
 		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
-		goto cleanup;
-	}
 
 	fd = open(testfile, O_CREAT|O_RDWR, 0664);
 	if (fd == -1) {
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

