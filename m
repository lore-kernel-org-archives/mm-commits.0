From: akpm@linux-foundation.org
Subject: - config_inet-depend-on-config_sysctl.patch removed from -mm tree
Date: Tue, 12 Jun 2007 23:45:27 -0700
Message-ID: <200706130645.l5D6jRdB029278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbXFMGpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jun 2007 02:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     CONFIG_INET depend on CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     config_inet-depend-on-config_sysctl.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: CONFIG_INET depend on CONFIG_SYSCTL
From: Yoshinori Sato <ysato@users.sourceforge.jp>

It cannot build with CONFIG_SYSCTL=n and CONFIG_INET=y.  In case of
CONFIG_INET=y it should become CONFIG_SYSCTL=y.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN net/Kconfig~config_inet-depend-on-config_sysctl net/Kconfig
--- a/net/Kconfig~config_inet-depend-on-config_sysctl
+++ a/net/Kconfig
@@ -34,6 +34,7 @@ source "net/iucv/Kconfig"
 
 config INET
 	bool "TCP/IP networking"
+	select SYSCTL
 	---help---
 	  These are the protocols used on the Internet and on most local
 	  Ethernets. It is highly recommended to say Y here (this will enlarge
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
config_inet-depend-on-config_sysctl.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
h8300-zimage-support-update.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
