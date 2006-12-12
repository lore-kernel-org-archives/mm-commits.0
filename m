From: akpm@osdl.org
Subject: + remove-include-linux-byteorder-pdp_endianh.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:28:58 -0800
Message-ID: <200612122128.kBCLSwX3016287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44148 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbWLLVcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     remove include/linux/byteorder/pdp_endian.h
has been added to the -mm tree.  Its filename is
     remove-include-linux-byteorder-pdp_endianh.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove include/linux/byteorder/pdp_endian.h
From: Adrian Bunk <bunk@stusta.de>

include/linux/byteorder/pdp_endian.h is completely unused, and the comment in
the file itself states that it's both untested and only a proof-of-concept.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/byteorder/Kbuild       |    1 
 include/linux/byteorder/pdp_endian.h |   88 -------------------------
 2 files changed, 89 deletions(-)

diff -puN include/linux/byteorder/Kbuild~remove-include-linux-byteorder-pdp_endianh include/linux/byteorder/Kbuild
--- a/include/linux/byteorder/Kbuild~remove-include-linux-byteorder-pdp_endianh
+++ a/include/linux/byteorder/Kbuild
@@ -1,6 +1,5 @@
 header-y += big_endian.h
 header-y += little_endian.h
-header-y += pdp_endian.h
 
 unifdef-y += generic.h
 unifdef-y += swabb.h
diff -puN include/linux/byteorder/pdp_endian.h~remove-include-linux-byteorder-pdp_endianh /dev/null
--- a/include/linux/byteorder/pdp_endian.h
+++ /dev/null
@@ -1,88 +0,0 @@
-#ifndef _LINUX_BYTEORDER_PDP_ENDIAN_H
-#define _LINUX_BYTEORDER_PDP_ENDIAN_H
-
-/*
- * Could have been named NUXI-endian, but we use the same name as in glibc.
- * hopefully only the PDP and its evolutions (old VAXen in compatibility mode)
- * should ever use this braindead byteorder.
- * This file *should* work, but has not been tested.
- *
- * little-endian is 1234; big-endian is 4321; nuxi/pdp-endian is 3412
- *
- * I thought vaxen were NUXI-endian, but was told they were correct-endian
- * (little-endian), though indeed there existed NUXI-endian machines
- * (DEC PDP-11 and old VAXen in compatibility mode).
- * This makes this file a bit useless, but as a proof-of-concept.
- *
- * But what does a __u64 look like: is it 34127856 or 78563412 ???
- * I don't dare imagine! Hence, no 64-bit byteorder support yet.
- * Hopefully, there 64-bit pdp-endian support shouldn't ever be required.
- *
- */
-
-#ifndef __PDP_ENDIAN
-#define __PDP_ENDIAN 3412
-#endif
-#ifndef __PDP_ENDIAN_BITFIELD
-#define __PDP_ENDIAN_BITFIELD
-#endif
-
-#include <linux/byteorder/swab.h>
-#include <linux/byteorder/swabb.h>
-
-#define __constant_htonl(x) ___constant_swahb32((x))
-#define __constant_ntohl(x) ___constant_swahb32((x))
-#define __constant_htons(x) ___constant_swab16((x))
-#define __constant_ntohs(x) ___constant_swab16((x))
-#define __constant_cpu_to_le64(x) I DON'T KNOW
-#define __constant_le64_to_cpu(x) I DON'T KNOW
-#define __constant_cpu_to_le32(x) ___constant_swahw32((x))
-#define __constant_le32_to_cpu(x) ___constant_swahw32((x))
-#define __constant_cpu_to_le16(x) ((__u16)(x)
-#define __constant_le16_to_cpu(x) ((__u16)(x)
-#define __constant_cpu_to_be64(x) I DON'T KNOW
-#define __constant_be64_to_cpu(x) I DON'T KNOW
-#define __constant_cpu_to_be32(x) ___constant_swahb32((x))
-#define __constant_be32_to_cpu(x) ___constant_swahb32((x))
-#define __constant_cpu_to_be16(x) ___constant_swab16((x))
-#define __constant_be16_to_cpu(x) ___constant_swab16((x))
-#define __cpu_to_le64(x) I DON'T KNOW
-#define __le64_to_cpu(x) I DON'T KNOW
-#define __cpu_to_le32(x) ___swahw32((x))
-#define __le32_to_cpu(x) ___swahw32((x))
-#define __cpu_to_le16(x) ((__u16)(x)
-#define __le16_to_cpu(x) ((__u16)(x)
-#define __cpu_to_be64(x) I DON'T KNOW
-#define __be64_to_cpu(x) I DON'T KNOW
-#define __cpu_to_be32(x) __swahb32((x))
-#define __be32_to_cpu(x) __swahb32((x))
-#define __cpu_to_be16(x) __swab16((x))
-#define __be16_to_cpu(x) __swab16((x))
-#define __cpu_to_le64p(x) I DON'T KNOW
-#define __le64_to_cpup(x) I DON'T KNOW
-#define __cpu_to_le32p(x) ___swahw32p((x))
-#define __le32_to_cpup(x) ___swahw32p((x))
-#define __cpu_to_le16p(x) (*(__u16*)(x))
-#define __le16_to_cpup(x) (*(__u16*)(x))
-#define __cpu_to_be64p(x) I DON'T KNOW
-#define __be64_to_cpup(x) I DON'T KNOW
-#define __cpu_to_be32p(x) __swahb32p((x))
-#define __be32_to_cpup(x) __swahb32p((x))
-#define __cpu_to_be16p(x) __swab16p((x))
-#define __be16_to_cpup(x) __swab16p((x))
-#define __cpu_to_le64s(x) I DON'T KNOW
-#define __le64_to_cpus(x) I DON'T KNOW
-#define __cpu_to_le32s(x) ___swahw32s((x))
-#define __le32_to_cpus(x) ___swahw32s((x))
-#define __cpu_to_le16s(x) do {} while (0)
-#define __le16_to_cpus(x) do {} while (0)
-#define __cpu_to_be64s(x) I DON'T KNOW
-#define __be64_to_cpus(x) I DON'T KNOW
-#define __cpu_to_be32s(x) __swahb32s((x))
-#define __be32_to_cpus(x) __swahb32s((x))
-#define __cpu_to_be16s(x) __swab16s((x))
-#define __be16_to_cpus(x) __swab16s((x))
-
-#include <linux/byteorder/generic.h>
-
-#endif /* _LINUX_BYTEORDER_PDP_ENDIAN_H */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
debug-add-sysrq_always_enabled-boot-option-cleanup.patch
one-more-export_unused_symbol-removal.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
remove-the-broken-scsi_seagate-driver.patch
remove-the-broken-skmc-driver.patch
remove-the-broken-blk_dev_swim_iop-driver.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

