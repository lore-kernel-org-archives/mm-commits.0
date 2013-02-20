From: akpm@linux-foundation.org
Subject: + idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch added to -mm tree
Date: Wed, 20 Feb 2013 12:27:43 -0800
Message-ID: <20130220202745.1EACE5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45900 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3BTU1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 15:27:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so830699yhz.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 12:27:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, tj@kernel.org


The patch titled
     Subject: idr: always do slow path when hint is uninitialized
has been added to the -mm tree.  Its filename is
     idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: idr: always do slow path when hint is uninitialized

In case of PMU-less systems we have got the following traceback.

[    7.720687] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    7.727743] IP: [<c10ae57c>] perf_init_event+0x5e/0x150
[    7.732961] *pdpt = 0000000035257001 *pde = 0000000000000000
[    7.738700] Oops: 0000 [#1] PREEMPT SMP

Entering kdb (current=0xf6c58000, pid 1) on processor 1 Oops: (null)
due to oops @ 0xc10ae57c
dPid: 1, comm: init Not tainted 3.8.0-next-20130220-00036-gbceb0e3-dirty #57
dEIP: 0060:[<c10ae57c>] EFLAGS: 00010246 CPU: 1
EIP is at perf_init_event+0x5e/0x150
dEAX: 00000000 EBX: 00000000 ECX: c17efaa4 EDX: 00000005
dESI: f52e44b0 EDI: 00000005 EBP: f6c61df8 ESP: f6c61de4
d DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
dCR0: 8005003b CR2: 00000000 CR3: 35256000 CR4: 000007f0
dDR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
dDR6: ffff0ff0 DR7: 00000400
0Process init (pid: 1, ti=f6c60000 task=f6c58000 task.ti=f6c60000)
0Stack:
 00000000 c104762b 00000001 f52e45f8 f52e4588 f6c61e24 c10ae8df f6c58405
 00000006 00000007 f6c58000 f6c61e84 f52e44b0 00000000 c18aed5c 00000000
 f6c61e4c c10aec35 f52e44b0 00000000 00000000 00000000 00000000 00000000
0Call Trace:
0 [<c104762b>] ? __mutex_init+0x3f/0x44
0 [<c10ae8df>] perf_event_alloc+0x271/0x39a
0 [<c10aec35>] perf_event_create_kernel_counter+0x1a/0xb3
0 [<c10b02d7>] register_wide_hw_breakpoint+0x56/0xd9
0 [<c101f20e>] kgdb_arch_late+0x7a/0x112
0 [<c101eaca>] ? kgdb_set_hw_break+0x15e/0x15e
0 [<c1086f13>] kgdb_register_io_module+0x9b/0x121
0 [<c12c4b50>] configure_kgdboc+0xf1/0x126
0 [<c12c4c0f>] param_set_kgdboc_var+0x8a/0x8f
0 [<c10434b0>] param_attr_store+0x2a/0x47
0 [<c1043486>] ? __kernel_param_lock+0x11/0x11
0 [<c10433c7>] module_attr_store+0x17/0x26
0 [<c112dfc9>] sysfs_write_file+0xab/0xe6
0 [<c112df1e>] ? sysfs_chmod_file+0x82/0x82
0 [<c10e1834>] vfs_write+0x66/0xa7
0 [<c10e19b0>] sys_write+0x37/0x60
0 [<c1547741>] sysenter_do_call+0x12/0x32
0Code: ff ff 8b 7e 78 8b 1d 94 12 e5 c1 e8 5c 49 f9 ff 83 c4 0c 85 c0 74 0e 80 3d 28 05 84 c1 00 75 05 e8 99 9c ff ff 89 f8 89 fa 30 c0 <3b> 03 75 26 81 e2 ff 00 00 00 83 c2 08 8b 5c 93 04 e8 2b 49 f9

The guilty commit is cc5b5f6 "events: convert to idr_alloc()" together with
f49318a "idr: implement lookup hint". In our case the idr_alloc is never
called, but idr_find is. The hint field is never initialized and therefore
should not be dereferenced.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 +-
 lib/idr.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/idr.h~idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized include/linux/idr.h
--- a/include/linux/idr.h~idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized
+++ a/include/linux/idr.h
@@ -113,7 +113,7 @@ static inline void *idr_find(struct idr 
 {
 	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
 
-	if ((id & ~IDR_MASK) == hint->prefix)
+	if (hint && (id & ~IDR_MASK) == hint->prefix)
 		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
 
 	return idr_find_slowpath(idr, id);
diff -puN lib/idr.c~idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized lib/idr.c
--- a/lib/idr.c~idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized
+++ a/lib/idr.c
@@ -139,7 +139,7 @@ static void idr_layer_rcu_free(struct rc
 
 static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
-	if (idr->hint == p)
+	if (idr->hint && idr->hint == p)
 		RCU_INIT_POINTER(idr->hint, NULL);
 	call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types.patch
drivers-rtc-dump-small-buffers-via-%ph.patch
idr-implement-lookup-hint-always-do-slow-path-when-hint-is-uninitialized.patch

