Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D695D3A4F26
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638949; cv=none; b=dyIxQ4fuj1eBsvWAXeulVSAGu/POEcGkW7ih+gMZGu0XPoSsmLWi5LyGwgnH67cc2hFpPDCEbtDstb9/1AOGCfBPMFsIehkTJP8+piI69xcGOmU84jDno1n6CNdPQFGWlk/dC1YLJXOhrOlDh0O9LJqIxZXmXhXY4/Jc47GCVVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638949; c=relaxed/simple;
	bh=xvSVvF9WrgDkC4Y95og+EY5X2F5L2VauJZ6etEhWdc4=;
	h=Date:To:From:Subject:Message-Id; b=E1yuvGiARzQjEXl6C42LG493WWpJNd2KOGUYKBdCRTaWp+Bvi+PzGJgXo6Ont7yafkReiBIcObvAAIw7ujR5OpMSJdgYO4+sVE/Dlovr+46VcBVaHrbzAZ0tf+N9DQS1b9kXbDoItSXtsDIHNvV9v88qPoapgXmlamR15Znjxlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBwyANlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBwyANlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9731AC2BCB7;
	Fri,  1 May 2026 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777638949;
	bh=xvSVvF9WrgDkC4Y95og+EY5X2F5L2VauJZ6etEhWdc4=;
	h=Date:To:From:Subject:From;
	b=TBwyANlMd2HQMP9UDHBXWVLEcuJbacW33RZGfYFCVzWJrfYWp+5yOoySIe3rZeOCY
	 wDx8zMq2aTiirUpVbJjh/ofRMpaDgzkGWTwBXM6bY4a9x68D82iws1X/Lkm+slkNPf
	 bJ/vofX6DJfhAgW+AnY9XpcQh6rosUZdzIn4Gc2Y=
Date: Fri, 01 May 2026 05:35:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeelb@google.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,cl@linux.com,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch added to mm-new branch
Message-Id: <20260501123549.9731AC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: include slab in test_percpu_basic memory check
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -379,13 +379,14 @@ static int test_percpu_basic(const char
 
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

selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch
selftests-cgroup-avoid-oom-in-test_swapin_nozswap.patch
selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch
selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch
selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch
selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch
selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch
selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch
selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch
selftests-cgroup-include-slab-in-test_percpu_basic-memory-check.patch

