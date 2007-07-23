From: akpm@linux-foundation.org
Subject: + resend-link-lguest-example-launcher-non-static.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:30:30 -0700
Message-ID: <200707232130.l6NLUUqS012790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbXGWVak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     resend: link lguest example launcher non-static
has been added to the -mm tree.  Its filename is
     resend-link-lguest-example-launcher-non-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: resend: link lguest example launcher non-static
From: Rusty Russell <rusty@rustcorp.com.au>

S.Caglar Onur points out that many distributions don't ship a static
zlib.  Unfortunately the launcher currently maps virtual device memory
where shared libraries want to go.

The solution is to pre-scan the args to figure out how much memory we
have, then allocate devices above that, rather than down from the top
possible address.  This also turns out to be simpler.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/Makefile |    3 -
 Documentation/lguest/lguest.c |   84 ++++++++++++--------------------
 2 files changed, 35 insertions(+), 52 deletions(-)

diff -puN Documentation/lguest/Makefile~resend-link-lguest-example-launcher-non-static Documentation/lguest/Makefile
--- a/Documentation/lguest/Makefile~resend-link-lguest-example-launcher-non-static
+++ a/Documentation/lguest/Makefile
@@ -11,8 +11,7 @@ endif
 include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
-CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
-	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
+CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -Wl,-T,lguest.lds
 LDLIBS:=-lz
 
 all: lguest.lds lguest
diff -puN Documentation/lguest/lguest.c~resend-link-lguest-example-launcher-non-static Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~resend-link-lguest-example-launcher-non-static
+++ a/Documentation/lguest/lguest.c
@@ -47,12 +47,14 @@ static bool verbose;
 #define verbose(args...) \
 	do { if (verbose) printf(args); } while(0)
 static int waker_fd;
+static u32 top;
 
 struct device_list
 {
 	fd_set infds;
 	int max_infd;
 
+	struct lguest_device_desc *descs;
 	struct device *dev;
 	struct device **lastdev;
 };
@@ -324,8 +326,7 @@ static void concat(char *dst, char *args
 static int tell_kernel(u32 pgdir, u32 start, u32 page_offset)
 {
 	u32 args[] = { LHREQ_INITIALIZE,
-		       LGUEST_GUEST_TOP/getpagesize(), /* Just below us */
-		       pgdir, start, page_offset };
+		       top/getpagesize(), pgdir, start, page_offset };
 	int fd;
 
 	fd = open_or_die("/dev/lguest", O_RDWR);
@@ -382,7 +383,7 @@ static int setup_waker(int lguest_fd, st
 static void *_check_pointer(unsigned long addr, unsigned int size,
 			    unsigned int line)
 {
-	if (addr >= LGUEST_GUEST_TOP || addr + size >= LGUEST_GUEST_TOP)
+	if (addr >= top || addr + size >= top)
 		errx(1, "%s:%i: Invalid address %li", __FILE__, line, addr);
 	return (void *)addr;
 }
@@ -629,24 +630,26 @@ static void handle_input(int fd, struct 
 	}
 }
 
-static struct lguest_device_desc *new_dev_desc(u16 type, u16 features,
-					       u16 num_pages)
+static struct lguest_device_desc *
+new_dev_desc(struct lguest_device_desc *descs,
+	     u16 type, u16 features, u16 num_pages)
 {
-	static unsigned long top = LGUEST_GUEST_TOP;
-	struct lguest_device_desc *desc;
+	unsigned int i;
 
-	desc = malloc(sizeof(*desc));
-	desc->type = type;
-	desc->num_pages = num_pages;
-	desc->features = features;
-	desc->status = 0;
-	if (num_pages) {
-		top -= num_pages*getpagesize();
-		map_zeroed_pages(top, num_pages);
-		desc->pfn = top / getpagesize();
-	} else
-		desc->pfn = 0;
-	return desc;
+	for (i = 0; i < LGUEST_MAX_DEVICES; i++) {
+		if (!descs[i].type) {
+			descs[i].type = type;
+			descs[i].features = features;
+			descs[i].num_pages = num_pages;
+			if (num_pages) {
+				map_zeroed_pages(top, num_pages);
+				descs[i].pfn = top/getpagesize();
+				top += num_pages*getpagesize();
+			}
+			return &descs[i];
+		}
+	}
+	errx(1, "too many devices");
 }
 
 static struct device *new_device(struct device_list *devices,
@@ -669,7 +672,7 @@ static struct device *new_device(struct 
 	dev->fd = fd;
 	if (handle_input)
 		set_fd(dev->fd, devices);
-	dev->desc = new_dev_desc(type, features, num_pages);
+	dev->desc = new_dev_desc(devices->descs, type, features, num_pages);
 	dev->mem = (void *)(dev->desc->pfn * getpagesize());
 	dev->handle_input = handle_input;
 	dev->watch_key = (unsigned long)dev->mem + watch_off;
@@ -866,30 +869,6 @@ static void setup_tun_net(const char *ar
 		verbose("attached to bridge: %s\n", br_name);
 }
 
-/* Now we know how much memory we have, we copy in device descriptors */
-static void map_device_descriptors(struct device_list *devs, unsigned long mem)
-{
-	struct device *i;
-	unsigned int num;
-	struct lguest_device_desc *descs;
-
-	/* Device descriptor array sits just above top of normal memory */
-	descs = map_zeroed_pages(mem, 1);
-
-	for (i = devs->dev, num = 0; i; i = i->next, num++) {
-		if (num == LGUEST_MAX_DEVICES)
-			errx(1, "too many devices");
-		verbose("Device %i: %s\n", num,
-			i->desc->type == LGUEST_DEVICE_T_NET ? "net"
-			: i->desc->type == LGUEST_DEVICE_T_CONSOLE ? "console"
-			: i->desc->type == LGUEST_DEVICE_T_BLOCK ? "block"
-			: "unknown");
-		descs[num] = *i->desc;
-		free(i->desc);
-		i->desc = &descs[num];
-	}
-}
-
 static void __attribute__((noreturn))
 run_guest(int lguest_fd, struct device_list *device_list)
 {
@@ -934,8 +913,8 @@ static void usage(void)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
-	int c, lguest_fd;
+	unsigned long mem = 0, pgdir, start, page_offset, initrd_size = 0;
+	int i, c, lguest_fd;
 	struct device_list device_list;
 	void *boot = (void *)0;
 	const char *initrd_name = NULL;
@@ -945,6 +924,15 @@ int main(int argc, char *argv[])
 	device_list.lastdev = &device_list.dev;
 	FD_ZERO(&device_list.infds);
 
+	/* We need to know how much memory so we can allocate devices. */
+	for (i = 1; i < argc; i++) {
+		if (argv[i][0] != '-') {
+			mem = top = atoi(argv[i]) * 1024 * 1024;
+			device_list.descs = map_zeroed_pages(top, 1);
+			top += getpagesize();
+			break;
+		}
+	}
 	while ((c = getopt_long(argc, argv, "v", opts, NULL)) != EOF) {
 		switch (c) {
 		case 'v':
@@ -974,16 +962,12 @@ int main(int argc, char *argv[])
 	setup_console(&device_list);
 
 	/* First we map /dev/zero over all of guest-physical memory. */
-	mem = atoi(argv[optind]) * 1024 * 1024;
 	map_zeroed_pages(0, mem / getpagesize());
 
 	/* Now we load the kernel */
 	start = load_kernel(open_or_die(argv[optind+1], O_RDONLY),
 			    &page_offset);
 
-	/* Write the device descriptors into memory. */
-	map_device_descriptors(&device_list, mem);
-
 	/* Map the initrd image if requested */
 	if (initrd_name) {
 		initrd_size = load_initrd(initrd_name, mem);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

resend-link-lguest-example-launcher-non-static.patch
git-kvm.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
