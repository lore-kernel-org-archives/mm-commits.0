From: akpm@linux-foundation.org
Subject: - h8300-zimage-support-update.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:30 -0700
Message-ID: <200707162050.l6GKoUOL001318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453AbXGPVUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300 zImage support update
has been removed from the -mm tree.  Its filename was
     h8300-zimage-support-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 zImage support update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

- Add missing files
- Add Makefile target
- Change image base
- Style fix

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Makefile                    |    7 ++---
 arch/h8300/boot/compressed/Makefile    |    4 +-
 arch/h8300/boot/compressed/head.S      |    2 -
 arch/h8300/boot/compressed/vmlinux.lds |   32 +++++++++++++++++++++++
 arch/h8300/boot/compressed/vmlinux.scr |    9 ++++++
 5 files changed, 48 insertions(+), 6 deletions(-)

diff -puN arch/h8300/Makefile~h8300-zimage-support-update arch/h8300/Makefile
--- a/arch/h8300/Makefile~h8300-zimage-support-update
+++ a/arch/h8300/Makefile
@@ -61,10 +61,11 @@ archmrproper:
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
-vmlinux.srec vmlinux.bin: vmlinux
+vmlinux.srec vmlinux.bin zImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
 define archhelp
-  echo  'vmlinux.bin  - Create raw binary'
-  echo  'vmlinux.srec - Create srec binary'
+  @echo  'vmlinux.bin  - Create raw binary'
+  @echo  'vmlinux.srec - Create srec binary'
+  @echo  'zImage       - Compressed kernel image'
 endef
diff -puN arch/h8300/boot/compressed/Makefile~h8300-zimage-support-update arch/h8300/boot/compressed/Makefile
--- a/arch/h8300/boot/compressed/Makefile~h8300-zimage-support-update
+++ a/arch/h8300/boot/compressed/Makefile
@@ -15,10 +15,10 @@ OBJECTS = $(obj)/head.o $(obj)/misc.o
 # in order to suppress error message.
 #
 CONFIG_MEMORY_START     ?= 0x00400000
-CONFIG_BOOT_LINK_OFFSET ?= 0x00400000
+CONFIG_BOOT_LINK_OFFSET ?= 0x00140000
 IMAGE_OFFSET := $(shell printf "0x%08x" $$[$(CONFIG_MEMORY_START)+$(CONFIG_BOOT_LINK_OFFSET)])
 
-LDFLAGS_vmlinux := -T $(obj)/vmlinux.lds
+LDFLAGS_vmlinux := -Ttext $(IMAGE_OFFSET) -estartup $(obj)/vmlinux.lds
 
 $(obj)/vmlinux: $(OBJECTS) $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
diff -puN arch/h8300/boot/compressed/head.S~h8300-zimage-support-update arch/h8300/boot/compressed/head.S
--- a/arch/h8300/boot/compressed/head.S~h8300-zimage-support-update
+++ a/arch/h8300/boot/compressed/head.S
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006 Yoshinori Sato
  */
 
-.h8300h
+	.h8300h
 #include <linux/linkage.h>
 
 #define SRAM_START 0xff4000
diff -puN /dev/null arch/h8300/boot/compressed/vmlinux.lds
--- /dev/null
+++ a/arch/h8300/boot/compressed/vmlinux.lds
@@ -0,0 +1,32 @@
+SECTIONS
+{
+        .text :
+        {
+        __stext = . ;
+	__text = .;
+	       *(.text.startup)
+	       *(.text)
+        __etext = . ;
+        }
+
+	.rodata :
+	{
+		*(.rodata)
+	}
+        .data :
+
+        {
+        __sdata = . ;
+        ___data_start = . ;
+                *(.data.*)
+	}
+        .bss :
+        {
+        . = ALIGN(0x4) ;
+        __sbss = . ;
+                *(.bss*)
+        . = ALIGN(0x4) ;
+        __ebss = . ;
+        __end = . ;
+        }
+}
diff -puN /dev/null arch/h8300/boot/compressed/vmlinux.scr
--- /dev/null
+++ a/arch/h8300/boot/compressed/vmlinux.scr
@@ -0,0 +1,9 @@
+SECTIONS
+{
+  .data : {
+	_input_len = .;
+	LONG(_input_data_end - _input_data) _input_data = .;
+	*(.data)
+	_input_data_end = .;
+	}
+}
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
