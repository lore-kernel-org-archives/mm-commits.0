Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C35336215B
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025194; cv=none; b=AnVAWRPWLkQ1LZcgf09d6/Tw85RbaO7flfJJOMVNQJEmvYeH5L+0JTNwOsukhKnwr2sN/v5+cAd2juK4RToYFNZrknHeZ5c4z52n1dmYT/gcXZ4CZBWgQxjmSb80jGgIHSmjV7vDbu6TgdjYfD6W2QNzBWR/NuUuPQ68Zh0y1K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025194; c=relaxed/simple;
	bh=5MMDBgOXMKggtQMAMBHVOOfPi5F5ZrZ5dj5IXXr6YIU=;
	h=Date:To:From:Subject:Message-Id; b=WjfrzIlsNVwNTtyXBzp0+FrFaOP+r7gbxkWGe9bVDiEX0BuC0PN8PSWW5f54r2kQSoKY6R073/U7JxcayjfDNuuoPFZbhHaPqs5VFfKi+w+UShfHzHfJLm/DykhSjxpX+cghcigtQZksKxlLbVQcSiovKJf6x9xUhyMx5NmPS9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DfmGjejm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DfmGjejm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A4C19425;
	Fri, 24 Apr 2026 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025193;
	bh=5MMDBgOXMKggtQMAMBHVOOfPi5F5ZrZ5dj5IXXr6YIU=;
	h=Date:To:From:Subject:From;
	b=DfmGjejmUe885F2VbxC3O2ZwsWVU7bSy7+CQf31+5sZt73WtL9xKJdDJyOeeW7TLl
	 cWUGoK27OaAo1h+RZp9wMTfoEWR29ZG0C4wTqO7f29vArgLmbPNyDx4G0BOTebPYWN
	 YLmXvOxKzgywGkNa3SdsDbffNYzfABep0xuR6bHU=
Date: Fri, 24 Apr 2026 03:06:33 -0700
To: mm-commits@vger.kernel.org,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch added to mm-new branch
Message-Id: <20260424100633.D15A4C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
has been added to the -mm mm-new branch.  Its filename is
     selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch

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

maintainers-update-li-wangs-email-address.patch
selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch
selftests-cgroup-avoid-oom-in-test_swapin_nozswap.patch
selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch
selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch
selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch
selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch
selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch
selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

