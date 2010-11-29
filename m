From: akpm@linux-foundation.org
Subject: [merged] ibm_rtl-fix-printk-format-warning.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:37 -0800
Message-ID: <201011291952.oATJq6E4007362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab0K2T5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:57:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, kmannth@us.ibm.com, mjg@redhat.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibm_rtl: fix printk format warning
has been removed from the -mm tree.  Its filename was
     ibm_rtl-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibm_rtl: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/platform/x86/ibm_rtl.c:305:warning: format '%#llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Keith Mannthey <kmannth@us.ibm.com>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/ibm_rtl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/ibm_rtl.c~ibm_rtl-fix-printk-format-warning drivers/platform/x86/ibm_rtl.c
--- a/drivers/platform/x86/ibm_rtl.c~ibm_rtl-fix-printk-format-warning
+++ a/drivers/platform/x86/ibm_rtl.c
@@ -302,7 +302,7 @@ static int __init ibm_rtl_init(void) {
 			RTL_DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
 			      rtl_cmd_width, rtl_cmd_type);
 			addr = ioread32(&rtl_table->cmd_port_address);
-			RTL_DEBUG("addr = %#llx\n", addr);
+			RTL_DEBUG("addr = %#llx\n", (unsigned long long)addr);
 			plen = rtl_cmd_width/sizeof(char);
 			rtl_cmd_addr = rtl_port_map(addr, plen);
 			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

