Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B9370D55
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027703; cv=none; b=hnolIADK/Fim8IO0lZ68xjQ7PzzbIWD0Wr6AOojiQx4eQ8z5ubafdmhPopyp+XzwCORT2qp3wdK84Z8cl1ZGflroL49wDjszz7B1KYfmGmTR1tQ0R9a7jz5zBNfKv2gLnZpX74XfgMg5zghhppu305h/4uisWJPTsX1/60gxXh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027703; c=relaxed/simple;
	bh=zkZxDVOPGA4mH/3mBJQtVYjMapR0nxZ0kOrI+qVlo9E=;
	h=Date:To:From:Subject:Message-Id; b=ZlnzEj30acrV3/RYJ0AMc4Bw8uNc8HgEzDUn/pYHBcAwc5vWLdc7RlNTV50Sw2Q8Xp3x5fZNt//fhm+nWcLR7vqGNnMN9+/f1sT6Sgko4UujV4Gi5H7Uyj1a0CgJQM/O8LX/rWlVkxnTGQQuFS/PY8S/kYPtAX6GM/0g0R1+rJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ie20nPeI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ie20nPeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123F61F00898;
	Fri, 29 May 2026 04:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027702;
	bh=HoEphjXN3qvL/meTtGPBOIqlWu+Kfhtd83/zJNluleE=;
	h=Date:To:From:Subject;
	b=ie20nPeIxsGq3omrNWgurp4DoGmwosJm8ijv/TehfeKsuH5DJ8hvngCD1HjvNMzgR
	 +FG//BwVvquyFwJfGzY5xJxZXUqYeZvEIZyZ6Xm0e3/AoAI6FYbRcluCShHVnr9lGD
	 geU0ybHRsPVjS2wYed8VvSu2as68nq5h9tNCzzug=
Date: Thu, 28 May 2026 21:08:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeelb@google.com,sayalip@linux.ibm.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,cl@linux.com,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch removed from -mm tree
Message-Id: <20260529040822.123F61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: include slab in test_percpu_basic memory check
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftests/cgroup: include slab in test_percpu_basic memory check
Date: Fri, 1 May 2026 10:20:58 +0800

test_percpu_basic() currently compares memory.current against only
memory.stat:percpu after creating 1000 child cgroups.

Observed failure:
  #./test_kmem
  ok 1 test_kmem_basic
  ok 2 test_kmem_memcg_deletion
  ok 3 test_kmem_proc_kpagecgroup
  ok 4 test_kmem_kernel_stacks
  ok 5 test_kmem_dead_cgroups
  memory.current 11530240
  percpu 8440000
  not ok 6 test_percpu_basic

That assumption is too strict: child cgroup creation also allocates
slab-backed metadata, so memory.current is expected to be larger than
percpu alone. One visible path is:

  cgroup_mkdir()
    cgroup_create()
      cgroup_addrm_file()
        cgroup_add_file()
          __kernfs_create_file()
            __kernfs_new_node()
              kmem_cache_zalloc()

These kernfs allocations are charged as slab and show up in
memory.stat:slab.

Update the check to compare memory.current against (percpu + slab)
within MAX_VMSTAT_ERROR, and print slab/delta in the failure message to
improve diagnostics.

Link: https://lore.kernel.org/20260501022058.18024-3-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-include-slab-in-test_percpu_basic-memory-check
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -353,7 +353,7 @@ static int test_percpu_basic(const char
 {
 	int ret = KSFT_FAIL;
 	char *parent, *child;
-	long current, percpu;
+	long current, percpu, slab;
 	int i;
 
 	parent = cg_name(root, "percpu_basic_test");
@@ -383,13 +383,14 @@ static int test_percpu_basic(const char
 
 	current = cg_read_long(parent, "memory.current");
 	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 
-	if (current > 0 && percpu > 0 && labs(current - percpu) <
-	    MAX_VMSTAT_ERROR)
+	if (current > 0 && percpu > 0 && slab >= 0 &&
+			labs(current - (percpu + slab)) < MAX_VMSTAT_ERROR)
 		ret = KSFT_PASS;
 	else
-		printf("memory.current %ld\npercpu %ld\n",
-		       current, percpu);
+		printf("memory.current %ld\npercpu %ld\nslab %ld\ndelta %ld\n",
+			current, percpu, slab, current - (percpu + slab));
 
 cleanup_children:
 	for (i = 0; i < 1000; i++) {
_

Patches currently in -mm which might be from li.wang@linux.dev are


