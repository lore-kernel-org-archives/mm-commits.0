From: akpm@linux-foundation.org
Subject: +
 kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch added to -mm tree
Date: Tue, 08 Oct 2013 13:51:16 -0700
Message-ID: <52547044.apnfi6wlhDvPUKqV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3JHUvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 16:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 13:51:16 -0700


The patch titled
     Subject: kernel/taskstats.c: return -ENOMEM when alloc memory fails in add_del_listener()
has been added to the -mm tree.  Its filename is
     kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/taskstats.c: return -ENOMEM when alloc memory fails in add_del_listener()

For registering in add_del_listener(), when kmalloc_node() fails, need
return -ENOMEM instead of success code, and cmd_attr_register_cpumask()
wants to know about it.

After modification, give a simple common test "build -> boot up ->
kernel/controllers/cgroup/getdelays by LTP tools".

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/taskstats.c~kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener kernel/taskstats.c
--- a/kernel/taskstats.c~kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener
+++ a/kernel/taskstats.c
@@ -290,6 +290,7 @@ static int add_del_listener(pid_t pid, c
 	struct listener_list *listeners;
 	struct listener *s, *tmp, *s2;
 	unsigned int cpu;
+	int ret = 0;
 
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
@@ -304,9 +305,10 @@ static int add_del_listener(pid_t pid, c
 		for_each_cpu(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener),
 					GFP_KERNEL, cpu_to_node(cpu));
-			if (!s)
+			if (!s) {
+				ret = -ENOMEM;
 				goto cleanup;
-
+			}
 			s->pid = pid;
 			s->valid = 1;
 
@@ -339,7 +341,7 @@ cleanup:
 		}
 		up_write(&listeners->sem);
 	}
-	return 0;
+	return ret;
 }
 
 static int parse(struct nlattr *na, struct cpumask *mask)
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch

