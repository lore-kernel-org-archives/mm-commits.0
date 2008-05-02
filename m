From: akpm@linux-foundation.org
Subject: - vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:10 -0700
Message-ID: <200805021944.m42JiACF011356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbYEBTon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com, greearb@candelatech.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     vlan: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vlan: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Cc: Ben Greear <greearb@candelatech.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/8021q/vlanproc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN net/8021q/vlanproc.c~vlan-assign-pde-data-before-gluing-pde-into-proc-tree net/8021q/vlanproc.c
--- a/net/8021q/vlanproc.c~vlan-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/8021q/vlanproc.c
@@ -176,12 +176,11 @@ int vlan_proc_add_dev(struct net_device 
 	struct vlan_dev_info *dev_info = vlan_dev_info(vlandev);
 	struct vlan_net *vn = net_generic(dev_net(vlandev), vlan_net_id);
 
-	dev_info->dent = proc_create(vlandev->name, S_IFREG|S_IRUSR|S_IWUSR,
-				     vn->proc_vlan_dir, &vlandev_fops);
+	dev_info->dent =
+		proc_create_data(vlandev->name, S_IFREG|S_IRUSR|S_IWUSR,
+				 vn->proc_vlan_dir, &vlandev_fops, vlandev);
 	if (!dev_info->dent)
 		return -ENOBUFS;
