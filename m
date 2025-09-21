Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D027281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490002; cv=none; b=fD4wqiXl2ruQeRNs8Bn/8AAbd+njEEui1SUCDV/RmWSKDoW5gtL+8tBdnJ1RGnF1olrZfAOy7CIH00YzmkhW0bzQmVe8HS+7VDi51AWPe4g+Vq1fcPq9yLnBHXuAX5PWt++ET0AqyB/QYLXFE8iSH/diX1SrItW4DBR4rcmUqN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490002; c=relaxed/simple;
	bh=5y3UCAeCXKpPWEl2Ucd5OYP6TTukNzsFKKY2GyREFxo=;
	h=Date:To:From:Subject:Message-Id; b=Vpa1K0foJPLGHi6TbZWyxMaGdpUlrF2u8TpZFdVG0kGrohiSuapc5zzk/RM+6V/5L+IsfJkOL3YOVW675RnJvVP+Zx6HEqSpYFx2j7Ec5Fx26lxauNQqPHrtQBDj30palA9bKWIjPq9HTvW33cu+PyI2CNNg/hc4tgXLx/8Y+eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kr63OQm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kr63OQm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D23C4CEE7;
	Sun, 21 Sep 2025 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490001;
	bh=5y3UCAeCXKpPWEl2Ucd5OYP6TTukNzsFKKY2GyREFxo=;
	h=Date:To:From:Subject:From;
	b=kr63OQm24BND7ZhHg2m73+cDb38EkE0JHMamfFhhhpvOXzgFNN+UXTyXjfDqvP9QX
	 n36p9Kjs7VkCSl3Iq4OSr0UFIOFMKt+T11VhH2H1Nebj3K9J1DxPkMtAywNK/9CBhx
	 1UrqkbdbtXvRc5uwzig8BKvDuLJpdd96vgGs/BYM=
Date: Sun, 21 Sep 2025 14:26:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kevin.brodsky@arm.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-wunreachable-code-and-fix-warnings.patch removed from -mm tree
Message-Id: <20250921212641.B8D23C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add -Wunreachable-code and fix warnings
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-wunreachable-code-and-fix-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: add -Wunreachable-code and fix warnings
Date: Fri, 12 Sep 2025 17:30:21 +0500

Patch series "selftests/mm: Add -Wunreachable-code and fix warnings".

Add -Wunreachable-code to selftests and remove dead code from generated
warnings.


This patch (of 2):

Enable -Wunreachable-code flag to catch dead code and fix them.

1. Remove the dead code and write a comment instead:
hmm-tests.c:2033:3: warning: code will never be executed
[-Wunreachable-code]
                perror("Should not reach this\n");
                ^~~~~~

2. ksft_exit_fail_msg() calls exit(). So cleanup isn't done. Replace it
   with ksft_print_msg().
split_huge_page_test.c:301:3: warning: code will never be executed
[-Wunreachable-code]
                goto cleanup;
                ^~~~~~~~~~~~

3. Remove duplicate inline.
pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]
static inline __always_inline

Link: https://lkml.kernel.org/r/20250912123025.1271051-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20250912123025.1271051-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                |    1 +
 tools/testing/selftests/mm/hmm-tests.c             |    5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

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
@@ -510,7 +510,7 @@ static void split_file_backed_thp(int or
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
-		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
+		ksft_print_msg("Fail to create file-backed THP split testing file\n");
 		goto cleanup;
 	}
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


