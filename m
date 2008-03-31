From: akpm@linux-foundation.org
Subject: + paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:33:40 -0700
Message-ID: <200803312133.m2VLXesh027084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbYCaVed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     paravirt_ops: don't steal memory resources in paravirt_disable_iospace
has been added to the -mm tree.  Its filename is
     paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: paravirt_ops: don't steal memory resources in paravirt_disable_iospace
From: Jeremy Fitzhardinge <jeremy@goop.org>

The memory resource is also used for main memory, and we need it to allocate
physical addresses for memory hotplug.  Knobbling io space is enough to get
the job done anyway.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/paravirt.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN arch/x86/kernel/paravirt.c~paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace
+++ a/arch/x86/kernel/paravirt.c
@@ -206,13 +206,6 @@ static struct resource reserve_ioports =
 	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
 };
 
-static struct resource reserve_iomem = {
-	.start = 0,
-	.end = -1,
-	.name = "paravirt-iomem",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
-};
-
 /*
  * Reserve the whole legacy IO space to prevent any legacy drivers
  * from wasting time probing for their hardware.  This is a fairly
@@ -222,16 +215,7 @@ static struct resource reserve_iomem = {
  */
 int paravirt_disable_iospace(void)
 {
-	int ret;
-
-	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0) {
-		ret = request_resource(&iomem_resource, &reserve_iomem);
-		if (ret)
-			release_resource(&reserve_ioports);
-	}
-
-	return ret;
+	return request_resource(&ioport_resource, &reserve_ioports);
 }
 
 static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
git-x86.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
hotplug-memory-add-add_memory_resource.patch
hotplug-memory-adding-non-section-aligned-memory-is-bad.patch
sparsemem-reduce-i386-pae-section-size.patch
paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch
xen-make-blkif_getgeo-static.patch

