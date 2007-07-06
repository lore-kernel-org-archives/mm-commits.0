From: akpm@linux-foundation.org
Subject: - tun-tap-allow-group-ownership-of-tun-tap-devices.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:29 -0700
Message-ID: <200707060052.l660qTXG028376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761117AbXGFA4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agx@sigxcpu.org, jdike@addtoit.com, maxk@qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     tun/tap: allow group ownership of TUN/TAP devices
has been removed from the -mm tree.  Its filename was
     tun-tap-allow-group-ownership-of-tun-tap-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tun/tap: allow group ownership of TUN/TAP devices
From: Guido Guenther <agx@sigxcpu.org>

Jeff Dike <jdike@addtoit.com> says:

I received from Guido Guenther the patch below to the TUN/TAP driver
which allows group ownerships to be effective.

It seems reasonable to me.

Allow tun ownership by group.  We found this useful since we can then spawn
tapX devices on system boot (via /etc/network/interfaces) which logged on
users can then use for their virtual machines.

We introduced a new ioctl for the group setting.  The user now is allowed to
send packages if either his euid or his egid matches the one specified via
tunctl (via -u or -g respecitvely).  If both gid and uid are set via tunctl,
both have to match.

Acked-by: Max Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tun.c      |   15 +++++++++++++--
 include/linux/if_tun.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/net/tun.c~tun-tap-allow-group-ownership-of-tun-tap-devices drivers/net/tun.c
--- a/drivers/net/tun.c~tun-tap-allow-group-ownership-of-tun-tap-devices
+++ a/drivers/net/tun.c
@@ -432,6 +432,7 @@ static void tun_setup(struct net_device 
 	init_waitqueue_head(&tun->read_wait);
 
 	tun->owner = -1;
+	tun->group = -1;
 
 	SET_MODULE_OWNER(dev);
 	dev->open = tun_net_open;
@@ -467,8 +468,11 @@ static int tun_set_iff(struct file *file
 			return -EBUSY;
 
 		/* Check permissions */
-		if (tun->owner != -1 &&
-		    current->euid != tun->owner && !capable(CAP_NET_ADMIN))
+		if (((tun->owner != -1 &&
+		      current->euid != tun->owner) ||
+		     (tun->group != -1 &&
+		      current->egid != tun->group)) &&
+		     !capable(CAP_NET_ADMIN))
 			return -EPERM;
 	}
 	else if (__dev_get_by_name(ifr->ifr_name))
@@ -610,6 +614,13 @@ static int tun_chr_ioctl(struct inode *i
 		DBG(KERN_INFO "%s: owner set to %d\n", tun->dev->name, tun->owner);
 		break;
 
+	case TUNSETGROUP:
+		/* Set group of the device */
+		tun->group= (gid_t) arg;
+
+		DBG(KERN_INFO "%s: group set to %d\n", tun->dev->name, tun->group);
+		break;
+
 	case TUNSETLINK:
 		/* Only allow setting the type when the interface is down */
 		if (tun->dev->flags & IFF_UP) {
diff -puN include/linux/if_tun.h~tun-tap-allow-group-ownership-of-tun-tap-devices include/linux/if_tun.h
--- a/include/linux/if_tun.h~tun-tap-allow-group-ownership-of-tun-tap-devices
+++ a/include/linux/if_tun.h
@@ -36,6 +36,7 @@ struct tun_struct {
 	unsigned long 		flags;
 	int			attached;
 	uid_t			owner;
+	gid_t			group;
 
 	wait_queue_head_t	read_wait;
 	struct sk_buff_head	readq;
@@ -78,6 +79,7 @@ struct tun_struct {
 #define TUNSETPERSIST _IOW('T', 203, int) 
 #define TUNSETOWNER   _IOW('T', 204, int)
 #define TUNSETLINK    _IOW('T', 205, int)
+#define TUNSETGROUP   _IOW('T', 206, int)
 
 /* TUNSETIFF ifr flags */
 #define IFF_TUN		0x0001
_

Patches currently in -mm which might be from agx@sigxcpu.org are

git-net.patch
