From: akpm@linux-foundation.org
Subject: + fix-modular-agpgart-ia64-allmodconfig.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:09:00 -0800
Message-ID: <200702160709.l1G790M8022858@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974AbXBPHJO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zwane@infradead.org, davej@codemonkey.org.uk, kyle@mcmartin.ca


The patch titled
     Fix modular AGPGART (ia64 allmodconfig)
has been added to the -mm tree.  Its filename is
     fix-modular-agpgart-ia64-allmodconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix modular AGPGART (ia64 allmodconfig)
From: Zwane Mwaikambo <zwane@infradead.org>

My previous compat AGP patch broke modular AGPGART.

Test built on;

i386 CONFIG_AGP=y,m
x86_64 CONFIG_AGP=y
ia64 CONFIG_AGP=m

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/Makefile~fix-modular-agpgart-ia64-allmodconfig drivers/char/agp/Makefile
--- a/drivers/char/agp/Makefile~fix-modular-agpgart-ia64-allmodconfig
+++ a/drivers/char/agp/Makefile
@@ -1,7 +1,8 @@
 agpgart-y := backend.o frontend.o generic.o isoch.o
 
+agpgart-$(CONFIG_COMPAT)	+= compat_ioctl.o
+
 obj-$(CONFIG_AGP)		+= agpgart.o
-obj-$(CONFIG_COMPAT)		+= compat_ioctl.o
 obj-$(CONFIG_AGP_ALI)		+= ali-agp.o
 obj-$(CONFIG_AGP_ATI)		+= ati-agp.o
 obj-$(CONFIG_AGP_AMD)		+= amd-k7-agp.o
_

Patches currently in -mm which might be from zwane@infradead.org are

git-agpgart.patch
fix-modular-agpgart-ia64-allmodconfig.patch
fix-mtrr-compat-ioctl.patch
x86-dont-probe-for-ddc-on-vbe12.patch
