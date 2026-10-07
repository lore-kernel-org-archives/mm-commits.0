Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD02DEA8F
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334207; cv=none; b=N+QzSGcdicCvSnn38JFYbTwiKkoYkg0qtMTf6bZ/xdClOVU+1ngMP8+OvNjKecbfRfzVe/wJkgPucJkbVjr7mci29UWDj4m98r1ItT+sIKx/4NkIEUpFN+rwUkBwnRRYgdcL0UJVMXkOQr2NsnsSiac29zLFFJB8Ly7etxog13Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334207; c=relaxed/simple;
	bh=++t7AlCkfpKouYqWxlPlo34mYjboXGYwthspuO3UmCU=;
	h=Date:To:From:Subject:Message-Id; b=cxw0SbEhbtZOMwrsDZlWC34jxO5Txop08mMdKmgzDri5uzCSiXtIo+0Sc4W0De8KzDgQyk9MBW7/840YdNJ+tXBbHIpxylKuXY+q44nnDwxaw8+t3HZ1nlsv8A954WdXGbNJlLgjuamvna5fwxcdgHgIwVVogLKFRvzYkrJ+BS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uJ9xz5yd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uJ9xz5yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878381F0089B;
	Wed,  7 Oct 2026 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334206;
	bh=76sMvNOaFZ7fIlwqt+G4D4znWr8oq8QN/IebwVbT2C4=;
	h=Date:To:From:Subject;
	b=uJ9xz5ydyjU2dX2K0gn6LjUQVHZwkW+pmVuZAwhurKFF0v4KQEo7gfIMlVGZCPZco
	 8ijb4YMqVxR+fDP5xBOc8Isb0ryl98EWqiPRQvNkX1G1lf3RM/4mQCYBeL+dkSnz3+
	 63T9/2nKXFiNY9TN7xfwIwJGIP+AIiQeHwuDtodM=
Date: Tue, 06 Oct 2026 17:50:06 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch removed from -mm tree
Message-Id: <20261007005006.878381F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: test_zswap: wait for cgroup to unpopulate in test_zswap_writeback
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -409,6 +409,8 @@ static int test_zswap_writeback(const ch
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
 
_

Patches currently in -mm which might be from wfelipe@google.com are

mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch
init-main-fix-off-by-one-in-argv_init-cleanup.patch
init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

