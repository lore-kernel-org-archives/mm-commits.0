From: akpm@linux-foundation.org
Subject: [folded-merged] lib-bitmapc-enhance-bitmap-syntax-fix.patch
 removed from -mm tree
Date: Tue, 11 Oct 2016 13:36:01 -0700
Message-ID: <57fd4d31.6c35DKTBQ2dRe5W0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbcJKUgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben@decadent.org.uk, davem@davemloft.net, decot@googlers.com, noamca@mellanox.com, xinhui@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-bitmapc-enhance-bitmap-syntax-fix
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-enhance-bitmap-syntax-fix.patch

This patch was dropped because it was folded into lib-bitmapc-enhance-bitmap-syntax.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmapc-enhance-bitmap-syntax-fix

rework documentation

Cc: Noam Camus <noamca@mellanox.com>
Cc: David Decotigny <decot@googlers.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Pan Xinhui <xinhui@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   57 ++++++++++++++------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff -puN Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax-fix
+++ a/Documentation/kernel-parameters.txt
@@ -33,20 +33,36 @@ can also be entered as
 Double-quotes can be used to protect spaces in values, e.g.:
 	param="spaces in here"
 
-Some of the kernel parameters takes list of CPUs as value e.g.:
-isolcpus, task_isolation, nohz_full, irqaffinity, rcu_nocbs.
-The format of this list is:
-<cpu number>,...,<cpu number>
+cpu lists:
+----------
+
+Some kernel parameters take a list of CPUs as a value, e.g.  isolcpus,
+nohz_full, irqaffinity, rcu_nocbs.  The format of this list is:
+
+	<cpu number>,...,<cpu number>
+
 or
-<cpu number>-<cpu number>
-(must be a positive range in ascending order)
+
+	<cpu number>-<cpu number>
+	(must be a positive range in ascending order)
+
 or a mixture
+
 <cpu number>,...,<cpu number>-<cpu number>
-Note that for special case of range one can split range into equal size of groups
-and for each group to use some amount form the begin of that group.
-<cpu number>-cpu number>:<used size>/<group size>
-For example one can add to its command line following parameter:
-isolcpus=1,2,10-20,100-2000:2/25
+
+Note that for the special case of a range one can split the range into equal
+sized groups and for each group use some amount from the beginning of that
+group:
+
+	<cpu number>-cpu number>:<used size>/<group size>
+
+For example one can add to the command line following parameter:
+
+	isolcpus=1,2,10-20,100-2000:2/25
+
+where the final item represents CPUs 100,101,125,126,150,151,...
+
+
 
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
@@ -1799,13 +1815,7 @@ bytes respectively. Such letter suffixes
 			See Documentation/filesystems/nfs/nfsroot.txt.
 
 	irqaffinity=	[SMP] Set the default irq affinity mask
-			Format:
-			<cpu number>,...,<cpu number>
-			or
-			<cpu number>-<cpu number>
-			(must be a positive range in ascending order)
-			or a mixture
-			<cpu number>,...,<cpu number>-<cpu number>
+			The argument is a cpu list, as described above.
 
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
@@ -1822,13 +1832,7 @@ bytes respectively. Such letter suffixes
 			Format: <RDP>,<reset>,<pci_scan>,<verbosity>
 
 	isolcpus=	[KNL,SMP] Isolate CPUs from the general scheduler.
-			Format:
-			<cpu number>,...,<cpu number>
-			or
-			<cpu number>-<cpu number>
-			(must be a positive range in ascending order)
-			or a mixture
-			<cpu number>,...,<cpu number>-<cpu number>
+			The argument is a cpu list, as described above.
 
 			This option can be used to specify one or more CPUs
 			to isolate from the general SMP balancing and scheduling
@@ -2690,6 +2694,7 @@ bytes respectively. Such letter suffixes
 			Default: on
 
 	nohz_full=	[KNL,BOOT]
+			The argument is a cpu list, as described above.
 			In kernels built with CONFIG_NO_HZ_FULL=y, set
 			the specified list of CPUs whose tick will be stopped
 			whenever possible. The boot CPU will be forced outside
@@ -3295,6 +3300,8 @@ bytes respectively. Such letter suffixes
 			See Documentation/blockdev/ramdisk.txt.
 
 	rcu_nocbs=	[KNL]
+			The argument is a cpu list, as described above.
+
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-bitmapc-enhance-bitmap-syntax.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

