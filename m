From: akpm@linux-foundation.org
Subject: - mark-struct-file_operations-const-2-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:26:39 -0800
Message-ID: <200702120726.l1C7QddY024793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbXBLH0t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     mark-struct-file_operations-const-2-fix
has been removed from the -mm tree.  Its filename was
     mark-struct-file_operations-const-2-fix.patch

This patch was dropped because it was folded into mark-struct-file_operations-const-2.patch

------------------------------------------------------
Subject: mark-struct-file_operations-const-2-fix
From: Andrew Morton <akpm@osdl.org>

arch/sparc64/solaris/socksys.c: In function `init_socksys':
arch/sparc64/solaris/socksys.c:193: error: assignment of read-only variable `socksys_file_ops'
arch/sparc64/solaris/socksys.c:196: error: assignment of read-only variable `socksys_file_ops'
arch/sparc64/solaris/socksys.c:197: error: assignment of read-only variable `socksys_file_ops'

I'm not sure what it's trying to do in there, but it doens't look good.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/solaris/socksys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc64/solaris/socksys.c~mark-struct-file_operations-const-2-fix arch/sparc64/solaris/socksys.c
--- a/arch/sparc64/solaris/socksys.c~mark-struct-file_operations-const-2-fix
+++ a/arch/sparc64/solaris/socksys.c
@@ -55,7 +55,7 @@ extern void mykfree(void *);
 
 static unsigned int (*sock_poll)(struct file *, poll_table *);
 
-static const struct file_operations socksys_file_ops = {
+static struct file_operations socksys_file_ops = {
 	/* Currently empty */
 };
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
