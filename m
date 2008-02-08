From: akpm@linux-foundation.org
Subject: - mark-net_ns-with-depends-on-namespaces.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:45 -0800
Message-ID: <200802082011.m18KBQQd010116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYBHVPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, clg@fr.ibm.com, davem@davemloft.net, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: mark NET_NS with "depends on NAMESPACES"
has been removed from the -mm tree.  Its filename was
     mark-net_ns-with-depends-on-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: mark NET_NS with "depends on NAMESPACES"
From: Pavel Emelyanov <xemul@openvz.org>

There's already an option controlling the net namespaces cloning code, so make
it work the same way as all the other namespaces' options.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/Kconfig~mark-net_ns-with-depends-on-namespaces net/Kconfig
--- a/net/Kconfig~mark-net_ns-with-depends-on-namespaces
+++ a/net/Kconfig
@@ -30,7 +30,7 @@ menu "Networking options"
 config NET_NS
 	bool "Network namespace support"
 	default n
-	depends on EXPERIMENTAL && !SYSFS
+	depends on EXPERIMENTAL && !SYSFS && NAMESPACES
 	help
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
