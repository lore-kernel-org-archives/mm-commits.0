Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995EA366560
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067124; cv=none; b=Q84RaoKteGM7303uKgDFiyAAJAotG1ps8vAT3FqW9thKfxA3DAlrjW83b5DnzqXNWYLFxj6DQ+v1bPyAqrVlmyYg2SacylfY+zrJkmwpQYxOt0WjkoPFqs2VzYSQVFthsxWhQG/GtDfpbJQFSd0AnINYXfVqCIQljSd6fGGt62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067124; c=relaxed/simple;
	bh=TqkR9TJqNirdyYVUSWPY0Op7K9xvXHAH2ca6yFwrlPM=;
	h=Date:To:From:Subject:Message-Id; b=hG8pTsatIbLSyeDWvq4FGhSynXD00/gzlOv6Hr03rPFUVKfgpqrSpw7v3raoBVfcDulOI+OPi77cF/W05o16sYOVSDfljgMji/OTgn5/HYYtRvnbkn0zw1I9t8mSUBmDTyETd5bd/dY3tKG08lm7M6LBbgMsilS0bbNmsazlNsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMkLEHxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMkLEHxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FC91F000E9;
	Sun, 21 Jun 2026 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067123;
	bh=T1Qd1F4QS26jnaaFFq8X7Pv7Pr3otMzbw2l8VrYJxY0=;
	h=Date:To:From:Subject;
	b=gMkLEHxH20QmJbhKdV3Ql/ZbwoXakIlK6Cr126rhFSM9ASabJTyICLLnjnIMgYZ9g
	 fXdEgO6vz6QMTXUXEWCOyl3Y7CR/7dy48hm+dKC5jdGMcYynbNSDIjmbi7y6GaBM2N
	 v8uPTiDPD8/dJOK7adIYhg2QEaitqYFmYQ25318k=
Date: Sun, 21 Jun 2026 11:38:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch removed from -mm tree
Message-Id: <20260621183843.72FC91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
Date: Mon, 11 May 2026 19:27:49 +0300

HAVE_HUGEPAGES indicates availability of free HugeTLB pages.  It should
not be used to gate KSM test that merges transparent huge pages or
split_huge_page_test.

Remove check for HAVE_HUGEPAGES when running these tests.

Link: https://lore.kernel.org/20260511162840.375890-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
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

 tools/testing/selftests/mm/run_vmtests.sh |   22 ++++++++------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -437,9 +437,7 @@ CATEGORY="memfd_secret" run_test ./memfd
 fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	CATEGORY="ksm" run_test ./ksm_tests -H -s 100
-fi
+CATEGORY="ksm" run_test ./ksm_tests -H -s 100
 # KSM KSM_MERGE_TIME test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
@@ -492,16 +490,14 @@ CATEGORY="thp" run_test ./khugepaged -s
 
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
-    if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	if test_selected "thp"; then
-	    if grep xfs /proc/filesystems &>/dev/null; then
-		XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
-		SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
-		truncate -s 314572800 ${XFS_IMG}
-		mkfs.xfs -q ${XFS_IMG}
-		mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-		MOUNTED_XFS=1
-	    fi
+    if test_selected "thp"; then
+	if grep xfs /proc/filesystems &>/dev/null; then
+	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
+	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
+	    truncate -s 314572800 ${XFS_IMG}
+	    mkfs.xfs -q ${XFS_IMG}
+	    mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
+	    MOUNTED_XFS=1
 	fi
     fi
 fi
_

Patches currently in -mm which might be from rppt@kernel.org are


