Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C771C28002B
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638947; cv=none; b=EbkV1XqFeFmabCVVQV8a1N6jKhqlH97AJANLA2iZNGa/6IDb5zpm2A/4Pf8G2ZVQG5axUohwikjs3ZWr31D7fBdKJJSLVVAIgU/9F+b/+AR0vLDjlLZABTQxLTUiZqRJS8ALLp2rf2trUMuqFwuyDPn+Lu7S62SuENXV4aRlBVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638947; c=relaxed/simple;
	bh=j+92rW7NjUUsbjZr1laAgX2gTxDTfwM/iDXhKJL51Qo=;
	h=Date:To:From:Subject:Message-Id; b=T8TvGMafpiNcvdj1OWQS260sEbKmre8OPm52lH9Uu0e+3Pk+w3uHGiKB/+dzSfa+RNyCcZ1o5TnNgpKQXQpPmejLAY8L752t0DZ0tO+BIWQ4ABXyEpH21WERK6keNh94i+2u5hYPaJ+vuS2IHjtmWF02TLAps2jn+aiBF/gxD5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=glAk2rSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="glAk2rSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FCC2BCB4;
	Fri,  1 May 2026 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777638947;
	bh=j+92rW7NjUUsbjZr1laAgX2gTxDTfwM/iDXhKJL51Qo=;
	h=Date:To:From:Subject:From;
	b=glAk2rSmJx2+tvnDyMka5Wkz0lrWfwUv43aQyLHbS/upib6lbQkWeF+r28lR8OYgE
	 CI4EO5pk2D1LdkKprU+CEU2ZkmuCJyrHibLan49I89l2zYZIb+VE54zBDU/dUV5tx5
	 dMo2Qq8fcuJuyw1uSSx+IC1lQB6owdbJ0MyyVokg=
Date: Fri, 01 May 2026 05:35:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,shakeelb@google.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,cl@linux.com,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch added to mm-new branch
Message-Id: <20260501123547.779FCC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: fix hardcoded page size in test_percpu_basic
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch

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


Thi patch (of 2):

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

