From: akpm@linux-foundation.org
Subject: - uml-locking-commentary-in-the-random-driver.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:47 -0800
Message-ID: <200702112248.l1BMmlJx015663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679AbXBKWst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: locking commentary in the random driver
has been removed from the -mm tree.  Its filename was
     uml-locking-commentary-in-the-random-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: locking commentary in the random driver
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/random.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/random.c~uml-locking-commentary-in-the-random-driver arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~uml-locking-commentary-in-the-random-driver
+++ a/arch/um/drivers/random.c
@@ -78,6 +78,7 @@ static const struct file_operations rng_
 	.read		= rng_dev_read,
 };
 
+/* rng_init shouldn't be called more than once at boot time */
 static struct miscdevice rng_miscdev = {
 	RNG_MISCDEV_MINOR,
 	RNG_MODULE_NAME,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
