From: akpm@linux-foundation.org
Subject: [folded] oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:59:11 -0800
Message-ID: <200912150059.nBF0xB6M023374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbZLOA7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix
has been removed from the -mm tree.  Its filename was
     oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch

This patch was dropped because it was folded into oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix
From: David Rientjes <rientjes@google.com>

fix race, add pid & comm to message

On Tue, 10 Nov 2009, akpm@linux-foundation.org wrote:

> diff -puN mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process mm/oom_kill.c
> --- a/mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process
> +++ a/mm/oom_kill.c
> @@ -352,6 +352,8 @@ static void dump_header(gfp_t gfp_mask,
>  		dump_tasks(mem);
>  }
>
> +#define K(x) ((x) << (PAGE_SHIFT-10))
> +
>  /*
>   * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
>   * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
> @@ -371,9 +373,16 @@ static void __oom_kill_task(struct task_
>  		return;
>  	}
>
> -	if (verbose)
> -		printk(KERN_ERR "Killed process %d (%s)\n",
> -				task_pid_nr(p), p->comm);
> +	if (verbose) {
> +		task_lock(p);
> +		printk(KERN_ERR "Killed process %d (%s) "
> +		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
> +		       task_pid_nr(p), p->comm,
> +		       K(p->mm->total_vm),
> +		       K(get_mm_counter(p->mm, anon_rss)),
> +		       K(get_mm_counter(p->mm, file_rss)));
> +		task_unlock(p);
> +	}
>
>  	/*
>  	 * We give our sacrificial lamb high priority and access to

There's a race there which can dereference a NULL p->mm.

p->mm is protected by task_lock(), but there's no check added here that
ensures p->mm is still valid.  The previous check for !p->mm in
__oom_kill_task() is not protected by task_lock(), so there's a race:

	select_bad_process()
	oom_kill_process(p)
					do_exit()
					exit_signals(p) /* PF_EXITING */
	oom_kill_task(p)
	__oom_kill_task(p)
					exit_mm(p)
					task_lock(p)
					p->mm = NULL
					task_unlock(p)
	printk() of p->mm->total_vm

Please merge this as a fix.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix
+++ a/mm/oom_kill.c
@@ -367,22 +367,23 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
+	task_lock(p);
 	if (!p->mm) {
 		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task!\n");
+		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
+			task_pid_nr(p), p->comm);
+		task_unlock(p);
 		return;
 	}
 
-	if (verbose) {
-		task_lock(p);
+	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s) "
 		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		       task_pid_nr(p), p->comm,
 		       K(p->mm->total_vm),
 		       K(get_mm_counter(p->mm, anon_rss)),
 		       K(get_mm_counter(p->mm, file_rss)));
-		task_unlock(p);
-	}
+	task_unlock(p);
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
mm-slab-allocate-memory-section-nodemask-for-large-systems.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

