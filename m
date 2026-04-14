Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1B13B5B3;
	Tue, 14 Apr 2026 05:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776143523; cv=none; b=jNriGLDA4iiBGLs+9R+/vLbuQQZ8FSSwK6yE3iAj+uA/wXqo19/UMojrX4ZTHbrXTD4YfALEPAZCVgOnegYAkExUYlYj6yLHARBTn3sSc5QZwL22TfZO0btNSiRK0Dq0BFDvZfMdrB99zs5fKMcsvqzO30TWAklPCKpcRgHr1R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776143523; c=relaxed/simple;
	bh=1ymNdmqnY1or9+axOYo3oczwWdJzb3tphQwKkeLCLUQ=;
	h=Date:To:From:Subject:Message-Id; b=aeEKBBAUNE1/F6DJcdE0P+grqOurKshap7M+vVF+32Sv4I2bGaPrHKn3k1AYm5fRBh3ueYw+tCBZfcmFuMhuerV+2OpWCF8QRBS/w5PPvcE0mi9k/809/FltiI+fkvR7Dap8B9Qe2hGILHKGRkZ310bVULpimpbrzhrsA0073Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqghoyVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqghoyVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAEBC19425;
	Tue, 14 Apr 2026 05:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776143522;
	bh=1ymNdmqnY1or9+axOYo3oczwWdJzb3tphQwKkeLCLUQ=;
	h=Date:To:From:Subject:From;
	b=tqghoyVFEQgM8UL4H2nOFGJkRMK+ARutPTnorHOtWgQF+MseRBJ54uhwvEC1KfaSJ
	 f8aJD5Lpk5et11pgJExHped9EU7xcKTdDkazna36rt4IZeDG0k8nsCLDynIx++sKSR
	 YDkrfQ6IlsWaI4r5/InkKhzM1H2pze43D2bhnntA=
Date: Mon, 13 Apr 2026 22:11:58 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,martin.lau@linux.dev,ljs@kernel.org,liam.howlett@oracle.com,josef@toxicpanda.com,inwardvessel@gmail.com,hannes@cmpxchg.org,dennisszhou@gmail.com,david@kernel.org,axboe@kernel.dk,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20260414051201.DBAEBC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()
Date: Mon, 13 Apr 2026 03:09:19 -0700

cgwb_release_workfn() calls css_put(wb->blkcg_css) and then later accesses
wb->blkcg_css again via blkcg_unpin_online().  If css_put() drops the last
reference, the blkcg can be freed asynchronously (css_free_rwork_fn ->
blkcg_css_free -> kfree) before blkcg_unpin_online() dereferences the
pointer to access blkcg->online_pin, resulting in a use-after-free:

  BUG: KASAN: slab-use-after-free in blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
  Write of size 4 at addr ff11000117aa6160 by task kworker/71:1/531
   Workqueue: cgwb_release cgwb_release_workfn
   Call Trace:
    <TASK>
     blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
     cgwb_release_workfn (mm/backing-dev.c:629)
     process_scheduled_works (kernel/workqueue.c:3278 kernel/workqueue.c:3385)

   Freed by task 1016:
    kfree (./include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6246 mm/slub.c:6561)
    css_free_rwork_fn (kernel/cgroup/cgroup.c:5542)
    process_scheduled_works (kernel/workqueue.c:3302 kernel/workqueue.c:3385)

** Stack based on commit 66672af7a095 ("Add linux-next specific files
for 20260410")

I am seeing this crash sporadically in Meta fleet across multiple kernel
versions.  A full reproducer is available at:
https://github.com/leitao/debug/blob/main/reproducers/repro_blkcg_uaf.sh

(The race window is narrow.  To make it easily reproducible, inject a
msleep(100) between css_put() and blkcg_unpin_online() in
cgwb_release_workfn().  With that delay and a KASAN-enabled kernel, the
reproducer triggers the splat reliably in less than a second.)

Fix this by moving blkcg_unpin_online() before css_put(), so the
cgwb's CSS reference keeps the blkcg alive while blkcg_unpin_online()
accesses it.

Link: https://lkml.kernel.org/r/20260413-blkcg-v1-1-35b72622d16c@debian.org
Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c~mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn
+++ a/mm/backing-dev.c
@@ -618,12 +618,13 @@ static void cgwb_release_workfn(struct w
 	wb_shutdown(wb);
 
 	css_put(wb->memcg_css);
-	css_put(wb->blkcg_css);
-	mutex_unlock(&wb->bdi->cgwb_release_mutex);
 
 	/* triggers blkg destruction if no online users left */
 	blkcg_unpin_online(wb->blkcg_css);
 
+	css_put(wb->blkcg_css);
+	mutex_unlock(&wb->bdi->cgwb_release_mutex);
+
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 
 	spin_lock_irq(&cgwb_lock);
_

Patches currently in -mm which might be from leitao@debian.org are

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-kexec-metadata-track-previous-kernel-chain-fix.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

