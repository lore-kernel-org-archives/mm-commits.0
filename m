From: akpm@linux-foundation.org
Subject: - docsrc-fix-ifenslave-type.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:26 -0700
Message-ID: <200808130853.m7D8rQwt008326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYHMJDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     docsrc: fix ifenslave type
has been removed from the -mm tree.  Its filename was
     docsrc-fix-ifenslave-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: fix ifenslave type
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/networking/ifenslave.c:1084: warning: pointer targets in assignment differ in signedness

From include/linux/socket.h:
 *	1003.1g requires sa_family_t and that sa_data is char.

and from SUSv3:
(http://www.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html)

The <sys/socket.h> header shall define the sockaddr structure that includes at least the following members:

sa_family_t  sa_family  Address family.
char         sa_data[]  Socket address (variable-length data).
<end SUSv3>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/ifenslave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/networking/ifenslave.c~docsrc-fix-ifenslave-type Documentation/networking/ifenslave.c
--- a/Documentation/networking/ifenslave.c~docsrc-fix-ifenslave-type
+++ a/Documentation/networking/ifenslave.c
@@ -1081,7 +1081,7 @@ static int set_if_addr(char *master_ifna
 
 		}
 
-		ipaddr = ifr.ifr_addr.sa_data;
+		ipaddr = (unsigned char *)ifr.ifr_addr.sa_data;
 		v_print("Interface '%s': set IP %s to %d.%d.%d.%d\n",
 			slave_ifname, ifra[i].desc,
 			ipaddr[0], ipaddr[1], ipaddr[2], ipaddr[3]);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

