From: akpm@linux-foundation.org
Subject: + drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:17:07 -0800
Message-ID: <200912302117.nBULH7gH002735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbZL3VRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james.getzendanner@students.olin.edu, airlied@linux.ie, jbarnes@virtuousgeek.org, stable@kernel.org


The patch titled
     drivers/gpu/vga/vgaarb.c: fix userspace pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference.patch

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
Subject: drivers/gpu/vga/vgaarb.c: fix userspace pointer dereference
From: Andy Getzendanner <james.getzendanner@students.olin.edu>

This patch corrects a userspace pointer dereference in the VGA arbiter
in 2.6.32.1.

copy_from_user() is used at line 822 to copy the contents of buf into
kbuf, but a call to strncmp() on line 964 uses buf rather than kbuf.  This
problem led to a GPF in strncmp() when X was started on my x86_32 systems.
 X triggered the behavior with a write of "target PCI:0000:01:00.0" to
/dev/vga_arbiter.

The patch has been tested against 2.6.32.1 and observed to correct the GPF
observed when starting X or manually writing the string "target
PCI:0000:01:00.0" to /dev/vga_arbiter.

Signed-off-by: Andy Getzendanner <james.getzendanner@students.olin.edu>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/vgaarb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/vga/vgaarb.c~drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference
+++ a/drivers/gpu/vga/vgaarb.c
@@ -961,7 +961,7 @@ static ssize_t vga_arb_write(struct file
 		remaining -= 7;
 		pr_devel("client 0x%p called 'target'\n", priv);
 		/* if target is default */
-		if (!strncmp(buf, "default", 7))
+		if (!strncmp(kbuf, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
 		else {
 			if (!vga_pci_str_to_vars(curr_pos, remaining,
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from james.getzendanner@students.olin.edu are

drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference.patch

