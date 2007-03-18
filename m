From: akpm@linux-foundation.org
Subject: + fix-some-kallsyms_lookup-vs-rmmod-races.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:52:08 -0800
Message-ID: <200703180752.l2I7q8N4018415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXCRHwq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Fix some kallsyms_lookup() vs rmmod races
has been added to the -mm tree.  Its filename is
     fix-some-kallsyms_lookup-vs-rmmod-races.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix some kallsyms_lookup() vs rmmod races
From: Alexey Dobriyan <adobriyan@sw.ru>

kallsyms_lookup() can call module_address_lookup() which iterates over
modules list without module_mutex taken.  Comment at the top of
module_address_lookup() says it's for oops resolution so races are
irrelevant, but in some cases it's reachable from regular code:

BUG: unable to handle kernel paging request at virtual address f94fb19c
 printing eip:
c0138097
*pde = 33576067
Oops: 0000 [#1]
PREEMPT
Modules linked in: ohci_hcd af_packet e1000 ehci_hcd uhci_hcd usbcore
CPU:    0
EIP:    0060:[<c0138097>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-rc3-8b9909ded6922c33c221b105b26917780cfa497d #25)
EIP is at module_address_lookup+0x43/0x24c
eax: 00000000   ebx: 00000000   ecx: f94fb080   edx: f882e704
esi: 00000000   edi: 00000000   ebp: 00000000   esp: d30b8e78
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process cat (pid: 13274, ti=d30b8000 task=d2b50af0 task.ti=d30b8000)
Stack: d30b8f44 d30b8f48 00008001 00000000 c039a23c d30b8ec4 00000000 d30b8f44
       d30b8f48 c013876c d30b8f4c 00000000 cf544000 fffffff4 d38ebb7c c01880ff
       d30b8f4c d30b8ec4 00000246 c0399600 00000001 00000001 00000000 c0399654
Call Trace:
 [<c013876c>] kallsyms_lookup+0x5e/0x7c
 [<c01880ff>] proc_pid_wchan+0x38/0x76
 [<c01404fe>] __alloc_pages+0x4f/0x2f9
 [<c01891c6>] proc_info_read+0x6f/0xa8
 [<c015bbfd>] sys_fstat64+0x1e/0x23
 [<c01592d4>] vfs_read+0x7d/0xb5
 [<c0189157>] proc_info_read+0x0/0xa8
 [<c0159621>] sys_read+0x41/0x6a
 [<c0103e72>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 04 8b 51 04 0f 18 02 90 81 3d 4c 8d 39 c0 4c 8d 39 c0 74 3f 8b b9 18 01 00 00 8b 99 10 01 00 00 39 eb 77 07 8d 04 3b 39 c5 72 32 <8b> b1 1c 01 00 00 8b 81 14 01 00 00 39 c5 72 06 01 f0 39 c5 72
EIP: [<c0138097>] module_address_lookup+0x43/0x24c SS:ESP 0068:d30b8e78

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c            |    7 +++++++
 kernel/time/timer_list.c  |    6 ++++++
 kernel/time/timer_stats.c |    6 ++++++
 mm/slab.c                 |    3 +++
 4 files changed, 22 insertions(+)

diff -puN fs/proc/base.c~fix-some-kallsyms_lookup-vs-rmmod-races fs/proc/base.c
--- a/fs/proc/base.c~fix-some-kallsyms_lookup-vs-rmmod-races
+++ a/fs/proc/base.c
@@ -61,6 +61,7 @@
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/smp_lock.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
@@ -286,7 +287,13 @@ static int proc_pid_wchan(struct task_st
 
 	wchan = get_wchan(task);
 
+	module_mutex_lock();
 	sym_name = kallsyms_lookup(wchan, &size, &offset, &modname, namebuf);
+	/*
+	 * size, offset, modname aren't used, sym_name is copied into namebuf,
+	 * so drop it now.
+	 */
+	module_mutex_unlock();
 	if (sym_name)
 		return sprintf(buffer, "%s", sym_name);
 	return sprintf(buffer, "%lu", wchan);
diff -puN kernel/time/timer_list.c~fix-some-kallsyms_lookup-vs-rmmod-races kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~fix-some-kallsyms_lookup-vs-rmmod-races
+++ a/kernel/time/timer_list.c
@@ -44,7 +44,13 @@ static void print_name_offset(struct seq
 	const char *sym_name;
 	char *modname;
 
+	module_mutex_lock();
 	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	/*
+	 * size, offset, modname aren't used, sym_name is copied into namebuf,
+	 * so drop it now.
+	 */
+	module_mutex_unlock();
 	if (sym_name)
 		SEQ_printf(m, "%s", sym_name);
 	else
diff -puN kernel/time/timer_stats.c~fix-some-kallsyms_lookup-vs-rmmod-races kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~fix-some-kallsyms_lookup-vs-rmmod-races
+++ a/kernel/time/timer_stats.c
@@ -262,7 +262,13 @@ static void print_name_offset(struct seq
 	const char *sym_name;
 	char *modname;
 
+	module_mutex_lock();
 	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	/*
+	 * size, offset, modname aren't used, sym_name is copied into namebuf,
+	 * so drop it now.
+	 */
+	module_mutex_unlock();
 	if (sym_name)
 		seq_printf(m, "%s", sym_name);
 	else
diff -puN mm/slab.c~fix-some-kallsyms_lookup-vs-rmmod-races mm/slab.c
--- a/mm/slab.c~fix-some-kallsyms_lookup-vs-rmmod-races
+++ a/mm/slab.c
@@ -4440,14 +4440,17 @@ static void show_symbol(struct seq_file 
 	unsigned long offset, size;
 	char namebuf[KSYM_NAME_LEN+1];
 
+	module_mutex_lock();
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 
 	if (name) {
 		seq_printf(m, "%s+%#lx/%#lx", name, offset, size);
 		if (modname)
 			seq_printf(m, " [%s]", modname);
+		module_mutex_unlock();
 		return;
 	}
+	module_mutex_unlock();
 #endif
 	seq_printf(m, "%p", (void *)address);
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
race-between-cat-proc-kallsyms-and-rmmod.patch
fix-some-kallsyms_lookup-vs-rmmod-races.patch
fix-rmmod-read-write-races-in-proc-entries.patch
proc-oom_score-oops-re-badness.patch
