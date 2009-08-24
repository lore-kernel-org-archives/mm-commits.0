From: akpm@linux-foundation.org
Subject: + gpu-vgaarb-use-%p-in-pointers-prints.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:02:27 -0700
Message-ID: <200908242102.n7OL2RtG021836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZHXVDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, airlied@redhat.com, benh@kernel.crashing.org, jbarnes@virtuousgeek.org, tiago.vignatti@nokia.com


The patch titled
     gpu: vgaarb, use %p in pointers prints
has been added to the -mm tree.  Its filename is
     gpu-vgaarb-use-%p-in-pointers-prints.patch

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
Subject: gpu: vgaarb, use %p in pointers prints
From: Jiri Slaby <jirislaby@gmail.com>

To avoid compiler warnings about different size, remove pointer-to-int
cast and use %p directly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vgaarb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/vga/vgaarb.c~gpu-vgaarb-use-%p-in-pointers-prints drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~gpu-vgaarb-use-%p-in-pointers-prints
+++ a/drivers/gpu/vga/vgaarb.c
@@ -831,7 +831,7 @@ static ssize_t vga_arb_write(struct file
 		curr_pos += 5;
 		remaining -= 5;
 
-		pr_devel("client 0x%X called 'lock'\n", (int)priv);
+		pr_devel("client %p called 'lock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -867,7 +867,7 @@ static ssize_t vga_arb_write(struct file
 		curr_pos += 7;
 		remaining -= 7;
 
-		pr_devel("client 0x%X called 'unlock'\n", (int)priv);
+		pr_devel("client %p called 'unlock'\n", priv);
 
 		if (strncmp(curr_pos, "all", 3) == 0)
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
@@ -917,7 +917,7 @@ static ssize_t vga_arb_write(struct file
 		curr_pos += 8;
 		remaining -= 8;
 
-		pr_devel("client 0x%X called 'trylock'\n", (int)priv);
+		pr_devel("client %p called 'trylock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -960,7 +960,7 @@ static ssize_t vga_arb_write(struct file
 
 		curr_pos += 7;
 		remaining -= 7;
-		pr_devel("client 0x%X called 'target'\n", (int)priv);
+		pr_devel("client %p called 'target'\n", priv);
 		/* if target is default */
 		if (!strncmp(buf, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
@@ -1014,7 +1014,7 @@ static ssize_t vga_arb_write(struct file
 	} else if (strncmp(curr_pos, "decodes ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
-		pr_devel("vgaarb: client 0x%X called 'decodes'\n", (int)priv);
+		pr_devel("vgaarb: client %p called 'decodes'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
gpu-vgaarb-use-%p-in-pointers-prints.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

