Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AA7C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D2C221E2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266231;
	bh=2n+JlgFerNR328fyXzdWEALMEuFsdeEWZMBTPuquKUU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MjPWokdOf56l4UXCwWaACsFaPan85/6LqTVzPrJDjemiNU/3q0OtCsuYdORNcy0Wk
	 yI/N9uTTF0V/nDdRoGj3jtDjw5+wKBHozzkYTHwN/Uyy5Mh/BkMYH/2h0x+xwT0K8O
	 l65yCfFgD1dTzpHhy18kEOSva52kpqwxV8I8fNII=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgHLVDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789932224D;
        Wed, 12 Aug 2020 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266228;
        bh=2n+JlgFerNR328fyXzdWEALMEuFsdeEWZMBTPuquKUU=;
        h=Date:From:To:Subject:From;
        b=iY/tQB3HTeiVtLa2u2B9305NPW8xr1ihXEwP79W4VAcmKFW6lvwB+S92rsnHHrcif
         7V7z5Jiw+rnzrLYUaJm2RCpdXp5hTBDC0ZixHwNyVB/W+z4bHttxu6DkgQr4YcE1zz
         MpqlvUoqftUfdPlZ3v5Vl/5jgxJMelUb6W4EPwRM=
Date:   Wed, 12 Aug 2020 14:03:48 -0700
From:   akpm@linux-foundation.org
To:     grandmaster@al2klimov.de, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged] include-replace-http-links-with-https-ones.patch
 removed from -mm tree
Message-ID: <20200812210348.juizRs7bU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/: replace HTTP links with HTTPS ones
has been removed from the -mm tree.  Its filename was
     include-replace-http-links-with-https-ones.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: include/: replace HTTP links with HTTPS ones

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Link: http://lkml.kernel.org/r/20200726110117.16346-1-grandmaster@al2klimov=
.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/clocksource/timer-ti-dm.h               |    2 +-
 include/linux/btree.h                           |    2 +-
 include/linux/delay.h                           |    2 +-
 include/linux/dma/k3-psil.h                     |    2 +-
 include/linux/dma/k3-udma-glue.h                |    2 +-
 include/linux/dma/ti-cppi5.h                    |    2 +-
 include/linux/irqchip/irq-omap-intc.h           |    2 +-
 include/linux/jhash.h                           |    2 +-
 include/linux/leds-ti-lmu-common.h              |    2 +-
 include/linux/platform_data/davinci-cpufreq.h   |    2 +-
 include/linux/platform_data/davinci_asp.h       |    2 +-
 include/linux/platform_data/elm.h               |    2 +-
 include/linux/platform_data/gpio-davinci.h      |    2 +-
 include/linux/platform_data/gpmc-omap.h         |    2 +-
 include/linux/platform_data/mtd-davinci-aemif.h |    2 +-
 include/linux/platform_data/omap-twl4030.h      |    2 +-
 include/linux/platform_data/uio_pruss.h         |    2 +-
 include/linux/platform_data/usb-omap.h          |    2 +-
 include/linux/soc/ti/k3-ringacc.h               |    2 +-
 include/linux/soc/ti/knav_qmss.h                |    2 +-
 include/linux/soc/ti/ti-msgmgr.h                |    2 +-
 include/linux/wkup_m3_ipc.h                     |    2 +-
 include/linux/xxhash.h                          |    2 +-
 include/linux/xz.h                              |    2 +-
 include/linux/zlib.h                            |    2 +-
 include/soc/arc/aux.h                           |    2 +-
 include/uapi/linux/elf.h                        |    2 +-
 include/uapi/linux/map_to_7segment.h            |    2 +-
 include/uapi/linux/types.h                      |    2 +-
 include/uapi/linux/usb/ch9.h                    |    2 +-
 30 files changed, 30 insertions(+), 30 deletions(-)

--- a/include/clocksource/timer-ti-dm.h~include-replace-http-links-with-htt=
ps-ones
+++ a/include/clocksource/timer-ti-dm.h
@@ -1,7 +1,7 @@
 /*
  * OMAP Dual-Mode Timers
  *
- * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2010 Texas Instruments Incorporated - https://www.ti.com/
  * Tarun Kanti DebBarma <tarun.kanti@ti.com>
  * Thara Gopinath <thara@ti.com>
  *
--- a/include/linux/btree.h~include-replace-http-links-with-https-ones
+++ a/include/linux/btree.h
@@ -10,7 +10,7 @@
  *
  * A B+Tree is a data structure for looking up arbitrary (currently allowi=
ng
  * unsigned long, u32, u64 and 2 * u64) keys into pointers. The data struc=
ture
- * is described at http://en.wikipedia.org/wiki/B-tree, we currently do not
+ * is described at https://en.wikipedia.org/wiki/B-tree, we currently do n=
ot
  * use binary search to find the key on lookups.
  *
  * Each B+Tree consists of a head, that contains bookkeeping information a=
nd
--- a/include/linux/delay.h~include-replace-http-links-with-https-ones
+++ a/include/linux/delay.h
@@ -16,7 +16,7 @@
  *  3. CPU clock rate changes.
  *
  * Please see this thread:
- *   http://lists.openwall.net/linux-kernel/2011/01/09/56
+ *   https://lists.openwall.net/linux-kernel/2011/01/09/56
  */
=20
 #include <linux/kernel.h>
--- a/include/linux/dma/k3-psil.h~include-replace-http-links-with-https-ones
+++ a/include/linux/dma/k3-psil.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- *  Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com
+ *  Copyright (C) 2019 Texas Instruments Incorporated - https://www.ti.com
  */
=20
 #ifndef K3_PSIL_H_
--- a/include/linux/dma/k3-udma-glue.h~include-replace-http-links-with-http=
s-ones
+++ a/include/linux/dma/k3-udma-glue.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- *  Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com
+ *  Copyright (C) 2019 Texas Instruments Incorporated - https://www.ti.com
  */
=20
 #ifndef K3_UDMA_GLUE_H_
--- a/include/linux/dma/ti-cppi5.h~include-replace-http-links-with-https-on=
es
+++ a/include/linux/dma/ti-cppi5.h
@@ -2,7 +2,7 @@
 /*
  * CPPI5 descriptors interface
  *
- * Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2019 Texas Instruments Incorporated - https://www.ti.com
  */
=20
 #ifndef __TI_CPPI5_H__
--- a/include/linux/irqchip/irq-omap-intc.h~include-replace-http-links-with=
-https-ones
+++ a/include/linux/irqchip/irq-omap-intc.h
@@ -2,7 +2,7 @@
 /**
  * irq-omap-intc.h - INTC Idle Functions
  *
- * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2014 Texas Instruments Incorporated - https://www.ti.com
  *
  * Author: Felipe Balbi <balbi@ti.com>
  */
--- a/include/linux/jhash.h~include-replace-http-links-with-https-ones
+++ a/include/linux/jhash.h
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2006. Bob Jenkins (bob_jenkins@burtleburtle.net)
  *
- * http://burtleburtle.net/bob/hash/
+ * https://burtleburtle.net/bob/hash/
  *
  * These are the credits from Bob's sources:
  *
--- a/include/linux/leds-ti-lmu-common.h~include-replace-http-links-with-ht=
tps-ones
+++ a/include/linux/leds-ti-lmu-common.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 // TI LMU Common Core
-// Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com/
+// Copyright (C) 2018 Texas Instruments Incorporated - https://www.ti.com/
=20
 #ifndef _TI_LMU_COMMON_H_
 #define _TI_LMU_COMMON_H_
--- a/include/linux/platform_data/davinci_asp.h~include-replace-http-links-=
with-https-ones
+++ a/include/linux/platform_data/davinci_asp.h
@@ -1,7 +1,7 @@
 /*
  * TI DaVinci Audio Serial Port support
  *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2012 Texas Instruments Incorporated - https://www.ti.com/
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
--- a/include/linux/platform_data/davinci-cpufreq.h~include-replace-http-li=
nks-with-https-ones
+++ a/include/linux/platform_data/davinci-cpufreq.h
@@ -2,7 +2,7 @@
 /*
  * TI DaVinci CPUFreq platform support.
  *
- * Copyright (C) 2009 Texas Instruments, Inc. http://www.ti.com/
+ * Copyright (C) 2009 Texas Instruments, Inc. https://www.ti.com/
  */
=20
 #ifndef _MACH_DAVINCI_CPUFREQ_H
--- a/include/linux/platform_data/elm.h~include-replace-http-links-with-htt=
ps-ones
+++ a/include/linux/platform_data/elm.h
@@ -2,7 +2,7 @@
 /*
  * BCH Error Location Module
  *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2012 Texas Instruments Incorporated - https://www.ti.com/
  */
=20
 #ifndef __ELM_H
--- a/include/linux/platform_data/gpio-davinci.h~include-replace-http-links=
-with-https-ones
+++ a/include/linux/platform_data/gpio-davinci.h
@@ -1,7 +1,7 @@
 /*
  * DaVinci GPIO Platform Related Defines
  *
- * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2013 Texas Instruments Incorporated - https://www.ti.com/
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
--- a/include/linux/platform_data/gpmc-omap.h~include-replace-http-links-wi=
th-https-ones
+++ a/include/linux/platform_data/gpmc-omap.h
@@ -2,7 +2,7 @@
 /*
  * OMAP GPMC Platform data
  *
- * Copyright (C) 2014 Texas Instruments, Inc. - http://www.ti.com
+ * Copyright (C) 2014 Texas Instruments, Inc. - https://www.ti.com
  *	Roger Quadros <rogerq@ti.com>
  */
=20
--- a/include/linux/platform_data/mtd-davinci-aemif.h~include-replace-http-=
links-with-https-ones
+++ a/include/linux/platform_data/mtd-davinci-aemif.h
@@ -1,7 +1,7 @@
 /*
  * TI DaVinci AEMIF support
  *
- * Copyright 2010 (C) Texas Instruments, Inc. http://www.ti.com/
+ * Copyright 2010 (C) Texas Instruments, Inc. https://www.ti.com/
  *
  * This file is licensed under the terms of the GNU General Public License
  * version 2. This program is licensed "as is" without any warranty of any
--- a/include/linux/platform_data/omap-twl4030.h~include-replace-http-links=
-with-https-ones
+++ a/include/linux/platform_data/omap-twl4030.h
@@ -3,7 +3,7 @@
  * omap-twl4030.h - ASoC machine driver for TI SoC based boards with twl40=
30
  *		    codec, header.
  *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2012 Texas Instruments Incorporated - https://www.ti.com
  * All rights reserved.
  *
  * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
--- a/include/linux/platform_data/uio_pruss.h~include-replace-http-links-wi=
th-https-ones
+++ a/include/linux/platform_data/uio_pruss.h
@@ -3,7 +3,7 @@
  *
  * Platform data for uio_pruss driver
  *
- * Copyright (C) 2010-11 Texas Instruments Incorporated - http://www.ti.co=
m/
+ * Copyright (C) 2010-11 Texas Instruments Incorporated - https://www.ti.c=
om/
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
--- a/include/linux/platform_data/usb-omap.h~include-replace-http-links-wit=
h-https-ones
+++ a/include/linux/platform_data/usb-omap.h
@@ -1,7 +1,7 @@
 /*
  * usb-omap.h - Platform data for the various OMAP USB IPs
  *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2012 Texas Instruments Incorporated - https://www.ti.com
  *
  * This software is distributed under the terms of the GNU General Public
  * License ("GPL") version 2, as published by the Free Software Foundation.
--- a/include/linux/soc/ti/k3-ringacc.h~include-replace-http-links-with-htt=
ps-ones
+++ a/include/linux/soc/ti/k3-ringacc.h
@@ -2,7 +2,7 @@
 /*
  * K3 Ring Accelerator (RA) subsystem interface
  *
- * Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2019 Texas Instruments Incorporated - https://www.ti.com
  */
=20
 #ifndef __SOC_TI_K3_RINGACC_API_H_
--- a/include/linux/soc/ti/knav_qmss.h~include-replace-http-links-with-http=
s-ones
+++ a/include/linux/soc/ti/knav_qmss.h
@@ -1,7 +1,7 @@
 /*
  * Keystone Navigator Queue Management Sub-System header
  *
- * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Copyright (C) 2014 Texas Instruments Incorporated - https://www.ti.com
  * Author:	Sandeep Nair <sandeep_n@ti.com>
  *		Cyril Chemparathy <cyril@ti.com>
  *		Santosh Shilimkar <santosh.shilimkar@ti.com>
--- a/include/linux/soc/ti/ti-msgmgr.h~include-replace-http-links-with-http=
s-ones
+++ a/include/linux/soc/ti/ti-msgmgr.h
@@ -1,7 +1,7 @@
 /*
  * Texas Instruments' Message Manager
  *
- * Copyright (C) 2015-2016 Texas Instruments Incorporated - http://www.ti.=
com/
+ * Copyright (C) 2015-2016 Texas Instruments Incorporated - https://www.ti=
.com/
  *	Nishanth Menon
  *
  * This program is free software; you can redistribute it and/or modify
--- a/include/linux/wkup_m3_ipc.h~include-replace-http-links-with-https-ones
+++ a/include/linux/wkup_m3_ipc.h
@@ -1,7 +1,7 @@
 /*
  * TI Wakeup M3 for AMx3 SoCs Power Management Routines
  *
- * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2015 Texas Instruments Incorporated - https://www.ti.com/
  * Dave Gerlach <d-gerlach@ti.com>
  *
  * This program is free software; you can redistribute it and/or
--- a/include/linux/xxhash.h~include-replace-http-links-with-https-ones
+++ a/include/linux/xxhash.h
@@ -34,7 +34,7 @@
  * ("BSD").
  *
  * You can contact the author at:
- * - xxHash homepage: http://cyan4973.github.io/xxHash/
+ * - xxHash homepage: https://cyan4973.github.io/xxHash/
  * - xxHash source repository: https://github.com/Cyan4973/xxHash
  */
=20
--- a/include/linux/xz.h~include-replace-http-links-with-https-ones
+++ a/include/linux/xz.h
@@ -2,7 +2,7 @@
  * XZ decompressor
  *
  * Authors: Lasse Collin <lasse.collin@tukaani.org>
- *          Igor Pavlov <http://7-zip.org/>
+ *          Igor Pavlov <https://7-zip.org/>
  *
  * This file has been put into the public domain.
  * You can do whatever you want with this file.
--- a/include/linux/zlib.h~include-replace-http-links-with-https-ones
+++ a/include/linux/zlib.h
@@ -23,7 +23,7 @@
=20
=20
   The data format used by the zlib library is described by RFCs (Request f=
or
-  Comments) 1950 to 1952 in the files http://www.ietf.org/rfc/rfc1950.txt
+  Comments) 1950 to 1952 in the files https://www.ietf.org/rfc/rfc1950.txt
   (zlib format), rfc1951.txt (deflate format) and rfc1952.txt (gzip format=
).
 */
=20
--- a/include/soc/arc/aux.h~include-replace-http-links-with-https-ones
+++ a/include/soc/arc/aux.h
@@ -22,7 +22,7 @@ static inline int read_aux_reg(u32 r)
=20
 /*
  * function helps elide unused variable warning
- * see: http://lists.infradead.org/pipermail/linux-snps-arc/2016-November/=
001748.html
+ * see: https://lists.infradead.org/pipermail/linux-snps-arc/2016-November=
/001748.html
  */
 static inline void write_aux_reg(u32 r, u32 v)
 {
--- a/include/uapi/linux/elf.h~include-replace-http-links-with-https-ones
+++ a/include/uapi/linux/elf.h
@@ -53,7 +53,7 @@ typedef __s64	Elf64_Sxword;
  *
  * - Oracle: Linker and Libraries.
  *   Part No: 817=E2=80=931984=E2=80=9319, August 2011.
- *   http://docs.oracle.com/cd/E18752_01/pdf/817-1984.pdf
+ *   https://docs.oracle.com/cd/E18752_01/pdf/817-1984.pdf
  *
  * - System V ABI AMD64 Architecture Processor Supplement
  *   Draft Version 0.99.4,
--- a/include/uapi/linux/map_to_7segment.h~include-replace-http-links-with-=
https-ones
+++ a/include/uapi/linux/map_to_7segment.h
@@ -24,7 +24,7 @@
  * of (ASCII) characters to a 7-segments notation.
  *
  * The 7 segment's wikipedia notation below is used as standard.
- * See: http://en.wikipedia.org/wiki/Seven_segment_display
+ * See: https://en.wikipedia.org/wiki/Seven_segment_display
  *
  * Notation:	+-a-+
  *		f   b
--- a/include/uapi/linux/types.h~include-replace-http-links-with-https-ones
+++ a/include/uapi/linux/types.h
@@ -7,7 +7,7 @@
 #ifndef __ASSEMBLY__
 #ifndef	__KERNEL__
 #ifndef __EXPORTED_HEADERS__
-#warning "Attempt to use kernel headers from user space, see http://kernel=
newbies.org/KernelHeaders"
+#warning "Attempt to use kernel headers from user space, see https://kerne=
lnewbies.org/KernelHeaders"
 #endif /* __EXPORTED_HEADERS__ */
 #endif
=20
--- a/include/uapi/linux/usb/ch9.h~include-replace-http-links-with-https-on=
es
+++ a/include/uapi/linux/usb/ch9.h
@@ -1229,7 +1229,7 @@ struct usb_set_sel_req {
  * As per USB compliance update, a device that is actively drawing
  * more than 100mA from USB must report itself as bus-powered in
  * the GetStatus(DEVICE) call.
- * http://compliance.usb.org/index.asp?UpdateFile=3DElectrical&Format=3DSt=
andard#34
+ * https://compliance.usb.org/index.asp?UpdateFile=3DElectrical&Format=3DS=
tandard#34
  */
 #define USB_SELF_POWER_VBUS_MAX_DRAW		100
=20
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are


