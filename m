Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FEE2D5932
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787943950; cv=none; b=QRv4yZRwPf0kIO7L3MMfLmFr7tfEtFhdo6tPDDlE0dNZG+zCFTiBsNaZq6bmP3B7rzVuuJ2J5BRNufwmfvtpGJdYYbOxWBaBkBUiKWHiJbkeAOMYcLKTrB6QFc3OBnbOnGudYcKXRRwl7QZH2DS6Gt6QR1/ux4T7qeUUnRHY6qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787943950; c=relaxed/simple;
	bh=px3vbFzfLQee2eP68A0/sM2nW4+W5uBiwPLNhV4g3Fo=;
	h=Date:To:From:Subject:Message-Id; b=QYnGFlALOrVua0vlhJHggu5ULqrizXWkTFpHsKZEX9Vt9oTpgPM3l5WxvShITkUKMp7MuQtvVXyvWyaV+Jnpj5pkwaH48Owx0+eewpYKb1NMsWwa2kQpNgHo1QCBsyaBl10lQ51srBH/Vv7rFRUyMSWFJkay+EV/YmALwN84eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPQGltek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPQGltek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF8E1F000E9;
	Fri, 28 Aug 2026 19:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787943948;
	bh=J3TUjWuymc1T4WDfLsm1wIV0SJlmxrtPjA0Dw8WdImw=;
	h=Date:To:From:Subject;
	b=MPQGltekWXT54IBk7m5/lM9J36JWSMf8eTbMxj/SZQFiu2+aHCtQy0BbzRhhK0qV/
	 gOtMEnRU0QSoyPeHYZVlFPsp4xZoLmqJ4jLyIzR0w4LcPjZVa91yIRXWdDBsL1lN2N
	 j8Dd2hFY9w+BnDEzCFAVuGaVQAG+zqb9TfQOXeE0=
Date: Fri, 28 Aug 2026 12:05:48 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch added to mm-new branch
Message-Id: <20260828190548.9BF8E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: test_zswap: wait for cgroup to unpopulate in test_zswap_writeback
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch

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
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: selftests/cgroup: test_zswap: wait for cgroup to unpopulate in test_zswap_writeback
Date: Fri, 28 Aug 2026 03:37:31 +0000

Patch series "selftests/cgroup: fixes for test_zswap on single core VM",
v4.

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY.  We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.


This patch (of 2):

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY.  Under cgroup v2, enabling domain subtree
controllers is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately.  However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting task
is switched away via finish_task_switch() -> cgroup_task_dead().  On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Link: https://lore.kernel.org/20260828033741.2184560-1-wfelipe@google.com
Link: https://lore.kernel.org/20260828033741.2184560-2-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -408,6 +408,8 @@ static int test_zswap_writeback(const ch
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
 
_

Patches currently in -mm which might be from wfelipe@google.com are

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch

