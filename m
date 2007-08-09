From: akpm@linux-foundation.org
Subject: + uml-add-vde-networking-support.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:17:43 -0700
Message-ID: <200708092017.l79KHhG7017454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764732AbXHIUSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, shammash@artha.org


The patch titled
     uml: add VDE networking support
has been added to the -mm tree.  Its filename is
     uml-add-vde-networking-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add VDE networking support
From: Jeff Dike <jdike@addtoit.com>

Added vde network backend in uml to introduce native Virtual Distributed
Ethernet support (using libvdeplug).

Signed-off-by: Luca Bigliardi <shammash@artha.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.net        |   22 +++++
 arch/um/drivers/Makefile   |   10 ++
 arch/um/drivers/vde.h      |   32 ++++++++
 arch/um/drivers/vde_kern.c |  136 +++++++++++++++++++++++++++++++++++
 arch/um/drivers/vde_user.c |  136 +++++++++++++++++++++++++++++++++++
 5 files changed, 334 insertions(+), 2 deletions(-)

diff -puN arch/um/Kconfig.net~uml-add-vde-networking-support arch/um/Kconfig.net
--- a/arch/um/Kconfig.net~uml-add-vde-networking-support
+++ a/arch/um/Kconfig.net
@@ -108,6 +108,28 @@ config UML_NET_DAEMON
         more than one without conflict.  If you don't need UML networking,
         say N.
 
+config UML_NET_VDE
+	bool "VDE transport"
+	depends on UML_NET
+	help
+	This User-Mode Linux network transport allows one or more running
+	UMLs on a single host to communicate with each other and also
+	with the rest of the world using Virtual Distributed Ethernet,
+	an improved fork of uml_switch.
+
+	You must have libvdeplug installed in order to build the vde
+	transport into UML.
+
+	To use this form of networking, you will need to run vde_switch
+	on the host.
+
+	For more information, see <http://wiki.virtualsquare.org/>
+	That site has a good overview of what VDE is and also examples
+	of the UML command line to use to enable VDE networking.
+
+	If you need UML networking with VDE,
+	say Y.
+
 config UML_NET_MCAST
 	bool "Multicast transport"
 	depends on UML_NET
diff -puN arch/um/drivers/Makefile~uml-add-vde-networking-support arch/um/drivers/Makefile
--- a/arch/um/drivers/Makefile~uml-add-vde-networking-support
+++ a/arch/um/drivers/Makefile
@@ -18,11 +18,16 @@ port-objs := port_kern.o port_user.o
 harddog-objs := harddog_kern.o harddog_user.o
 
 LDFLAGS_pcap.o := -r $(shell $(CC) $(CFLAGS) -print-file-name=libpcap.a)
+LDFLAGS_vde.o := -r $(shell $(CC) $(CFLAGS) -print-file-name=libvdeplug.a)
 
-targets := pcap_kern.o pcap_user.o
+targets := pcap_kern.o pcap_user.o vde_kern.o vde_user.o
 
 $(obj)/pcap.o: $(obj)/pcap_kern.o $(obj)/pcap_user.o
 	$(LD) -r -dp -o $@ $^ $(LDFLAGS) $(LDFLAGS_pcap.o)
+
+$(obj)/vde.o: $(obj)/vde_kern.o $(obj)/vde_user.o
+	$(LD) -r -dp -o $@ $^ $(LDFLAGS) $(LDFLAGS_vde.o)
+
 #XXX: The call below does not work because the flags are added before the
 # object name, so nothing from the library gets linked.
 #$(call if_changed,ld)
@@ -37,6 +42,7 @@ obj-$(CONFIG_STDERR_CONSOLE) += stderr_c
 obj-$(CONFIG_UML_NET_SLIP) += slip.o slip_common.o
 obj-$(CONFIG_UML_NET_SLIRP) += slirp.o slip_common.o
 obj-$(CONFIG_UML_NET_DAEMON) += daemon.o 
+obj-$(CONFIG_UML_NET_VDE) += vde.o
 obj-$(CONFIG_UML_NET_MCAST) += mcast.o 
 obj-$(CONFIG_UML_NET_PCAP) += pcap.o
 obj-$(CONFIG_UML_NET) += net.o 
@@ -54,6 +60,6 @@ obj-$(CONFIG_BLK_DEV_COW_COMMON) += cow_
 obj-$(CONFIG_UML_RANDOM) += random.o
 
 # pcap_user.o must be added explicitly.
-USER_OBJS := fd.o null.o pty.o tty.o xterm.o slip_common.o pcap_user.o
+USER_OBJS := fd.o null.o pty.o tty.o xterm.o slip_common.o pcap_user.o vde_user.o
 
 include arch/um/scripts/Makefile.rules
diff -puN /dev/null arch/um/drivers/vde.h
--- /dev/null
+++ a/arch/um/drivers/vde.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2007 Luca Bigliardi (shammash@artha.org).
+ * Licensed under the GPL.
+ */
+
+#ifndef __UM_VDE_H__
+#define __UM_VDE_H__
+
+struct vde_data {
+	char *vde_switch;
+	char *descr;
+	void *args;
+	void *conn;
+	void *dev;
+};
+
+struct vde_init {
+	char *vde_switch;
+	char *descr;
+	int port;
+	char *group;
+	int mode;
+};
+
+extern const struct net_user_info vde_user_info;
+
+extern void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init);
+
+extern int vde_user_read(void *conn, void *buf, int len);
+extern int vde_user_write(void *conn, void *buf, int len);
+
+#endif
diff -puN /dev/null arch/um/drivers/vde_kern.c
--- /dev/null
+++ a/arch/um/drivers/vde_kern.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (C) 2007 Luca Bigliardi (shammash@artha.org).
+ * Licensed under the GPL.
+ *
+ * Transport usage:
+ *  ethN=vde,<vde_switch>,<mac addr>,<port>,<group>,<mode>,<description>
+ *
+ */
+
+#include "linux/kernel.h"
+#include "linux/init.h"
+#include "linux/netdevice.h"
+#include "linux/etherdevice.h"
+#include "net_kern.h"
+#include "net_user.h"
+#include "vde.h"
+
+static void vde_init(struct net_device *dev, void *data)
+{
+	struct vde_init *init = data;
+	struct uml_net_private *pri;
+	struct vde_data *vpri;
+
+	pri = dev->priv;
+	vpri = (struct vde_data *) pri->user;
+
+	vpri->vde_switch = init->vde_switch;
+	vpri->descr = init->descr ? init->descr : "UML vde_transport";
+	vpri->args = NULL;
+	vpri->conn = NULL;
+	vpri->dev = dev;
+
+	printk(KERN_INFO "vde backend - %s, ", vpri->vde_switch ?
+	       vpri->vde_switch : "(default socket)");
+
+	vde_init_libstuff(vpri, init);
+
+	printk(KERN_INFO "\n");
+}
+
+static int vde_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+{
+	struct vde_data *pri = (struct vde_data *) &lp->user;
+
+	if (pri->conn != NULL) {
+		*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
+		if (*skb == NULL)
+			return -ENOMEM;
+
+		return vde_user_read(pri->conn, skb_mac_header(*skb),
+				     (*skb)->dev->mtu + ETH_HEADER_OTHER);
+	}
+
+	printk(KERN_ERR "vde_read - we have no VDECONN to read from");
+	return -EBADF;
+}
+
+static int vde_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+{
+	struct vde_data *pri = (struct vde_data *) &lp->user;
+
+	if (pri->conn != NULL)
+		return vde_user_write((void *)pri->conn, (*skb)->data,
+				      (*skb)->len);
+
+	printk(KERN_ERR "vde_write - we have no VDECONN to write to");
+	return -EBADF;
+}
+
+static const struct net_kern_info vde_kern_info = {
+	.init			= vde_init,
+	.protocol		= eth_protocol,
+	.read			= vde_read,
+	.write			= vde_write,
+};
+
+static int vde_setup(char *str, char **mac_out, void *data)
+{
+	struct vde_init *init = data;
+	char *remain, *port_str = NULL, *mode_str = NULL, *last;
+
+	*init = ((struct vde_init)
+		{ .vde_switch		= NULL,
+		  .descr		= NULL,
+		  .port			= 0,
+		  .group		= NULL,
+		  .mode			= 0 });
+
+	remain = split_if_spec(str, &init->vde_switch, mac_out, &port_str,
+				&init->group, &mode_str, &init->descr, NULL);
+
+	if (remain != NULL)
+		printk(KERN_WARNING "vde_setup - Ignoring extra data :"
+		       "'%s'\n", remain);
+
+	if (port_str != NULL) {
+		init->port = simple_strtoul(port_str, &last, 10);
+		if ((*last != '\0') || (last == port_str)) {
+			printk(KERN_ERR "vde_setup - Bad port : '%s'\n",
+						port_str);
+			return 0;
+		}
+	}
+
+	if (mode_str != NULL) {
+		init->mode = simple_strtoul(mode_str, &last, 8);
+		if ((*last != '\0') || (last == mode_str)) {
+			printk(KERN_ERR "vde_setup - Bad mode : '%s'\n",
+						mode_str);
+			return 0;
+		}
+	}
+
+	printk(KERN_INFO "Configured vde device: %s\n", init->vde_switch ?
+	       init->vde_switch : "(default socket)");
+
+	return 1;
+}
+
+static struct transport vde_transport = {
+	.list 		= LIST_HEAD_INIT(vde_transport.list),
+	.name 		= "vde",
+	.setup  	= vde_setup,
+	.user 		= &vde_user_info,
+	.kern 		= &vde_kern_info,
+	.private_size 	= sizeof(struct vde_data),
+	.setup_size 	= sizeof(struct vde_init),
+};
+
+static int register_vde(void)
+{
+	register_transport(&vde_transport);
+	return 0;
+}
+
+late_initcall(register_vde);
diff -puN /dev/null arch/um/drivers/vde_user.c
--- /dev/null
+++ a/arch/um/drivers/vde_user.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (C) 2007 Luca Bigliardi (shammash@artha.org).
+ * Licensed under the GPL.
+ */
+
+#include <errno.h>
+#include <unistd.h>
+#include <libvdeplug.h>
+#include "net_user.h"
+#include "kern_util.h"
+#include "kern_constants.h"
+#include "user.h"
+#include "os.h"
+#include "um_malloc.h"
+#include "vde.h"
+
+#define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
+
+static int vde_user_init(void *data, void *dev)
+{
+	struct vde_data *pri = data;
+	VDECONN *conn = NULL;
+	int err = -EINVAL;
+
+	pri->dev = dev;
+
+	conn = vde_open(pri->vde_switch, pri->descr, pri->args);
+
+	if (conn == NULL) {
+		err = -errno;
+		printk(UM_KERN_ERR "vde_user_init: vde_open failed, "
+		       "errno = %d\n", errno);
+		return err;
+	}
+
+	printk(UM_KERN_INFO "vde backend - connection opened\n");
+
+	pri->conn = conn;
+
+	return 0;
+}
+
+static int vde_user_open(void *data)
+{
+	struct vde_data *pri = data;
+
+	if (pri->conn != NULL)
+		return vde_datafd(pri->conn);
+
+	printk(UM_KERN_WARNING "vde_open - we have no VDECONN to open");
+	return -EINVAL;
+}
+
+static void vde_remove(void *data)
+{
+	struct vde_data *pri = data;
+
+	if (pri->conn != NULL) {
+		printk(UM_KERN_INFO "vde backend - closing connection\n");
+		vde_close(pri->conn);
+		pri->conn = NULL;
+		kfree(pri->args);
+		pri->args = NULL;
+		return;
+	}
+
+	printk(UM_KERN_WARNING "vde_remove - we have no VDECONN to remove");
+}
+
+static int vde_set_mtu(int mtu, void *data)
+{
+	return mtu;
+}
+
+const struct net_user_info vde_user_info = {
+	.init		= vde_user_init,
+	.open		= vde_user_open,
+	.close	 	= NULL,
+	.remove	 	= vde_remove,
+	.set_mtu	= vde_set_mtu,
+	.add_address	= NULL,
+	.delete_address = NULL,
+	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
+};
+
+void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
+{
+	struct vde_open_args *args;
+
+	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
+	if (vpri->args == NULL) {
+		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args"
+		       "allocation failed");
+		return;
+	}
+
+	args = vpri->args;
+
+	args->port = init->port;
+	args->group = init->group;
+	args->mode = init->mode ? init->mode : 0700;
+
+	args->port ?  printk(UM_KERN_INFO "port %d", args->port) :
+		printk(UM_KERN_INFO "undefined port");
+}
+
+int vde_user_read(void *conn, void *buf, int len)
+{
+	VDECONN *vconn = conn;
+	int rv;
+
+	if (vconn == NULL)
+		return 0;
+
+	rv = vde_recv(vconn, buf, len, 0);
+	if (rv < 0) {
+		if (errno == EAGAIN)
+			return 0;
+		return -errno;
+	}
+	else if (rv == 0)
+		return -ENOTCONN;
+
+	return rv;
+}
+
+int vde_user_write(void *conn, void *buf, int len)
+{
+	VDECONN *vconn = conn;
+
+	if (vconn == NULL)
+		return 0;
+
+	return vde_send(vconn, buf, len, 0);
+}
+
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
