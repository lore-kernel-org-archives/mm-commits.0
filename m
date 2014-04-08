From: akpm@linux-foundation.org
Subject: [merged]
 modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:46:41 -0700
Message-ID: <53446e41.C9ixnSVuMJo84Pzd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbaDHVqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:46:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rusty@rustcorp.com.au, mingo@kernel.org, cl@linux.com

Subject: [merged] modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch removed from -mm tree
To: cl@linux.com,mingo@kernel.org,rusty@rustcorp.com.au,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:46:41 -0700


The patch titled
     Subject: modules: use raw_cpu_write for initialization of per cpu refcount.
has been removed from the -mm tree.  Its filename was
     modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: modules: use raw_cpu_write for initialization of per cpu refcount.

The initialization of a structure is not subject to synchronization.  The
use of __this_cpu would trigger a false positive with the additional
preemption checks for __this_cpu ops.

So simply disable the check through the use of raw_cpu ops.

Trace:

[    0.668066] __this_cpu_write operation in preemptible [00000000] code: modprobe/286
[    0.668108] caller is __this_cpu_preempt_check+0x38/0x60
[    0.668111] CPU: 3 PID: 286 Comm: modprobe Tainted: GF            3.12.0-rc4+ #187
[    0.668112] Hardware name: FUJITSU CELSIUS W530 Power/D3227-A1, BIOS V4.6.5.4 R1.10.0 for D3227-A1x 09/16/2013
[    0.668113]  0000000000000003 ffff8807edda1d18 ffffffff816d5a57 ffff8807edda1fd8
[    0.668117]  ffff8807edda1d48 ffffffff8137359c ffff8807edda1ef8 ffffffffa0002178
[    0.668121]  ffffc90000067730 ffff8807edda1e48 ffff8807edda1d88 ffffffff813735f8
[    0.668124] Call Trace:
[    0.668129]  [<ffffffff816d5a57>] dump_stack+0x4e/0x82
[    0.668132]  [<ffffffff8137359c>] check_preemption_disabled+0xec/0x110
[    0.668135]  [<ffffffff813735f8>] __this_cpu_preempt_check+0x38/0x60
[    0.668139]  [<ffffffff810c24fd>] load_module+0xcfd/0x2650
[    0.668143]  [<ffffffff816dd922>] ? page_fault+0x22/0x30
[    0.668146]  [<ffffffff810c3ef6>] SyS_init_module+0xa6/0xd0
[    0.668150]  [<ffffffff816e4fd3>] tracesys+0xe1/0xe6

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/module.c~modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount kernel/module.c
--- a/kernel/module.c~modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount
+++ a/kernel/module.c
@@ -640,7 +640,7 @@ static int module_unload_init(struct mod
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->incs, 1);
+	raw_cpu_write(mod->refptr->incs, 1);
 
 	return 0;
 }
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

