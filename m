From: akpm@linux-foundation.org
Subject: [merged] module_device_table-fix-some-callsites-fix.patch removed from -mm tree
Date: Mon, 09 Feb 2015 11:47:37 -0800
Message-ID: <54d90ed9.FxBG6mh0ojXzu9RK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbBITrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 14:47:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, a.ryabinin@samsung.com, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MODULE_DEVICE_TABLE: fix gscps2
has been removed from the -mm tree.  Its filename was
     module_device_table-fix-some-callsites-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: MODULE_DEVICE_TABLE: fix gscps2

The patch "module: fix types of device tables aliases" newly requires
that invocations of

MODULE_DEVICE_TABLE(type, name);

come *after* the definition of `name'.  That is reasonable, but gscps2
wasn't doing this.  Fix it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/gscps2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/serio/gscps2.c~module_device_table-fix-some-callsites-fix drivers/input/serio/gscps2.c
--- a/drivers/input/serio/gscps2.c~module_device_table-fix-some-callsites-fix
+++ a/drivers/input/serio/gscps2.c
@@ -40,7 +40,6 @@
 MODULE_AUTHOR("Laurent Canet <canetl@esiee.fr>, Thibaut Varene <varenet@parisc-linux.org>, Helge Deller <deller@gmx.de>");
 MODULE_DESCRIPTION("HP GSC PS2 port driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(parisc, gscps2_device_tbl);
 
 #define PFX "gscps2.c: "
 
@@ -439,6 +438,7 @@ static struct parisc_device_id gscps2_de
 #endif
 	{ 0, }	/* 0 terminated list */
 };
+MODULE_DEVICE_TABLE(parisc, gscps2_device_tbl);
 
 static struct parisc_driver parisc_ps2_driver = {
 	.name		= "gsc_ps2",
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-drop-_page_file-and-pte_file-related-helpers.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
fs-affs-fix-casting-in-printed-messages.patch
linux-next.patch

