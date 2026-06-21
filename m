Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AE036F8EB
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067173; cv=none; b=M4ZDMvZKMH1TXeCd1HJ4aWpO19EBi1RWsCfObWbkIqKjMEqnr9hyciSmam+THhM0binhRohlYxfImtDc+uUSLthCxvg2d2aGyKP2twE6kwYMWXYUHrtyMRnscJKTs4bcmfYUGeI9P3hI9DTOV8l0icFqEmhGEVBrTsKF3D4dRlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067173; c=relaxed/simple;
	bh=tc4gR0GJmQ9g6QkhJ6L4Gh148wELdYylqfZModfx/GU=;
	h=Date:To:From:Subject:Message-Id; b=HiIWeuSjzw22lRfeX6QYWsBz/U/JDF8XyNFxb6Y0C9bOtZkaeWXBkIDoje/orbE+Iu+7l0svnATkHw6ITs7dttfozkQcTybsGJs/DTZxbNbM1Ymxa6yrEsRRTvO48Pi44nVN0NKgVUmmWPwzcc7cswiIcDt9GopYE1UPSN2LweY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLE+cRHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLE+cRHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC581F000E9;
	Sun, 21 Jun 2026 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067172;
	bh=2syIOX8nzHq21uh8j50Stac+5P1RlVTekBeXIOkyQ7w=;
	h=Date:To:From:Subject;
	b=QLE+cRHZ/MwPA8jtGIUZkhIxEWOCRAUYlHrQKpGl75JNdOVpJeq6uDFh0LBNBnYhY
	 g7m1wVNfXKitgZXaAJWpdJrbryBmK5V+g81L4AyD1L9Qnt92DwNU7+mywZ/wWVbIzx
	 9PW+ClAAixIIKKSQbSzy6qIOd4skzYtMDQhpfilo=
Date: Sun, 21 Jun 2026 11:39:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183932.0BC581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb-shm: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: hugetlb-shm: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:26 +0300

hugetlb-shm test fails if there are no free huge pages prepared by a
wrapper script and shm liimts in proc are too low.

Add setup of HugeTLB pages and shm limits to the test and make sure that
the original settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-43-rppt@kernel.org
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

 tools/testing/selftests/mm/hugetlb-shm.c |   22 +++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-shm.c~selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,9 +29,27 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
+static void prepare(void)
+{
+	unsigned long length, hugepage_size, nr;
+
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Unable to determine huge page size\n");
+
+	length = (LENGTH + hugepage_size - 1) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough free huge pages\n");
+
+	shm_limits_prepare(length);
+}
+
 int main(void)
 {
 	int shmid;
@@ -41,6 +59,8 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	prepare();
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
 	if (shmid < 0)
 		ksft_exit_fail_perror("shmget");
@@ -76,3 +96,5 @@ int main(void)
 	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
_

Patches currently in -mm which might be from rppt@kernel.org are


