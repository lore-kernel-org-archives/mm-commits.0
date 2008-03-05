From: akpm@linux-foundation.org
Subject: - drivers-char-isicomc-correct-use-of-and.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:48 -0800
Message-ID: <200803050745.m257jmrS021620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765060AbYCEHpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/isicom.c: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     drivers-char-isicomc-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/isicom.c: correct use of ! and &
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
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/isicom.c~drivers-char-isicomc-correct-use-of-and drivers/char/isicom.c
--- a/drivers/char/isicom.c~drivers-char-isicomc-correct-use-of-and
+++ a/drivers/char/isicom.c
@@ -1527,7 +1527,7 @@ static int __devinit reset_card(struct p
 	msleep(10);
 
 	portcount = inw(base + 0x2);
-	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
+	if (!(inw(base + 0xe) & 0x1) || (portcount != 0 && portcount != 4 &&
 				portcount != 8 && portcount != 16)) {
 		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.\n",
 			card + 1);
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

