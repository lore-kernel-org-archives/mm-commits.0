Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A3C36EAAD
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027597; cv=none; b=KYvLjrP8lFN3rl7+TJynaT898BZavkd3eM1zqhJnfPM/WrxMn51hK0sG43e2oM2LqjpwgT1VOH9+os5jz3jAJtMmnqux8Apwy4Mk2HtAjRNkVLLAX3jMYYFETX/x4R88H5VSlINxWW6I4l32gaR6iAcGWsDKgpnc8PMAeq6U0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027597; c=relaxed/simple;
	bh=oN8Q/6RkCtmJ+vhfntvIGyuzI4vdObnf2RHkKtgyemc=;
	h=Date:To:From:Subject:Message-Id; b=kOeAzXwU903bc7y0hKX1PkYaln1WdThrBFkDAXhe7HdbBqO7Br69Gs7qk/5Bt7bCWda2bSvv2OC+zIpl5IWcehGhKrXPo3UK6wDvMIFf/aIDFlhxxuzHJDiS98oSwfM391cZgIT5rF+SM7+S26asDICY0heuSpF6hepo/gL7Guw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9vow7Iw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9vow7Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880B51F00893;
	Fri, 29 May 2026 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027595;
	bh=lf05S6OfUsNFNKwQWDPup1lL3D756n8yKycfFs7PcT8=;
	h=Date:To:From:Subject;
	b=E9vow7IwjpGDwPQRJbDrRR5hlAHQNHF5B/zRs7HbjlPUPMSvQdFUCw9CJi1+V+OWP
	 DuO+4KhBHX4Hb/qOpF3QaHZAnQxVTL90KIMtVvqUUOi6Zyaqat+M/UY6iloQx6XFfL
	 /nmcMfvhZ6iX4zue8P9WsExCaybPcMxc19RyPVwQ=
Date: Thu, 28 May 2026 21:06:35 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch removed from -mm tree
Message-Id: <20260529040635.880B51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
has been removed from the -mm tree.  Its filename was
     selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Fri, 24 Apr 2026 12:00:58 +0800

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K page
size systems.  When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages.  With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/4 insufficient to create meaningful writeback pressure.  The
test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by:
- Always allocating 1024 pages regardless of page size. This ensures
  enough anonymous pages to reliably populate zswap and trigger
  writeback, while keeping the original 4M allocation on 4K systems.
- Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
  create stronger writeback pressure, ensuring reclaim reliably
  triggers writeback even on large page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Link: https://lore.kernel.org/20260424040059.12940-8-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -268,14 +268,14 @@ out:
       This will move it into zswap.
  * 3. Save current zswap usage.
  * 4. Move the memory allocated in step 1 back in from zswap.
- * 5. Set zswap.max to half the amount that was recorded in step 3.
+ * 5. Set zswap.max to 1/4 of the amount that was recorded in step 3.
  * 6. Attempt to reclaim memory equal to the amount that was allocated,
       this will either trigger writeback if it's enabled, or reclamation
       will fail if writeback is disabled as there isn't enough zswap space.
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = page_size * 1024;
 	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
@@ -313,12 +313,12 @@ static int attempt_writeback(const char
 		}
 	}
 
-	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/2))
+	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/4))
 		goto out;
 
 	/*
 	 * If writeback is enabled, trying to reclaim memory now will trigger a
-	 * writeback as zswap.max is half of what was needed when reclaim ran the first time.
+	 * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
 	 * If writeback is disabled, memory reclaim will fail as zswap is limited and
 	 * it can't writeback to swap.
 	 */
_

Patches currently in -mm which might be from li.wang@linux.dev are


