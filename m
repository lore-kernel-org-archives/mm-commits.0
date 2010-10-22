From: akpm@linux-foundation.org
Subject: + ibm_rtl-fix-printk-format-warning.patch added to -mm tree
Date: Fri, 22 Oct 2010 16:23:42 -0700
Message-ID: <201010222323.o9MNNg6f013556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab0JVXY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, kmannth@us.ibm.com, mjg@redhat.com, vernux@us.ibm.com


The patch titled
     ibm_rtl: fix printk format warning
has been added to the -mm tree.  Its filename is
     ibm_rtl-fix-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kfifo-disable-__kfifo_must_check_helper.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
ibm_rtl-fix-printk-format-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-move-exportfs-since-it-is-not-a-networking-filesystem.patch
misc-devices-do-not-enable-by-default.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
kfifo-fix-kfifo_alloc-to-return-a-signed-int-value.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch
nfs-include-ratelimith-fix-nfs4state-build-error.patch

