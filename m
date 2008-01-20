From: akpm@linux-foundation.org
Subject: - revert-local_t-documentation-update.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:05:02 -0800
Message-ID: <200801200704.m0K74gvR007824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753917AbYATHFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Revert "local_t Documentation update"
has been removed from the -mm tree.  Its filename was
     revert-local_t-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Revert "local_t Documentation update"
From: Li Zefan <lizf@cn.fujitsu.com>

This reverts commit e1265205c0ee3919c3f2c750662630154c8faab2.

It's a duplicate commit of commit 74beb9db77930be476b267ec8518a642f39a04bf,
resulting in a duplicate section.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN Documentation/local_ops.txt~revert-local_t-documentation-update Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~revert-local_t-documentation-update
+++ a/Documentation/local_ops.txt
@@ -68,29 +68,6 @@ typedef struct { atomic_long_t a; } loca
   variable can be read when reading some _other_ cpu's variables.
 
 
-* Rules to follow when using local atomic operations
-
-- Variables touched by local ops must be per cpu variables.
-- _Only_ the CPU owner of these variables must write to them.
-- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
-  to update its local_t variables.
-- Preemption (or interrupts) must be disabled when using local ops in
-  process context to   make sure the process won't be migrated to a
-  different CPU between getting the per-cpu variable and doing the
-  actual local op.
-- When using local ops in interrupt context, no special care must be
-  taken on a mainline kernel, since they will run on the local CPU with
-  preemption already disabled. I suggest, however, to explicitly
-  disable preemption anyway to make sure it will still work correctly on
-  -rt kernels.
-- Reading the local cpu variable will provide the current copy of the
-  variable.
-- Reads of these variables can be done from any CPU, because updates to
-  "long", aligned, variables are always atomic. Since no memory
-  synchronization is done by the writer CPU, an outdated copy of the
-  variable can be read when reading some _other_ cpu's variables.
-
-
 * How to use local atomic operations
 
 #include <linux/percpu.h>
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-powerpc.patch
git-drm.patch
git-hid.patch
git-net.patch
git-netdev-all.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
