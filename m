Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E50D36D506
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067174; cv=none; b=bgJXUGIeKExFuwHSE7vWUfstKqd59AZU3EoyXlU82to0/qyCxTzHf2MdmLcQcE1yo9Kr+J9OMXql89EwxLM2J+dcDNk+3/kggPY08XUmSeULtgQKdvkJZwsV0b9fdmPEaH4LKHgzurKzM7s8lNm6kTwMSio8bNqdv2OVHyUZAZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067174; c=relaxed/simple;
	bh=LUvMlwnGN91YORbXAk2176WvG6A2QagWeBWBbuQx+m0=;
	h=Date:To:From:Subject:Message-Id; b=LP8eLlm+vV9gWkbFOlq83a7Ta+FDphDaZ9UXrJ05K1Yhfh8QZIH4yp9+Vo5+eR4sXO1N5HlEU9N3wKmObgDZq+PT9FBq63MemTqzVXHTbD8bowOW+Dk49Vov/b+v50RdbVmIOD9iRq98vKRx3rfFLg0R8qV8WBhTqKmV1U1GoQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n+C1SvNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n+C1SvNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5939F1F000E9;
	Sun, 21 Jun 2026 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067173;
	bh=w9IUxWGbRnLNLiU6iHUkI56LhbM/M0nT9gMMBF1/e9Q=;
	h=Date:To:From:Subject;
	b=n+C1SvNz8vrMW7O7DWLmzIxKIx7xVTJpaWfN4IPg0wS1bhxAnK2RI+dvn12JLgbXp
	 O8r0aAx7X25Hcnn/wR51LSjoShLG1WzjGndR3A5utaDJuJpdmQTXbqhoD6A4Pimg4Z
	 dRaVY8kcRwNfxAAeONGY7dMDPF6KAap5ti55dCPQ=
Date: Sun, 21 Jun 2026 11:39:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183933.5939F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:27 +0300

hugetlb-soft-offline test uses open coded access to /proc to determine
availability of huge pages and fails if there are no enough free huget
pages..

Replace open coded access to /proc with hugepage helpers and add setup of
HugeTLB pages to the test and make sure that the original settings are
restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-44-rppt@kernel.org
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

 tools/testing/selftests/mm/hugetlb-soft-offline.c |   45 ++----------
 1 file changed, 8 insertions(+), 37 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -6,9 +6,7 @@
  * - if enable_soft_offline = 1, a hugepage should be dissolved and
  *   nr_hugepages/free_hugepages should be reduced by 1.
  *
- * Before running, make sure more than 2 hugepages of default_hugepagesz
- * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
- *   echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+ * The test allocates 8 default hugepages
  */
 
 #define _GNU_SOURCE
@@ -25,6 +23,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
 #define MADV_SOFT_OFFLINE 101
@@ -100,32 +99,6 @@ static int set_enable_soft_offline(int v
 	return 0;
 }
 
-static int read_nr_hugepages(unsigned long hugepage_size,
-			     unsigned long *nr_hugepages)
-{
-	char buffer[256] = {0};
-	char cmd[256] = {0};
-
-	sprintf(cmd, "cat /sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages",
-		hugepage_size);
-	FILE *cmdfile = popen(cmd, "r");
-
-	if (cmdfile == NULL) {
-		ksft_perror(EPREFIX "failed to popen nr_hugepages");
-		return -1;
-	}
-
-	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
-		ksft_perror(EPREFIX "failed to read nr_hugepages");
-		pclose(cmdfile);
-		return -1;
-	}
-
-	*nr_hugepages = atoll(buffer);
-	pclose(cmdfile);
-	return 0;
-}
-
 static int create_hugetlbfs_file(struct statfs *file_stat)
 {
 	int fd;
@@ -177,20 +150,14 @@ static void test_soft_offline_common(int
 		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
 	}
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
-	}
+	nr_hugepages_before = hugetlb_nr_default_pages();
 
 	ksft_print_msg("Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
 		       nr_hugepages_before);
 
 	ret = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_errno);
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
-	}
+	nr_hugepages_after = hugetlb_nr_default_pages();
 
 	ksft_print_msg("After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
 		nr_hugepages_after);
@@ -219,6 +186,10 @@ static void test_soft_offline_common(int
 int main(int argc, char **argv)
 {
 	ksft_print_header();
+
+	if (!hugetlb_setup_default(8))
+		ksft_exit_skip("not enough hugetlb pages\n");
+
 	ksft_set_plan(2);
 
 	test_soft_offline_common(1);
_

Patches currently in -mm which might be from rppt@kernel.org are


