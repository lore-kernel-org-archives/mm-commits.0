From: akpm@linux-foundation.org
Subject: - uml-reconst-a-parameter.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:11 -0800
Message-ID: <200802052235.m15MZqsF012650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762282AbYBEWlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: reconst a parameter
has been removed from the -mm tree.  Its filename was
     uml-reconst-a-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: reconst a parameter
From: Jeff Dike <jdike@addtoit.com>

The previous const-ing patch consted a string which shouldn't have
been, and I didn't notice the gcc warning.

ubd_setup can't take a const char * because its address is assigned to
something which expects a char *arg.  Many setups modify the string
they are given, they can't be const.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-reconst-a-parameter arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-reconst-a-parameter
+++ a/arch/um/drivers/ubd_kern.c
@@ -444,7 +444,7 @@ __uml_help(ubd_setup,
 "    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
-static int udb_setup(const char *str)
+static int udb_setup(char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
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
