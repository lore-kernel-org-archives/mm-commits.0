From: akpm@linux-foundation.org
Subject: + net-myri10ge-force-select-inet_lro.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:33:37 -0700
Message-ID: <200709110533.l8B5Xb9h027496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283AbXIKFd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, brice@myri.com, davem@davemloft.net


The patch titled
     net: myri10ge: force select inet_lro
has been added to the -mm tree.  Its filename is
     net-myri10ge-force-select-inet_lro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: myri10ge: force select inet_lro
From: Daniel Walker <dwalker@mvista.com>

This driver uses the inet_lro facilities , but it doesn't force it to be
enabled ..  Someone would have to know to enable inet_lro if they select
the driver ..

Instead, just force INET_LRO if this driver is selected..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Brice Goglin <brice@myri.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/Kconfig~net-myri10ge-force-select-inet_lro drivers/net/Kconfig
--- a/drivers/net/Kconfig~net-myri10ge-force-select-inet_lro
+++ a/drivers/net/Kconfig
@@ -2084,6 +2084,7 @@ source "drivers/net/ixp2000/Kconfig"
 config MYRI_SBUS
 	tristate "MyriCOM Gigabit Ethernet support"
 	depends on SBUS
+	select INET_LRO
 	help
 	  This driver supports MyriCOM Sbus gigabit Ethernet cards.
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

net-myri10ge-force-select-inet_lro.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
