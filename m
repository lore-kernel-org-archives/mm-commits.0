From: akpm@linux-foundation.org
Subject: + io_apic-needs-apicdefh.patch added to -mm tree
Date: Wed, 28 Feb 2007 21:41:18 -0800
Message-ID: <200703010541.l215fIrM005755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXCAFli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 00:41:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, ak@suse.de


The patch titled
     io_apic.h needs apicdef.h
has been added to the -mm tree.  Its filename is
     io_apic-needs-apicdefh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: io_apic.h needs apicdef.h
From: Jean Delvare <khali@linux-fr.org>

A -mm patch caused:

In file included from drivers/pci/quirks.c:532:
include/asm/io_apic.h:61: error: "MAX_IO_APICS" undeclared here (not in a function)

So let's include the needed header.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/io_apic.h   |    1 +
 include/asm-x86_64/io_apic.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN include/asm-i386/io_apic.h~io_apic-needs-apicdefh include/asm-i386/io_apic.h
--- a/include/asm-i386/io_apic.h~io_apic-needs-apicdefh
+++ a/include/asm-i386/io_apic.h
@@ -3,6 +3,7 @@
 
 #include <asm/types.h>
 #include <asm/mpspec.h>
+#include <asm/apicdef.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.
diff -puN include/asm-x86_64/io_apic.h~io_apic-needs-apicdefh include/asm-x86_64/io_apic.h
--- a/include/asm-x86_64/io_apic.h~io_apic-needs-apicdefh
+++ a/include/asm-x86_64/io_apic.h
@@ -3,6 +3,7 @@
 
 #include <asm/types.h>
 #include <asm/mpspec.h>
+#include <asm/apicdef.h>
 
 /*
  * Intel IO-APIC support for SMP and UP systems.
_

Patches currently in -mm which might be from khali@linux-fr.org are

io_apic-needs-apicdefh.patch
git-dvb.patch
