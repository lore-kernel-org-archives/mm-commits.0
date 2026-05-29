Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A0F370D4D
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027702; cv=none; b=BITvw9mEgY1Lp23tEKC/8gRQ/Ha9CLeMoBdVxLr7xBXsbzIKBZQ9Ed7Z7XIfa62axR9LZP2W8gPGHJ/duRl/W/c3N0BlP+30UjFV/EduRsdXuV3oqA5YRZqvm1tm9CXabMZvR+Pou7Gsa9mrzBSlcnwbypOG280Kx5r1uUnpn+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027702; c=relaxed/simple;
	bh=OOoj5krpyJb+fTa6PgqQOCzZbUKhKRtFQCA0PbAKkeM=;
	h=Date:To:From:Subject:Message-Id; b=i5RcJq3be2Gb+4eLywhHLGATDQJWVfktYfMMQxpR0cMvRQYfThe3kMmyeKGpR1+FimnH3HDDkt3qMnJXcoBBFRMvWpMeI7GHa+WjR7iGoHUBX+LY4Yomp6cB0CWdDOnB8+YAsKWFsGjJ8BDWAFMrPzmCt4Txyx1rk4SyQkYmgkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=diZfABaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="diZfABaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AD91F00893;
	Fri, 29 May 2026 04:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027701;
	bh=Z0PvelFAiJkXTHdLf6rKbIoUbdoKrd8VZ0oPOe1r+0Q=;
	h=Date:To:From:Subject;
	b=diZfABaF2eg2kH+16emg9Qw5TlzDtCoqPpb7CrGiOxCGKdXsuHhF4k+o6RtNEewh/
	 qu0VdKSoq+jvYsvez3dUFNQqNRgmzqK260BdvGZifILupHwdmAmDgfgXbJGrrSBV0g
	 xTiZMZR28EghpcVr21HH2Am7Ndqt8aGZz23fCKSY=
Date: Thu, 28 May 2026 21:08:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeelb@google.com,sayalip@linux.ibm.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,cl@linux.com,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch removed from -mm tree
Message-Id: <20260529040820.D7AD91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: fix hardcoded page size in test_percpu_basic
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: fix hardcoded page size in test_percpu_basic
Date: Fri, 1 May 2026 10:20:57 +0800

Patch series "selftests/cgroup: Fix false positive failures in
test_percpu_basic", v2.

This patch series addresses two separate issues that cause false
positive failures in the test_percpu_basic test within the cgroup
kmem selftests.

The first issue stems from a hardcoded assumption about the system
page size, which breaks the test on architectures with larger page
sizes.

The second issue is an overly strict memory check that fails to
account for the slab metadata allocated during cgroup creation.


This patch (of 2):

MAX_VMSTAT_ERROR uses a hardcoded page size of 4096, which assumes 4K
pages.  This causes test_percpu_basic to fail on systems where the kernel
is configured with a larger page size, such as aarch64 systems using 16K
or 64K pages, where the maximum permissible discrepancy between
memory.current and percpu charges is proportionally larger.

Replace the hardcoded 4096 with sysconf(_SC_PAGESIZE) to correctly derive
the page size at runtime regardless of the underlying architecture or
kernel configuration.

Link: https://lore.kernel.org/20260501022058.18024-1-li.wang@linux.dev
Link: https://lore.kernel.org/20260501022058.18024-2-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -24,7 +24,7 @@
  * the maximum discrepancy between charge and vmstat entries is number
  * of cpus multiplied by 64 pages.
  */
-#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
_

Patches currently in -mm which might be from li.wang@linux.dev are


