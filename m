From: akpm@linux-foundation.org
Subject: + gpu-vga_switcheroo-fix-lock-imbalance.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:53:55 -0700
Message-ID: <201003192353.o2JNrtGB019370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0CSXyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, airlied@redhat.com


The patch titled
     gpu: vga_switcheroo, fix lock imbalance
has been added to the -mm tree.  Its filename is
     gpu-vga_switcheroo-fix-lock-imbalance.patch

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
Subject: gpu: vga_switcheroo, fix lock imbalance
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that one error path in vga_switcheroo_debugfs_write omits to
unlock vgasr_mutex.  Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vga_switcheroo.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/vga/vga_switcheroo.c~gpu-vga_switcheroo-fix-lock-imbalance drivers/gpu/vga/vga_switcheroo.c
--- a/drivers/gpu/vga/vga_switcheroo.c~gpu-vga_switcheroo-fix-lock-imbalance
+++ a/drivers/gpu/vga/vga_switcheroo.c
@@ -276,8 +276,10 @@ vga_switcheroo_debugfs_write(struct file
 
 	mutex_lock(&vgasr_mutex);
 
-	if (!vgasr_priv.active)
-		return -EINVAL;
+	if (!vgasr_priv.active) {
+		cnt = -EINVAL;
+		goto out;
+	}
 
 	/* pwr off the device not in use */
 	if (strncmp(usercmd, "OFF", 3) == 0) {
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch

