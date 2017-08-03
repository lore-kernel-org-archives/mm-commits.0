From: akpm@linux-foundation.org
Subject: +
 mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch added to -mm tree
Date: Thu, 03 Aug 2017 15:44:24 -0700
Message-ID: <5983a748.iO9mTEQw3IuOXJWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdHCWoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 18:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, wenwei.tww@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix potential data corruption when oom_reaper races with writer
has been added to the -mm tree.  Its filename is
     mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: fix potential data corruption when oom_reaper races with writer

Wenwei Tao has noticed that our current assumption that the oom victim is
dying and never doing any visible changes after it dies is not entirely
true.  __task_will_free_mem consider a task dying when SIGNAL_GROUP_EXIT
is set but do_group_exit sends SIGKILL to all threads _after_ the flag is
set.  So there is a race window when some threads won't have
fatal_signal_pending while the oom_reaper could start unmapping the
address space.  generic_perform_write could then write zero page to the
page cache and corrupt data.

The race window is rather small and close to impossible to happen but it
would be better to have it covered.

Fix this by extending the existing MMF_UNSTABLE check in handle_mm_fault
and segfault on any page fault after the oom reaper started its work. 
This means that nobody will ever observe a potentially corrupted content. 
Formerly we cared only about use_mm users because those can outlive the
oom victim quite easily but having the process itself protected sounds
like a reasonable thing to do as well.

There doesn't seem to be any real life bug report so this is merely a fix
of a theoretical bug.

Link: http://lkml.kernel.org/r/20170803135902.31977-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer mm/memory.c
--- a/mm/memory.c~mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer
+++ a/mm/memory.c
@@ -3958,13 +3958,9 @@ int handle_mm_fault(struct vm_area_struc
 	/*
 	 * This mm has been already reaped by the oom reaper and so the
 	 * refault cannot be trusted in general. Anonymous refaults would
-	 * lose data and give a zero page instead e.g. This is especially
-	 * problem for use_mm() because regular tasks will just die and
-	 * the corrupted data will not be visible anywhere while kthread
-	 * will outlive the oom victim and potentially propagate the date
-	 * further.
+	 * lose data and give a zero page instead e.g.
 	 */
-	if (unlikely((current->flags & PF_KTHREAD) && !(ret & VM_FAULT_ERROR)
+	if (unlikely(!(ret & VM_FAULT_ERROR)
 				&& test_bit(MMF_UNSTABLE, &vma->vm_mm->flags)))
 		ret = VM_FAULT_SIGBUS;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
treewide-remove-gfp_temporary-allocation-flag.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch
fs-proc-remove-priv-argument-from-is_stack.patch

