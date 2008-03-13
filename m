From: akpm@linux-foundation.org
Subject: - drivers-acpi-asus_acpic-correct-use-of-and.patch removed from -mm tree
Date: Thu, 13 Mar 2008 12:00:02 -0700
Message-ID: <200803131900.m2DJ02dG028025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYCMTAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, kronos.it@gmail.com, len.brown@intel.com, maxime@tralhalla.org, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/asus_acpi.c: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     drivers-acpi-asus_acpic-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi/asus_acpi.c: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Luca Tettamanti <kronos.it@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Maxime Austruy <maxime@tralhalla.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/asus_acpi.c~drivers-acpi-asus_acpic-correct-use-of-and drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~drivers-acpi-asus_acpic-correct-use-of-and
+++ a/drivers/acpi/asus_acpi.c
@@ -610,7 +610,7 @@ write_led(const char __user * buffer, un
 	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
 
 	if (invert)		/* invert target value */
-		led_out = !led_out & 0x1;
+		led_out = !led_out;
 
 	if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
 		printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
_

Patches currently in -mm which might be from julia@diku.dk are

git-acpi.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

