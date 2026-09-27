Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DB828505E
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 06:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790488941; cv=none; b=tnBELi2j2MPWkMNPzN+aisMV8WjAvdd497vRXCK/chQDgn41+3ZP0VO7wITruTVALQOq7cb3pnDgEUpL1hzxskf3tEtdChxO/Wg0/gi5V+S4SJkYaTH7x5jhQE1t6FxnsPH72slEY7TV2NvLnEpdIiaXMvdtvP4fHsRVFMVPhZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790488941; c=relaxed/simple;
	bh=OSpYv7q/enz4TZTpwOmg9mduvZH3wIageXJpFjShyPA=;
	h=Date:To:From:Subject:Message-Id; b=IiIxmz2fhcTcq4dz7AQhmKUWhOIH9qLSejkAo24/v7xo8jdZiT2d9/+FdKHej/LHORJfLNpGKnKieT1Zj1b5Y3WXPqA4VHaAySLrmmPKZ+m58BMt6ugvJUgc/d2KdcmnJ3SHzL+6USeVbZQnOz/4YJpUMWPuBbwYhSs23tn925w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCcN10Hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCcN10Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DB1F000FF;
	Sun, 27 Sep 2026 06:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790488939;
	bh=0Rfh1THLAe0XgiD+/pQq8TD7djOzc/Vr7cfsbL2tlk0=;
	h=Date:To:From:Subject;
	b=yCcN10HvMmAsgWKdmr7dOIR1XJhmq65OaaqXPRNsf4vRUaPrPCaVkfSGNaNtZS/Sf
	 7qpKZa7GzAGK9BTqjKNiWUmDU8NPGGN67GvftbIksrfsMlnWOabEHiWztEMq3+JVJx
	 yW8jsZ2oOHbNEXPBY4TKPjC0S/Avt++da/iwj4kg=
Date: Sat, 26 Sep 2026 23:02:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch added to mm-unstable branch
Message-Id: <20260927060219.413DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch
selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

