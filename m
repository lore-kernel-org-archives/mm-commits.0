From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:29 -0800
Message-ID: <201002121903.o1CJ3To7021123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253Ab0BLTEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.getzendanner@students.olin.edu, airlied@linux.ie, jbarnes@virtuousgeek.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/vga/vgaarb.c: fix userspace pointer dereference
has been removed from the -mm tree.  Its filename was
     drivers-gpu-vga-vgaarbc-fix-userspace-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
_

Patches currently in -mm which might be from james.getzendanner@students.olin.edu are

origin.patch

