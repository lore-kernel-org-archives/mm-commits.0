From: akpm@linux-foundation.org
Subject: + char-drivers-ram-oops-panic-logger-update.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:59:47 -0400
Message-ID: <201003230600.o2N60dYY017114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772Ab0CWGBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marco.stornelli@gmail.com, David.Woodhouse@intel.com, anders.grafstrom@netinsight.net, jamie@shareable.org, simon.kagstrom@netinsight.net, yuasa@linux-mips.org


The patch titled
     char-drivers-ram-oops-panic-logger-update
has been added to the -mm tree.  Its filename is
     char-drivers-ram-oops-panic-logger-update.patch

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
Subject: char-drivers-ram-oops-panic-logger-update
From: Marco Stornelli <marco.stornelli@gmail.com>

Ramoops, like mtdoops, can log oops/panic information but in RAM. It can
be used with persistent RAM for systems without flash support. In
addition, for this systems, with this driver, it's no more needed
add to the kernel the mtd subsystem with advantage in footprint.

-v3: changed permissions from 0600 to 0400 for size and address
of ram buffer. Fixed the lack of 'ramoops:' in some printk.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc; Anders Grafstrom <anders.grafstrom@netinsight.net>
Cc: Yuasa Yoichi <yuasa@linux-mips.org>
Cc: Jamie Lokier <jamie@shareable.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/ramoops.c~char-drivers-ram-oops-panic-logger-update drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~char-drivers-ram-oops-panic-logger-update
+++ a/drivers/char/ramoops.c
@@ -1,7 +1,7 @@
 /*
  * RAM Oops/Panic logger
  *
- * Copyright (C) 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright (C) 2010 Marco Stornelli <marco.stornelli@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -32,12 +32,12 @@
 #define RECORD_SIZE 4096
 
 static ulong mem_address;
-module_param(mem_address, ulong, 0600);
+module_param(mem_address, ulong, 0400);
 MODULE_PARM_DESC(mem_address,
 		"start of reserved RAM used to store oops/panic logs");
 
 static ulong mem_size;
-module_param(mem_size, ulong, 0600);
+module_param(mem_size, ulong, 0400);
 MODULE_PARM_DESC(mem_size,
 		"size of reserved RAM used to store oops/panic logs");
 
@@ -97,14 +97,14 @@ static int __init ramoops_init(void)
 	int err = -EINVAL;
 
 	if (!mem_size) {
-		printk(KERN_ERR "Invalid size specification");
+		printk(KERN_ERR "ramoops: invalid size specification");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(mem_size);
 
 	if (mem_size < RECORD_SIZE) {
-		printk(KERN_ERR "size too small");
+		printk(KERN_ERR "ramoops: size too small");
 		goto fail3;
 	}
 
@@ -147,7 +147,7 @@ static void __exit ramoops_exit(void)
 	struct ramoops_context *cxt = &oops_cxt;
 
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
-		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper\n");
+		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
_

Patches currently in -mm which might be from marco.stornelli@gmail.com are

char-drivers-ram-oops-panic-logger.patch
char-drivers-ram-oops-panic-logger-update.patch

