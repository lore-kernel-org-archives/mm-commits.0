From: akpm@osdl.org
Subject: + uml-locking-commentary-in-the-random-driver.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:21 -0800
Message-ID: <200701052013.l05KDLFA031075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57142 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXAEUNY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: locking commentary in the random driver
has been added to the -mm tree.  Its filename is
     uml-locking-commentary-in-the-random-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: locking commentary in the random driver
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/random.c |    1 +
 1 files changed, 1 insertion(+)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
