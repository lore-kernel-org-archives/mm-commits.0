From: akpm@linux-foundation.org
Subject: - serial-add-vr41xx-siu-setup-for-serial-console.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:29 -0700
Message-ID: <200804282155.m3SLtTlD018106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934976AbYD1Vzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial: add VR41xx SIU setup for serial console
has been removed from the -mm tree.  Its filename was
     serial-add-vr41xx-siu-setup-for-serial-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add VR41xx SIU setup for serial console
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Add VR41xx SIU setup for serial console.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/vr41xx/common/init.c   |    4 ++-
 arch/mips/vr41xx/common/siu.c    |   36 ++++++++++++++++++++++++++++-
 include/asm-mips/vr41xx/siu.h    |    8 +++++-
 include/asm-mips/vr41xx/vr41xx.h |    8 +++++-
 4 files changed, 52 insertions(+), 4 deletions(-)

diff -puN arch/mips/vr41xx/common/init.c~serial-add-vr41xx-siu-setup-for-serial-console arch/mips/vr41xx/common/init.c
--- a/arch/mips/vr41xx/common/init.c~serial-add-vr41xx-siu-setup-for-serial-console
+++ a/arch/mips/vr41xx/common/init.c
@@ -1,7 +1,7 @@
 /*
  *  init.c, Common initialization routines for NEC VR4100 series.
  *
- *  Copyright (C) 2003-2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -53,6 +53,8 @@ void __init plat_time_init(void)
 void __init plat_mem_setup(void)
 {
 	iomem_resource_init();
+
+	vr41xx_siu_setup();
 }
 
 void __init prom_init(void)
diff -puN arch/mips/vr41xx/common/siu.c~serial-add-vr41xx-siu-setup-for-serial-console arch/mips/vr41xx/common/siu.c
--- a/arch/mips/vr41xx/common/siu.c~serial-add-vr41xx-siu-setup-for-serial-console
+++ a/arch/mips/vr41xx/common/siu.c
@@ -1,7 +1,7 @@
 /*
  *  NEC VR4100 series SIU platform device.
  *
- *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2007-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -118,3 +118,37 @@ err_free_device:
 	return retval;
 }
 device_initcall(vr41xx_siu_add);
+
+void __init vr41xx_siu_setup(void)
+{
+	struct uart_port port;
+	struct resource *res;
+	unsigned int *type;
+	int i;
+
+	switch (current_cpu_type()) {
+	case CPU_VR4111:
+	case CPU_VR4121:
+		type = siu_type1_ports;
+		res = siu_type1_resource;
+		break;
+	case CPU_VR4122:
+	case CPU_VR4131:
+	case CPU_VR4133:
+		type = siu_type2_ports;
+		res = siu_type2_resource;
+		break;
+	default:
+		return;
+	}
+
+	for (i = 0; i < SIU_PORTS_MAX; i++) {
+		port.line = i;
+		port.type = type[i];
+		if (port.type == PORT_UNKNOWN)
+			break;
+		port.mapbase = res[i].start;
+		port.membase = (unsigned char __iomem *)KSEG1ADDR(res[i].start);
+		vr41xx_siu_early_setup(&port);
+	}
+}
diff -puN include/asm-mips/vr41xx/siu.h~serial-add-vr41xx-siu-setup-for-serial-console include/asm-mips/vr41xx/siu.h
--- a/include/asm-mips/vr41xx/siu.h~serial-add-vr41xx-siu-setup-for-serial-console
+++ a/include/asm-mips/vr41xx/siu.h
@@ -1,7 +1,7 @@
 /*
  *  Include file for NEC VR4100 series Serial Interface Unit.
  *
- *  Copyright (C) 2005  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2005-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -49,4 +49,10 @@ typedef enum {
 
 extern void vr41xx_select_irda_module(irda_module_t module, irda_speed_t speed);
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
+extern void vr41xx_siu_early_setup(struct uart_port *port);
+#else
+static inline void vr41xx_siu_early_setup(struct uart_port *port) {}
+#endif
+
 #endif /* __NEC_VR41XX_SIU_H */
diff -puN include/asm-mips/vr41xx/vr41xx.h~serial-add-vr41xx-siu-setup-for-serial-console include/asm-mips/vr41xx/vr41xx.h
--- a/include/asm-mips/vr41xx/vr41xx.h~serial-add-vr41xx-siu-setup-for-serial-console
+++ a/include/asm-mips/vr41xx/vr41xx.h
@@ -7,7 +7,7 @@
  * Copyright (C) 2001, 2002 Paul Mundt
  * Copyright (C) 2002 MontaVista Software, Inc.
  * Copyright (C) 2002 TimeSys Corp.
- * Copyright (C) 2003-2005 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ * Copyright (C) 2003-2008 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -143,4 +143,10 @@ extern void vr41xx_disable_csiint(uint16
 extern void vr41xx_enable_bcuint(void);
 extern void vr41xx_disable_bcuint(void);
 
+#ifdef CONFIG_SERIAL_VR41XX_CONSOLE
+extern void vr41xx_siu_setup(void);
+#else
+static inline void vr41xx_siu_setup(void) {}
+#endif
+
 #endif /* __NEC_VR41XX_H */
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch

