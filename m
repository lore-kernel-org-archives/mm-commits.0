From: akpm@linux-foundation.org
Subject: + config_inet-depend-on-config_sysctl.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:54 -0700
Message-ID: <200706122023.l5CKNsTq020551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753149AbXFLU3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp, davem@davemloft.net


The patch titled
     CONFIG_INET depend on CONFIG_SYSCTL
has been added to the -mm tree.  Its filename is
     config_inet-depend-on-config_sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
h8300-enable-arbitary-speed-tty-port-setup.patch
h8300-zimage-support-update.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
config_inet-depend-on-config_sysctl.patch
