Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419683DF014
	for <mm-commits@vger.kernel.org>; Thu,  9 Apr 2026 15:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749545; cv=none; b=eL03lt3rLWtAzKotws4WB4hBec+5EMS4Gm3Og9816oNEfycdAtUYht7VwbWiXo670u+2qWftkBFFTAjcvvH1s9Q5WMUOALSkD55Nf+6+nf4alrbU2Xwj0Vtubkdl5bg0q8/4xC7S/LWymYxtgew9WHYY6cMhHP8s3R4JVawTM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749545; c=relaxed/simple;
	bh=VnpFXxjKN74iNJUEULCPWEWnMhPVMiAkEZA4MYCfZWg=;
	h=Date:To:From:Subject:Message-Id; b=lG/S2xZnxPVhtDg2/6U7RPP7HC12n2Gbfkd8EB0XUfyRNpDjwV1jnlkhH2XMplhnAY4Pir63epWG6Vtu37JUFNd1x3i3Aq/sZ4bXSWNiS5aBFm/4Uwdt6Nrzc//S+Lw6E9W7YRvruBQlQNPgkIHo4jDC7VcPbsGBr9tjqRgx5dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUW27CTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUW27CTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020F2C4CEF7;
	Thu,  9 Apr 2026 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775749545;
	bh=VnpFXxjKN74iNJUEULCPWEWnMhPVMiAkEZA4MYCfZWg=;
	h=Date:To:From:Subject:From;
	b=LUW27CTTjja2Ls7KoAiGtF4HjPvPgJC5E6OabEYmuB6+EfCxSHov5kE9HRpMi9/id
	 6sqMKg6unBH+moPEBSU734f3SSva90pA+IMTpQYjRDUPU6NyrRwlrXI8u0KBAoSPFp
	 HWahpVZhqi13O0Fo/tShbDiavF5Pc1NPGikGqORo=
Date: Thu, 09 Apr 2026 08:45:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,cl@linux.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch added to mm-unstable branch
Message-Id: <20260409154545.020F2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
Date: Thu, 09 Apr 2026 05:26:36 -0700

vmstat_shepherd uses delayed_work_pending() to check whether vmstat_update
is already scheduled for a given CPU before queuing it.  However,
delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT, which is
cleared the moment a worker thread picks up the work to execute it.

This means that while vmstat_update is actively running on a CPU,
delayed_work_pending() returns false.  If need_update() also returns true
at that point (per-cpu counters not yet zeroed mid-flush), the shepherd
queues a second invocation with delay=0, causing vmstat_update to run
again immediately after finishing.

On a 72-CPU system this race is readily observable: before the fix, many
CPUs show invocation gaps well below 500 jiffies (the minimum
round_jiffies_relative() can produce), with the most extreme cases
reaching 0 jiffies—vmstat_update called twice within the same jiffy.

Fix this by replacing delayed_work_pending() with work_busy(), which
returns non-zero for both WORK_BUSY_PENDING (timer armed or work queued)
and WORK_BUSY_RUNNING (work currently executing).  The shepherd now
correctly skips a CPU in all busy states.

After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.  The
remaining early invocations have gaps in the 700–999 jiffie range,
attributable to round_jiffies_relative() aligning to a nearer
jiffie-second boundary rather than to this race.

Each spurious vmstat_update invocation has a measurable side effect:
refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which drains
idle per-CPU pages back to the buddy allocator via free_pcppages_bulk(),
taking the zone spinlock each time.  Eliminating the double-scheduling
therefore reduces zone lock contention directly.  On a 72-CPU stress-ng
workload measured with perf lock contention:

  free_pcppages_bulk contention count:  ~55% reduction
  free_pcppages_bulk total wait time:   ~57% reduction
  free_pcppages_bulk max wait time:     ~47% reduction

Note: work_busy() is inherently racy—between the check and the
subsequent queue_delayed_work_on() call, vmstat_update can finish
execution, leaving the work neither pending nor running.  In that narrow
window the shepherd can still queue a second invocation.  After the fix,
this residual race is rare and produces only occasional small gaps, a
significant improvement over the systematic double-scheduling seen with
delayed_work_pending().

Link: https://lkml.kernel.org/r/20260409-vmstat-v2-1-e9d9a6db08ad@debian.org
Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update
+++ a/mm/vmstat.c
@@ -2139,7 +2139,7 @@ static void vmstat_shepherd(struct work_
 			if (cpu_is_isolated(cpu))
 				continue;
 
-			if (!delayed_work_pending(dw) && need_update(cpu))
+			if (!work_busy(&dw->work) && need_update(cpu))
 				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 		}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-kexec-metadata-track-previous-kernel-chain-fix.patch
kho-document-kexec-metadata-tracking-feature.patch
mm-vmstat-fix-vmstat_shepherd-double-scheduling-vmstat_update.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

