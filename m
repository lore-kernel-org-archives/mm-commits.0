From: akpm@linux-foundation.org
Subject: - lguest-files-should-explicitly-include-asm-paravirth.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:47 -0700
Message-ID: <200708140503.l7E53ljk032090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765142AbXHNFLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jes@sgi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest files should explicitly include asm/paravirt.h
has been removed from the -mm tree.  Its filename was
     lguest-files-should-explicitly-include-asm-paravirth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest files should explicitly include asm/paravirt.h
From: Jes Sorensen <jes@sgi.com>

Files using bits from paravirt.h should explicitly include it rather than
relying on it being pulled in by something else.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_lguest.c   |    1 +
 drivers/lguest/lguest_bus.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/char/hvc_lguest.c~lguest-files-should-explicitly-include-asm-paravirth drivers/char/hvc_lguest.c
--- a/drivers/char/hvc_lguest.c~lguest-files-should-explicitly-include-asm-paravirth
+++ a/drivers/char/hvc_lguest.c
@@ -35,6 +35,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/lguest_bus.h>
+#include <asm/paravirt.h>
 #include "hvc_console.h"
 
 /*D:340 This is our single console input buffer, with associated "struct
diff -puN drivers/lguest/lguest_bus.c~lguest-files-should-explicitly-include-asm-paravirth drivers/lguest/lguest_bus.c
--- a/drivers/lguest/lguest_bus.c~lguest-files-should-explicitly-include-asm-paravirth
+++ a/drivers/lguest/lguest_bus.c
@@ -5,6 +5,7 @@
 #include <linux/bootmem.h>
 #include <linux/lguest_bus.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
 
 static ssize_t type_show(struct device *_dev,
                          struct device_attribute *attr, char *buf)
_

Patches currently in -mm which might be from jes@sgi.com are

memoryless-nodes-uncached-allocator-updates.patch
