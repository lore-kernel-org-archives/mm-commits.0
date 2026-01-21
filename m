Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7FC363C59;
	Wed, 21 Jan 2026 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966109; cv=none; b=gfVWu9lXW2Id4u9ufOyPv5QFZ9rSTVEFupXFQOU8RK86G3e/aCRP1+V1R5MErMdehS+40dUZaVwFWE8iedsdvytdOx4KDeba1C59U3/DeqD9Y8Yw+JD4aJ6auq8pR7LK2tGzzqQKqpnpKb7ovMfxOsxgYPByJbsWGIS7PnnkokA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966109; c=relaxed/simple;
	bh=jxbecehb3fxRg7bAJDc8UCXVIdPqLfk/qYMlbaRmtvY=;
	h=Date:To:From:Subject:Message-Id; b=jTfjYFVBxrY27zNnXcnHfXEJbUBjVMbCaOcgWfdqxWzS5p5Yol45+56WizCQGxMkXNLRvda3/hn5uZSx3L1M8bRnC4lSZLeGkAOYi5CoY4AvjzkcuU+6CIcxG7hy7ETxpOEgNAgVSf+f3vgTx6vqGxGH36d/bkPUbuDmzQI5SLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wVXARapK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wVXARapK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5112C16AAE;
	Wed, 21 Jan 2026 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966108;
	bh=jxbecehb3fxRg7bAJDc8UCXVIdPqLfk/qYMlbaRmtvY=;
	h=Date:To:From:Subject:From;
	b=wVXARapK19k3+Y2H34Zh8ry+xa4wTj4Cs2mryKXF1b83jh2qe8K3HdEz9xFsn+GFn
	 2Ed3DTpG3gv/DaOaN1fKbSB7wvgFh1k5GEmNWsI283lk3sKZhEJTqBEoF/ou5HrvEd
	 SW6rpAc7V8sQSdufFDg/0LKUOD0IPrDs4UjUBwGo=
Date: Tue, 20 Jan 2026 19:28:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch removed from -mm tree
Message-Id: <20260121032828.C5112C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
has been removed from the -mm tree.  Its filename was
     selftests-mm-charge_reserved_hugetlb-drop-mount-size-for-hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

=== Error log ===
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
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Li Wang <liwang@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
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


