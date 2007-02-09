From: akpm@linux-foundation.org
Subject: + ps3-preallocate-bootmem-memory-for-ps3fb.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:43 -0800
Message-ID: <200702090926.l199QhPw009507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946261AbXBIJ1v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3: Preallocate bootmem memory for ps3fb
has been added to the -mm tree.  Its filename is
     ps3-preallocate-bootmem-memory-for-ps3fb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3: Preallocate bootmem memory for ps3fb
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Preallocate bootmem memory for the PS3 frame buffer device, which needs a
large block of physically-contiguous memory. The size of this memory block is
configurable:
  - The config option CONFIG_FB_PS3_DEFAULT_SIZE_M allows to specify the
    default amount of memory (in MiB) allocated to the virtual frame buffer.
  - The early boot parameter `ps3fb=xxx' allows to override the default value.
    It will be rounded up to a multiple of 1 MiB, if needed.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/setup.c |   42 +++++++++++++++++++++++++++
 include/asm-powerpc/ps3.h          |    9 +++++
 2 files changed, 51 insertions(+)

diff -puN arch/powerpc/platforms/ps3/setup.c~ps3-preallocate-bootmem-memory-for-ps3fb arch/powerpc/platforms/ps3/setup.c
--- a/arch/powerpc/platforms/ps3/setup.c~ps3-preallocate-bootmem-memory-for-ps3fb
+++ a/arch/powerpc/platforms/ps3/setup.c
@@ -24,6 +24,7 @@
 #include <linux/root_dev.h>
 #include <linux/console.h>
 #include <linux/kexec.h>
+#include <linux/bootmem.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -80,6 +81,46 @@ static void ps3_panic(char *str)
 	for (;;) ;
 }
 
+
+static void prealloc(struct ps3_prealloc *p)
+{
+	if (!p->size)
+		return;
+
+	p->address = __alloc_bootmem(p->size, p->align, __pa(MAX_DMA_ADDRESS));
+	if (!p->address) {
+		printk(KERN_ERR "%s: Cannot allocate %s\n", __FUNCTION__,
+		       p->name);
+		return;
+	}
+
+	printk(KERN_INFO "%s: %lu bytes at %p\n", p->name, p->size,
+	       p->address);
+}
+
+#ifdef CONFIG_FB_PS3
+struct ps3_prealloc ps3fb_videomemory = {
+    .name = "ps3fb videomemory",
+    .size = CONFIG_FB_PS3_DEFAULT_SIZE_M*1024*1024,
+    .align = 1024*1024			/* the GPU requires 1 MiB alignment */
+};
+#define prealloc_ps3fb_videomemory()	prealloc(&ps3fb_videomemory)
+
+static int __init early_parse_ps3fb(char *p)
+{
+	if (!p)
+		return 1;
+
+	ps3fb_videomemory.size = _ALIGN_UP(memparse(p, &p),
+					   ps3fb_videomemory.align);
+	return 0;
+}
+early_param("ps3fb", early_parse_ps3fb);
+#else
+#define prealloc_ps3fb_videomemory()	do { } while (0)
+#endif
+
+
 static void __init ps3_setup_arch(void)
 {
 	union ps3_firmware_version v;
@@ -101,6 +142,7 @@ static void __init ps3_setup_arch(void)
 	conswitchp = &dummy_con;
 #endif
 
+	prealloc_ps3fb_videomemory();
 	ppc_md.power_save = ps3_power_save;
 
 	DBG(" <- %s:%d\n", __func__, __LINE__);
diff -puN include/asm-powerpc/ps3.h~ps3-preallocate-bootmem-memory-for-ps3fb include/asm-powerpc/ps3.h
--- a/include/asm-powerpc/ps3.h~ps3-preallocate-bootmem-memory-for-ps3fb
+++ a/include/asm-powerpc/ps3.h
@@ -388,4 +388,13 @@ struct ps3_vuart_port_device {
 
 int ps3_vuart_port_device_register(struct ps3_vuart_port_device *dev);
 
+struct ps3_prealloc {
+    const char *name;
+    void *address;
+    unsigned long size;
+    unsigned long align;
+};
+
+extern struct ps3_prealloc ps3fb_videomemory;
+
 #endif
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
