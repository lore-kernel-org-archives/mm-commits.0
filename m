From: akpm@linux-foundation.org
Subject: [folded-merged] dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:16:30 -0700
Message-ID: <20130430221630.6CD405A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45521 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab3D3WQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:16:31 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so113961qcs.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:16:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.savkov@gmail.com, ben@decadent.org.uk, zhenzhong.duan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmi_scan: proper buf type in dmi_present()
has been removed from the -mm tree.  Its filename was
     dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix.patch

This patch was dropped because it was folded into dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

------------------------------------------------------
From: Artem Savkov <artem.savkov@gmail.com>
Subject: dmi_scan: proper buf type in dmi_present()

buf needs to be unsigned in dmi_present(), otherwise dmi_base calculation
doesn't work properly leading to a wraparound during dmi_ioremap:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/ioremap.c:524 __early_ioremap+0x85/0x18a()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.9.0-rc2-next-20130312 #283
[    0.000000] Call Trace:
[    0.000000]  [<c1036992>] warn_slowpath_common+0x72/0xa0
[    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
[    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
[    0.000000]  [<c10369e2>] warn_slowpath_null+0x22/0x30
[    0.000000]  [<c19cc176>] __early_ioremap+0x85/0x18a
[    0.000000]  [<c19cc1ed>] ? __early_ioremap+0xfc/0x18a
[    0.000000]  [<c19cc412>] early_ioremap+0xd/0xf
[    0.000000]  [<c19fbba9>] dmi_present+0xf5/0x22a
[    0.000000]  [<c19fbd9d>] dmi_scan_machine+0xbf/0x11c
[    0.000000]  [<c19bd781>] setup_arch+0x4db/0xca0
[    0.000000]  [<c168105c>] ? printk+0x3d/0x3f
[    0.000000]  [<c19ba763>] start_kernel+0x7b/0x329
[    0.000000]  [<c19ba361>] i386_start_kernel+0x137/0x13a
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] DMI not present or invalid.

Introduced in "dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()"

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Acked-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -419,7 +419,7 @@ static void __init dmi_format_ids(char *
 			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
-static int __init dmi_present(const char *buf)
+static int __init dmi_present(const u8 *buf)
 {
 	int smbios_ver;
 
_

Patches currently in -mm which might be from artem.savkov@gmail.com are

dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch

