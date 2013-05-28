From: akpm@linux-foundation.org
Subject: + misdn-add-support-for-group-membership-check.patch added to -mm tree
Date: Tue, 28 May 2013 16:13:27 -0700
Message-ID: <51a53a17.TasF8NSyz8MroRLm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab3E1XN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergei.shtylyov@cogentembedded.com, jslaby@suse.cz, isdn@linux-pingi.de, isdn4linux@koppen.de, davem@davemloft.net, jeffm@suse.com

Subject: + misdn-add-support-for-group-membership-check.patch added to -mm tree
To: jeffm@suse.com,davem@davemloft.net,isdn4linux@koppen.de,isdn@linux-pingi.de,jslaby@suse.cz,sergei.shtylyov@cogentembedded.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:13:27 -0700


The patch titled
     Subject: mISDN: add support for group membership check
has been added to the -mm tree.  Its filename is
     misdn-add-support-for-group-membership-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: mISDN: add support for group membership check

This patch adds a module parameter to allow a group access to the mISDN
devices.  Otherwise, unpriviledged users on systems with ISDN hardware
have the ability to dial out, potentially causing expensive bills.

Based on a different implementation by Patrick Koppen.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Cc: Patrick Koppen <isdn4linux@koppen.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/core.c   |    6 ++++++
 drivers/isdn/mISDN/core.h   |    1 +
 drivers/isdn/mISDN/socket.c |    9 +++++++++
 3 files changed, 16 insertions(+)

diff -puN drivers/isdn/mISDN/core.c~misdn-add-support-for-group-membership-check drivers/isdn/mISDN/core.c
--- a/drivers/isdn/mISDN/core.c~misdn-add-support-for-group-membership-check
+++ a/drivers/isdn/mISDN/core.c
@@ -21,10 +21,14 @@
 #include "core.h"
 
 static u_int debug;
+static u_int gid;
+kgid_t misdn_permitted_gid;
 
 MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL");
 module_param(debug, uint, S_IRUGO | S_IWUSR);
+module_param(gid, uint, 0);
+MODULE_PARM_DESC(gid, "Unix group for accessing misdn socket (default 0)");
 
 static u64		device_ids;
 #define MAX_DEVICE_ID	63
@@ -372,6 +376,8 @@ mISDNInit(void)
 {
 	int	err;
 
+	misdn_permitted_gid = make_kgid(current_user_ns(), gid);
+
 	printk(KERN_INFO "Modular ISDN core version %d.%d.%d\n",
 	       MISDN_MAJOR_VERSION, MISDN_MINOR_VERSION, MISDN_RELEASE);
 	mISDN_init_clock(&debug);
diff -puN drivers/isdn/mISDN/core.h~misdn-add-support-for-group-membership-check drivers/isdn/mISDN/core.h
--- a/drivers/isdn/mISDN/core.h~misdn-add-support-for-group-membership-check
+++ a/drivers/isdn/mISDN/core.h
@@ -17,6 +17,7 @@
 
 extern struct mISDNdevice	*get_mdevice(u_int);
 extern int			get_mdevice_count(void);
+extern kgid_t misdn_permitted_gid;
 
 /* stack status flag */
 #define mISDN_STACK_ACTION_MASK		0x0000ffff
diff -puN drivers/isdn/mISDN/socket.c~misdn-add-support-for-group-membership-check drivers/isdn/mISDN/socket.c
--- a/drivers/isdn/mISDN/socket.c~misdn-add-support-for-group-membership-check
+++ a/drivers/isdn/mISDN/socket.c
@@ -612,6 +612,11 @@ data_sock_create(struct net *net, struct
 {
 	struct sock *sk;
 
+	if (!capable(CAP_SYS_ADMIN) &&
+			!gid_eq(misdn_permitted_gid, current_gid()) &&
+			!in_group_p(misdn_permitted_gid))
+		return -EPERM;
+
 	if (sock->type != SOCK_DGRAM)
 		return -ESOCKTNOSUPPORT;
 
@@ -694,6 +699,10 @@ base_sock_ioctl(struct socket *sock, uns
 	case IMSETDEVNAME:
 	{
 		struct mISDN_devrename dn;
+		if (!capable(CAP_SYS_ADMIN) &&
+				!gid_eq(misdn_permitted_gid, current_gid()) &&
+				!in_group_p(misdn_permitted_gid))
+			return -EPERM;
 		if (copy_from_user(&dn, (void __user *)arg,
 				   sizeof(dn))) {
 			err = -EFAULT;
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch
misdn-add-support-for-group-membership-check.patch
reiserfs-fix-deadlock-with-nfs-racing-on-create-lookup.patch

