From: akpm@linux-foundation.org
Subject: [merged] proc-warn-on-non-existing-proc-entries.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:34 -0800
Message-ID: <201003091909.o29J9YQs031533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab0CITK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: warn on non-existing proc entries
has been removed from the -mm tree.  Its filename was
     proc-warn-on-non-existing-proc-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: warn on non-existing proc entries
From: Alexey Dobriyan <adobriyan@gmail.com>

* warn if creation goes on to non-existent directory
* warn if removal goes on from non-existing directory
* warn if non-existing proc entry is removed

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-warn-on-non-existing-proc-entries fs/proc/generic.c
--- a/fs/proc/generic.c~proc-warn-on-non-existing-proc-entries
+++ a/fs/proc/generic.c
@@ -312,8 +312,10 @@ static int __xlate_proc_name(const char 
 			if (proc_match(len, cp, de))
 				break;
 		}
-		if (!de)
+		if (!de) {
+			WARN(1, "name '%s'\n", name);
 			return -ENOENT;
+		}
 		cp += len + 1;
 	}
 	*residual = cp;
@@ -818,8 +820,10 @@ void remove_proc_entry(const char *name,
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
-	if (!de)
+	if (!de) {
+		WARN(1, "name '%s'\n", name);
 		return;
+	}
 
 	spin_lock(&de->pde_unload_lock);
 	/*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mpt-fusion-convert-to-seq_file.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-extern-cleanup-binfmts.patch
nsproxy-remove-init_nsproxy.patch

