From: akpm@linux-foundation.org
Subject: + oom-move-sysctl-declarations-to-oomh.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:00:40 -0700
Message-ID: <201003312100.o2VL0eZ5008236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758146Ab0CaVFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     oom: move sysctl declarations to oom.h
has been added to the -mm tree.  Its filename is
     oom-move-sysctl-declarations-to-oomh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: move sysctl declarations to oom.h
From: David Rientjes <rientjes@google.com>

The three oom killer sysctl variables (sysctl_panic_on_oom,
sysctl_oom_forkbomb_thres, and sysctl_oom_kill_quick) are better declared
in include/linux/oom.h rather than kernel/sysctl.c.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    6 ++++++
 kernel/sysctl.c     |    4 +---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/oom.h~oom-move-sysctl-declarations-to-oomh include/linux/oom.h
--- a/include/linux/oom.h~oom-move-sysctl-declarations-to-oomh
+++ a/include/linux/oom.h
@@ -61,5 +61,11 @@ static inline void oom_killer_enable(voi
 {
 	oom_killer_disabled = false;
 }
+
+/* sysctls */
+extern int sysctl_panic_on_oom;
+extern int sysctl_oom_forkbomb_thres;
+extern int sysctl_oom_kill_quick;
+
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff -puN kernel/sysctl.c~oom-move-sysctl-declarations-to-oomh kernel/sysctl.c
--- a/kernel/sysctl.c~oom-move-sysctl-declarations-to-oomh
+++ a/kernel/sysctl.c
@@ -53,6 +53,7 @@
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -81,9 +82,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_quick;
-extern int sysctl_oom_forkbomb_thres;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
oom-move-sysctl-declarations-to-oomh.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

