Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDF409E12
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525562; cv=none; b=GtJq0VrzN+WFP96ZQYX1mWFwTCGsJhp9BC5mEPaePKVHDTnUcK2JM4x1TBb54x8JJQl5JR7BUYQdB2NQH7lssTTtOXgyK3mH48HR3WhgX2zVogBGMMvvtNv5kXjbukuHeAegdLro0SLXIjjhcHLOcyAikGCNLiwDNWL+unLkB5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525562; c=relaxed/simple;
	bh=e+rvJFBSc9I5L45nDQp2QvzQUq4248EnHT4K/Qthhms=;
	h=Date:To:From:Subject:Message-Id; b=rwR9RXT6lmWfM/kZZkaHLaZcLwhB6Aj0Ed+qG+DyWmVxZFaSlEMODdw9BG5NoTtsjQ6XRKN6l/rrsMJ819PxtKN4eqiGkgW6chBE5X260R7ThN9eM5B63caaXN8Pr7KFG8ZTkkAbXo6Mfq14EtBZWF8Q1OQ9DspDb61qx2KtH7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sF4YWdm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sF4YWdm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383571F000FF;
	Fri,  9 Oct 2026 05:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525558;
	bh=EVg6VPhAiRF7MFvFQzB1H3HKv+D5HkLelJlTr9FnTVE=;
	h=Date:To:From:Subject;
	b=sF4YWdm/QyQme6fpgbKdgPEyd12a0jttduTU5plX9iAOwJ03Sm9iQl9kEHQdHrsOD
	 oYHvnuohwH9tkHUiG7VxUYaP0Iao3WkO5FRGxeVAcw66ccizb1L2/SY1lG+ANb2zW+
	 qgRTyE3GQri9PMaaAMq7RTv/hQ0dnro2kT2vu1iE=
Date: Thu, 08 Oct 2026 22:59:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch removed from -mm tree
Message-Id: <20261009055918.383571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
Date: Sat, 12 Sep 2026 22:29:03 +0200

The XFS setup for ./khugepaged all:file checks that the kernel supports
XFS but not that mkfs.xfs is installed.  When CONFIG_XFS_FS=y and xfsprogs
is missing, mkfs.xfs and mount both fail, but
SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set. 
The test then runs against plain tmpfs and six subtests fail.

The script already has a skip path for this test, but it never runs
because the path variable is always set.  Assign
SPLIT_HUGE_PAGE_TEST_XFS_PATH only once mkfs.xfs and mount have both
succeeded, and remove the image and directory otherwise.

Link: https://lore.kernel.org/20260912202903.16157-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/run_vmtests.sh |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -435,11 +435,15 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH
     if test_selected "thp"; then
 	if grep xfs /proc/filesystems &>/dev/null; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
-	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
+	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}
-	    mkfs.xfs -q ${XFS_IMG}
-	    mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-	    MOUNTED_XFS=1
+	    if mkfs.xfs -q ${XFS_IMG} && mount -t xfs -o loop ${XFS_IMG} ${XFS_DIR}; then
+	        SPLIT_HUGE_PAGE_TEST_XFS_PATH=${XFS_DIR}
+	        MOUNTED_XFS=1
+	    else
+	        rmdir ${XFS_DIR}
+	        rm -f ${XFS_IMG}
+	    fi
 	fi
     fi
 fi
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch
mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

