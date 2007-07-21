From: akpm@linux-foundation.org
Subject: + ip_auto_config-fix.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:38:47 -0700
Message-ID: <200707210038.l6L0cluU024617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071AbXGUAjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joakim.tjernlund@transmode.se, davem@davemloft.net, trond.myklebust@fys.uio.no


The patch titled
     ip_auto_config fix
has been added to the -mm tree.  Its filename is
     ip_auto_config-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ip_auto_config fix
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>

The following commandline:

 root=/dev/mtdblock6 rw rootfstype=jffs2 ip=192.168.1.10:::255.255.255.0:localhost.localdomain:eth1:off console=ttyS0,115200

makes ip_auto_config fall back to DHCP and complain "IP-Config: Incomplete
network configuration information." depending on if CONFIG_IP_PNP_DHCP is
set or not.

The only way I can make ip_auto_config accept my IP config is to add an
entry for the server IP:

ip=192.168.1.10:192.168.1.15::255.255.255.0:localhost.localdomain:eth1:off

I think this is a bug since I am not using a NFS root FS.

The following patch fixes the above problem.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipconfig.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN net/ipv4/ipconfig.c~ip_auto_config-fix net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~ip_auto_config-fix
+++ a/net/ipv4/ipconfig.c
@@ -1283,7 +1283,8 @@ static int __init ip_auto_config(void)
 #ifdef CONFIG_ROOT_NFS
 	    (MAJOR(ROOT_DEV) == UNNAMED_MAJOR
 	     && root_server_addr == NONE
-	     && ic_servaddr == NONE) ||
+	     && ic_servaddr == NONE
+	     && ROOT_DEV == Root_NFS) ||
 #endif
 	    ic_first_dev->next) {
 #ifdef IPCONFIG_DYNAMIC
_

Patches currently in -mm which might be from joakim.tjernlund@transmode.se are

origin.patch
ip_auto_config-fix.patch
ip_auto_config-fix-fix.patch
