From: akpm@linux-foundation.org
Subject: - lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:02:55 -0800
Message-ID: <200703270602.l2R62t4N008897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41060 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965145AbXC0GDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     lguest: bridging support in example code
has been removed from the -mm tree.  Its filename was
     lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch

This patch was dropped because it was folded into lguest-documentatation-and-example-launcher.patch

------------------------------------------------------
Subject: lguest: bridging support in example code
From: Rusty Russell <rusty@rustcorp.com.au>

Expand the --tunnet option to take a bridge name as an argument, so that the
tap interface is added to the specified bridge.  This makes it convenient to
use bridging for connecting the guest to external networks.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c   |   57 +++++++++++++++++++++++-------
 Documentation/lguest/lguest.txt |   18 ++++++++-
 2 files changed, 62 insertions(+), 13 deletions(-)

diff -puN Documentation/lguest/lguest.c~lguest-documentatation-and-example-launcher-bridging-support-in-example-code Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-documentatation-and-example-launcher-bridging-support-in-example-code
+++ a/Documentation/lguest/lguest.c
@@ -23,7 +23,8 @@
 #include <sys/time.h>
 #include <time.h>
 #include <netinet/in.h>
-#include <linux/if.h>
+#include <net/if.h>
+#include <linux/sockios.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 #include <termios.h>
@@ -36,6 +37,7 @@ typedef uint8_t u8;
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
+#define BRIDGE_PFX "bridge:"
 
 static bool verbose;
 #define verbose(args...) \
@@ -582,20 +584,16 @@ static u32 handle_block_output(int fd, c
 	((u8)(ip >> 8)),			\
 	((u8)(ip))
 
-static void configure_device(const char *devname, u32 ipaddr,
+static void configure_device(int fd, const char *devname, u32 ipaddr,
 			     unsigned char hwaddr[6])
 {
 	struct ifreq ifr;
-	int fd;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&ifr.ifr_addr;
 
 	memset(&ifr, 0, sizeof(ifr));
 	strcpy(ifr.ifr_name, devname);
 	sin->sin_family = AF_INET;
 	sin->sin_addr.s_addr = htonl(ipaddr);
-	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
-	if (fd < 0)
-		err(1, "opening IP socket");
 	if (ioctl(fd, SIOCSIFADDR, &ifr) != 0)
 		err(1, "Setting %s interface address", devname);
 	ifr.ifr_flags = IFF_UP;
@@ -724,13 +722,34 @@ static u32 str2ip(const char *ipaddr)
 	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
 }
 
-static void setup_tun_net(const char *ipaddr,
+/* adapted from libbridge */
+static void add_to_bridge(int fd, const char *if_name, const char *br_name)
+{
+	int ifidx;
+	struct ifreq ifr;
+
+	if (!*br_name)
+		errx(1, "must specify bridge name");
+
+	ifidx = if_nametoindex(if_name);
+	if (!ifidx)
+		errx(1, "interface %s does not exist!", if_name);
+
+	strncpy(ifr.ifr_name, br_name, IFNAMSIZ);
+	ifr.ifr_ifindex = ifidx;
+	if (ioctl(fd, SIOCBRADDIF, &ifr) < 0)
+		err(1, "can't add %s to bridge %s", if_name, br_name);
+}
+
+static void setup_tun_net(const char *arg,
 			  struct lguest_device_desc *descs,
 			  struct devices *devices)
 {
 	struct device *dev;
 	struct ifreq ifr;
-	int netfd;
+	int netfd, ipfd;
+	u32 ipaddr;
+	const char *br_name = NULL;
 
 	netfd = open("/dev/net/tun", O_RDWR);
 	if (netfd < 0)
@@ -748,15 +767,29 @@ static void setup_tun_net(const char *ip
 	dev->priv = malloc(sizeof(bool));
 	*(bool *)dev->priv = false;
 
+	ipfd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
+	if (ipfd < 0)
+		err(1, "opening IP socket");
+
+	if (!strncmp(BRIDGE_PFX, arg, strlen(BRIDGE_PFX))) {
+		ipaddr = INADDR_ANY;
+		br_name = arg + strlen(BRIDGE_PFX);
+		add_to_bridge(ipfd, ifr.ifr_name, br_name);
+	} else
+		ipaddr = str2ip(arg);
+
 	/* We are peer 0, rest is all NO_GUEST */
 	memset(dev->mem, 0xFF, getpagesize());
-	configure_device(ifr.ifr_name, str2ip(ipaddr), dev->mem);
+	configure_device(ipfd, ifr.ifr_name, ipaddr, dev->mem);
+	close(ipfd);
 
 	/* You will be peer 1: we should create enough jitter to randomize */
 	dev->desc->features = NET_PEERNUM|LGUEST_DEVICE_F_RANDOMNESS;
 	verbose("device %p@%p: tun net %u.%u.%u.%u\n", dev->desc,
 		(void *)(dev->desc->pfn * getpagesize()),
-		HIPQUAD(str2ip(ipaddr)));
+		HIPQUAD(ipaddr));
+	if (br_name)
+		verbose("attched to bridge: %s\n", br_name);
 }
 
 static void setup_block_file(const char *filename,
@@ -887,8 +920,8 @@ int main(int argc, char *argv[])
 
 	if (argc < 4)
 		errx(1, "Usage: lguest [--verbose] <mem> vmlinux "
-			"[--sharenet=<filename>|--tunnet=<ipaddr>|--block=<filename>"
-			"|--initrd=<filename>]... [args...]");
+			"[--sharenet=<filename>|--tunnet=(<ipaddr>|bridge:<bridgename>)"
+			"|--block=<filename>|--initrd=<filename>]... [args...]");
 
 	zero_fd = open("/dev/zero", O_RDONLY, 0);
 	if (zero_fd < 0)
diff -puN Documentation/lguest/lguest.txt~lguest-documentatation-and-example-launcher-bridging-support-in-example-code Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt~lguest-documentatation-and-example-launcher-bridging-support-in-example-code
+++ a/Documentation/lguest/lguest.txt
@@ -77,11 +77,27 @@ Running Lguest:
   /proc/sys/net/ipv4/ip_forward".  In this example, I would configure
   eth0 inside the guest at 192.168.19.2.
 
+  Another method is to bridge the tap device to an external interface
+  using --tunnet=bridge:<bridgename>, and perhaps run dhcp on the guest
+  to obtain an IP address.  The bridge needs to be configured first:
+  this option simply adds the tap interface to it.
+
+  A simple example on my system:
+
+    ifconfig eth0 0.0.0.0
+    brctl addbr lg0
+    ifconfig lg0 up
+    dhclient lg0
+
+  Then use --tunnet=bridge:lg0 when launching the guest.
+
+  See http://linux-net.osdl.org/index.php/Bridge for general information
+  on how to get bridging working.
+
 - You can also create an inter-guest network using
   "--sharenet=<filename>": any two guests using the same file are on
   the same network.  This file is created if it does not exist.
 
-
 Lguest I/O model:
 
 Lguest uses a simplified DMA model plus shared memory for I/O.  Guests
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
cleanup-rationalize-paravirt-wrappers.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
