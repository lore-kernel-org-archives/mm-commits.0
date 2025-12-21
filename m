Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B27A3A1E6A
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766341966; cv=none; b=TnLBR7ORg9pcp7RDxTapIEJLChCYpcT1VbyDFxN22rYT0PHQHL14ucwDxPtJZpfWbQKSvxU78hj+H/VQbnko+FK1y/UHBihm5cs7IKPxJIvypwicbn/aQPdv3nh5ccrd7CybIX5rIruP0VYZJvnCXcFhejA6FRrxceYx0IQtJh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766341966; c=relaxed/simple;
	bh=b9ISN6aKdetn8ItEFi7wl1tqcJ3sRmFWjyxAci8XayE=;
	h=Date:To:From:Subject:Message-Id; b=q1v0nCKLJUoql70VNYJVfCAm2gI3NXtzNgEVkZBdLEmNxujK1ysR3FoL7g++7KvFOTTZMBgAzrAt+heW1c9VYU+5xNVzAWlbJemZuEO0YZYlIPQk4Z9z3anb5YEjqJn7WuitZwjqDL4TYirzpL+tLp4JsyY8Vhq+VojYONFdl6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VclCKMj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VclCKMj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69C1C4CEFB;
	Sun, 21 Dec 2025 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766341965;
	bh=b9ISN6aKdetn8ItEFi7wl1tqcJ3sRmFWjyxAci8XayE=;
	h=Date:To:From:Subject:From;
	b=VclCKMj3VLmlKE5a3hPAfIitN3y1Vrbscv8oGmzoVllBJaqFz1z0q4l71nCgXCRYf
	 ZDahE+tFH4euXLVkNUSvc9w0bm62o3b0VgZx1xPOBFWk+NF/QHt1HHRR2GuEKfJwqS
	 zILHKY3xsPMRvaRI/DOQdu9VXP3NmfgC5/ENIDSo=
Date: Sun, 21 Dec 2025 10:32:45 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch added to mm-new branch
Message-Id: <20251221183245.A69C1C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
Date: Sun, 21 Dec 2025 20:26:38 +0800

charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with a
fixed size of 256M.  On systems with large base hugepages (e.g.  512MB),
this is smaller than a single hugepage, so the hugetlbfs mount ends up
with zero capacity (often visible as size=0 in mount output).

As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
waiting for progress.

--- Error log ---
  # uname -r
  6.12.0-xxx.el10.aarch64+64k

  #./charge_reserved_hugetlb.sh -cgroup-v2
  # -----------------------------------------
  ...
  # nr hugepages = 10
  # writing cgroup limit: 5368709120
  # writing reseravation limit: 5368709120
  ...
  # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  ...

  # mount |grep /mnt/huge
  none on /mnt/huge type hugetlbfs (rw,relatime,seclabel,pagesize=512M,size=0)

  # grep -i huge /proc/meminfo
  ...
  HugePages_Total:      10
  HugePages_Free:       10
  HugePages_Rsvd:        0
  HugePages_Surp:        0
  Hugepagesize:     524288 kB
  Hugetlb:         5242880 kB

Drop the mount args with 'size=256M', so the filesystem capacity is sufficient
regardless of HugeTLB page size.

Link: https://lkml.kernel.org/r/20251221122639.3168038-3-liwang@redhat.com
Fixes: 29750f71a9 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -290,7 +290,7 @@ function run_test() {
   setup_cgroup "hugetlb_cgroup_test" "$cgroup_limit" "$reservation_limit"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test" "$size" "$populate" \
     "$write" "/mnt/huge/test" "$method" "$private" "$expect_failure" \
@@ -344,7 +344,7 @@ function run_multiple_cgroup_test() {
   setup_cgroup "hugetlb_cgroup_test2" "$cgroup_limit2" "$reservation_limit2"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test1" "$size1" \
     "$populate1" "$write1" "/mnt/huge/test1" "$method" "$private" \
_

Patches currently in -mm which might be from liwang@redhat.com are

selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch
selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch
selftests-mm-charge_reserved_hugetlbsh-add-waits-with-timeout-helper.patch

