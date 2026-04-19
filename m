Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F116FF37;
	Sun, 19 Apr 2026 06:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776579934; cv=none; b=Tow3j/hmgHSULke+5NzGsee6jBCAUwS+52pg3+m3agnaBiLW1/10BWCZbqgsIGolKmtaQWFzFahtyaHwhzbLzyu3HZrowkODcsdhU6yAIexXHHY1p/RpzYZW5rW7lju02pNthBYpteGcDAIrRi6inuCC6mZVnnU0SdsVAjB7UXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776579934; c=relaxed/simple;
	bh=ltqSkCpvXKgRiaVGgIcRlpZruGbbg8rbVYHBtGYT4z4=;
	h=Date:To:From:Subject:Message-Id; b=nrbspbJQPvWa4fo6pE0uWzco/19lYjZzziG3hy/o7UDIZPeMc+ypUnu2tV5M6swfzg9KJ4j+fcY5r90Ow40ByY0i3fcnMDcUQK5w0fGiGAbuv7w7EhYk/DxPC77oE0caTr9AE9ugBh0uOSVBy7LfXZVPRNW2qxtyGrncUR512dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PLv3RfEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PLv3RfEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F7DC2BCAF;
	Sun, 19 Apr 2026 06:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776579934;
	bh=ltqSkCpvXKgRiaVGgIcRlpZruGbbg8rbVYHBtGYT4z4=;
	h=Date:To:From:Subject:From;
	b=PLv3RfEbFz6hq8VYQ+Q0TwiYURM1C0pKEt5Diil7onLlOhPMKW7TVtB4+3M70baFE
	 btNVvi8/y5pbp5ZuI+fQX0qseYYChKJJXZPfsYnFnweOecPRjZ11D8rpaiFo8JGDv/
	 b2+YpaugpHSnc9z41ft6nKoZSTMblWn+aFDDU1mI=
Date: Sat, 18 Apr 2026 23:25:24 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,martin.lau@linux.dev,ljs@kernel.org,liam.howlett@oracle.com,josef@toxicpanda.com,inwardvessel@gmail.com,hannes@cmpxchg.org,dennis@kernel.org,david@kernel.org,axboe@kernel.dk,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch removed from -mm tree
Message-Id: <20260419062533.74F7DC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()
has been removed from the -mm tree.  Its filename was
     mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260413-blkcg-v1-1-35b72622d16c@debian.org
Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

