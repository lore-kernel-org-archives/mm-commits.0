From: akpm@linux-foundation.org
Subject: - uml-use-of-a-public-mac-is-a-warning-not-an-error.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:45 -0800
Message-ID: <200802052238.m15McQii012950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760710AbYBEWlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use of a public MAC is a warning, not an error
has been removed from the -mm tree.  Its filename was
     uml-use-of-a-public-mac-is-a-warning-not-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use of a public MAC is a warning, not an error
From: Jeff Dike <jdike@addtoit.com>

Downgrade one of the MAC validity checks.  If it's one that could be possibly
assigned to a physical NIC, then nothing will break.  So, emit a warning in
this case, but keep the requested MAC.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-use-of-a-public-mac-is-a-warning-not-an-error arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-use-of-a-public-mac-is-a-warning-not-an-error
+++ a/arch/um/drivers/net_kern.c
@@ -318,7 +318,7 @@ static void setup_etheraddr(char *str, u
 	if (str == NULL)
 		goto random;
 
-	for (i = 0;i < 6; i++) {
+	for (i = 0; i < 6; i++) {
 		addr[i] = simple_strtoul(str, &end, 16);
 		if ((end == str) ||
 		   ((*end != ':') && (*end != ',') && (*end != '\0'))) {
@@ -343,14 +343,13 @@ static void setup_etheraddr(char *str, u
 	}
 	if (!is_local_ether_addr(addr)) {
 		printk(KERN_WARNING
-		       "Warning: attempt to assign a globally valid ethernet "
+		       "Warning: Assigning a globally valid ethernet "
 		       "address to a device\n");
-		printk(KERN_WARNING "You should better enable the 2nd "
-		       "rightmost bit in the first byte of the MAC,\n");
+		printk(KERN_WARNING "You should set the 2nd rightmost bit in "
+		       "the first byte of the MAC,\n");
 		printk(KERN_WARNING "i.e. %02x:%02x:%02x:%02x:%02x:%02x\n",
 		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
 		       addr[5]);
-		goto random;
 	}
 	return;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
