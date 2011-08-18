From: akpm@linux-foundation.org
Subject: + sched-fix-a-memory-leak-in-__sdt_free.patch added to -mm tree
Date: Thu, 18 Aug 2011 14:18:09 -0700
Message-ID: <201108182118.p7ILI9BC028178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab1HRVSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, mingo@elte.hu, peterz@infradead.org, stable@kernel.org


The patch titled
     sched: fix a memory leak in __sdt_free()
has been added to the -mm tree.  Its filename is
     sched-fix-a-memory-leak-in-__sdt_free.patch

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
Subject: sched: fix a memory leak in __sdt_free()
From: WANG Cong <amwang@redhat.com>

Fix the following memory leak:

unreferenced object 0xffff880107266800 (size 512):
  comm "sched-powersave", pid 3718, jiffies 4323097853 (age 27495.450s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81133940>] create_object+0x187/0x28b
    [<ffffffff814ac103>] kmemleak_alloc+0x73/0x98
    [<ffffffff811232ba>] __kmalloc_node+0x104/0x159
    [<ffffffff81044b98>] kzalloc_node.clone.97+0x15/0x17
    [<ffffffff8104cb90>] build_sched_domains+0xb7/0x7f3
    [<ffffffff8104d4df>] partition_sched_domains+0x1db/0x24a
    [<ffffffff8109ee4a>] do_rebuild_sched_domains+0x3b/0x47
    [<ffffffff810a00c7>] rebuild_sched_domains+0x10/0x12
    [<ffffffff8104d5ba>] sched_power_savings_store+0x6c/0x7b
    [<ffffffff8104d5df>] sched_mc_power_savings_store+0x16/0x18
    [<ffffffff8131322c>] sysdev_class_store+0x20/0x22
    [<ffffffff81193876>] sysfs_write_file+0x108/0x144
    [<ffffffff81135b10>] vfs_write+0xaf/0x102
    [<ffffffff81135d23>] sys_write+0x4d/0x74
    [<ffffffff814c8a42>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sched.c~sched-fix-a-memory-leak-in-__sdt_free kernel/sched.c
--- a/kernel/sched.c~sched-fix-a-memory-leak-in-__sdt_free
+++ a/kernel/sched.c
@@ -7435,6 +7435,7 @@ static void __sdt_free(const struct cpum
 			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
 			if (sd && (sd->flags & SD_OVERLAP))
 				free_sched_groups(sd->groups, 0);
+			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch

