From: akpm@linux-foundation.org
Subject: - ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:04 -0700
Message-ID: <200805021944.m42Ji4w8011349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932941AbYEBTor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com, yoshfuji@linux-ipv6.org, mm-commits@vger.kernel.org


The patch titled
     ipv6: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipv6: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/proc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN net/ipv6/proc.c~ipv6-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv6/proc.c
--- a/net/ipv6/proc.c~ipv6-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv6/proc.c
@@ -247,13 +247,11 @@ int snmp6_register_dev(struct inet6_dev 
 	if (!proc_net_devsnmp6)
 		return -ENOENT;
 
-	p = proc_create(idev->dev->name, S_IRUGO,
-			proc_net_devsnmp6, &snmp6_seq_fops);
+	p = proc_create_data(idev->dev->name, S_IRUGO,
+			     proc_net_devsnmp6, &snmp6_seq_fops, idev);
 	if (!p)
 		return -ENOMEM;
 
-	p->data = idev;
