From: akpm@linux-foundation.org
Subject: + oom-improve-oom-disable-handling.patch added to -mm tree
Date: Tue, 04 Apr 2017 13:07:41 -0700
Message-ID: <58e3fd0d.xLPqmLznVX+r33BA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754584AbdDDUHm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2017 16:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: improve oom disable handling
has been added to the -mm tree.  Its filename is
     oom-improve-oom-disable-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-improve-oom-disable-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-improve-oom-disable-handling.patch

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
Subject: oom: improve oom disable handling

Tetsuo has reported that sysrq triggered OOM killer will print a
misleading information when no tasks are selected:

[  713.805315] sysrq: SysRq : Manual OOM execution
[  713.808920] Out of memory: Kill process 4468 ((agetty)) score 0 or sacrifice child
[  713.814913] Killed process 4468 ((agetty)) total-vm:43704kB, anon-rss:1760kB, file-rss:0kB, shmem-rss:0kB
[  714.004805] sysrq: SysRq : Manual OOM execution
[  714.005936] Out of memory: Kill process 4469 (systemd-cgroups) score 0 or sacrifice child
[  714.008117] Killed process 4469 (systemd-cgroups) total-vm:10704kB, anon-rss:120kB, file-rss:0kB, shmem-rss:0kB
[  714.189310] sysrq: SysRq : Manual OOM execution
[  714.193425] sysrq: OOM request ignored because killer is disabled
[  714.381313] sysrq: SysRq : Manual OOM execution
[  714.385158] sysrq: OOM request ignored because killer is disabled
[  714.573320] sysrq: SysRq : Manual OOM execution
[  714.576988] sysrq: OOM request ignored because killer is disabled

The real reason is that there are no eligible tasks for the OOM killer to
select but since 7c5f64f84483bd13 ("mm: oom: deduplicate victim selection
code for memcg and global oom") the semantic of out_of_memory has changed
without updating moom_callback.

This patch updates moom_callback to tell that no task was eligible which
is the case for both oom killer disabled and no eligible tasks.  In order
to help distinguish first case from the second add printk to both
oom_killer_{enable,disable}.  This information is useful on its own
because it might help debugging potential memory allocation failures.

Fixes: 7c5f64f84483bd13 ("mm: oom: deduplicate victim selection code for memcg and global oom")
Link: http://lkml.kernel.org/r/20170404134705.6361-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    2 +-
 mm/oom_kill.c       |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/tty/sysrq.c~oom-improve-oom-disable-handling drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~oom-improve-oom-disable-handling
+++ a/drivers/tty/sysrq.c
@@ -372,7 +372,7 @@ static void moom_callback(struct work_st
 
 	mutex_lock(&oom_lock);
 	if (!out_of_memory(&oc))
-		pr_info("OOM request ignored because killer is disabled\n");
+		pr_info("OOM request ignored. No task eligible\n");
 	mutex_unlock(&oom_lock);
 }
 
diff -puN mm/oom_kill.c~oom-improve-oom-disable-handling mm/oom_kill.c
--- a/mm/oom_kill.c~oom-improve-oom-disable-handling
+++ a/mm/oom_kill.c
@@ -685,6 +685,7 @@ void exit_oom_victim(void)
 void oom_killer_enable(void)
 {
 	oom_killer_disabled = false;
+	pr_info("OOM killer enabled.\n");
 }
 
 /**
@@ -721,6 +722,7 @@ bool oom_killer_disable(signed long time
 		oom_killer_enable();
 		return false;
 	}
+	pr_info("OOM killer disabled.\n");
 
 	return true;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-move-pcp-and-lru-pcp-drainging-into-single-wq.patch
oom-improve-oom-disable-handling.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch

