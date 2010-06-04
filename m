From: akpm@linux-foundation.org
Subject: + x86-mm-create-symbolic-index-into-address_markers-array.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:48:26 -0700
Message-ID: <201006042248.o54MmQLV022851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0FDWsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, hpa@zytor.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: mm: create symbolic index into address_markers array
has been added to the -mm tree.  Its filename is
     x86-mm-create-symbolic-index-into-address_markers-array.patch

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
Subject: x86: mm: create symbolic index into address_markers array
From: Andres Salomon <dilinger@queued.net>

Without this, adding entries into the address_markers array means adding
more and more of an #ifdef maze in pt_dump_init().  By using indices, we
can keep it a bit saner.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/dump_pagetables.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/dump_pagetables.c~x86-mm-create-symbolic-index-into-address_markers-array arch/x86/mm/dump_pagetables.c
--- a/arch/x86/mm/dump_pagetables.c~x86-mm-create-symbolic-index-into-address_markers-array
+++ a/arch/x86/mm/dump_pagetables.c
@@ -37,6 +37,28 @@ struct addr_marker {
 	const char *name;
 };
 
+/* indices for address_markers; keep sync'd w/ address_markers below */
+enum address_markers_idx {
+	USER_SPACE_NR = 0,
+#ifdef CONFIG_X86_64
+	KERNEL_SPACE_NR,
+	LOW_KERNEL_NR,
+	VMALLOC_START_NR,
+	VMEMMAP_START_NR,
+	HIGH_KERNEL_NR,
+	MODULES_VADDR_NR,
+	MODULES_END_NR,
+#else
+	KERNEL_SPACE_NR,
+	VMALLOC_START_NR,
+	VMALLOC_END_NR,
+# ifdef CONFIG_HIGHMEM
+	PKMAP_BASE_NR,
+# endif
+	FIXADDR_START_NR,
+#endif
+};
+
 /* Address space markers hints */
 static struct addr_marker address_markers[] = {
 	{ 0, "User Space" },
@@ -331,14 +353,12 @@ static int pt_dump_init(void)
 
 #ifdef CONFIG_X86_32
 	/* Not a compile-time constant on x86-32 */
-	address_markers[2].start_address = VMALLOC_START;
-	address_markers[3].start_address = VMALLOC_END;
+	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
+	address_markers[VMALLOC_END_NR].start_address = VMALLOC_END;
 # ifdef CONFIG_HIGHMEM
-	address_markers[4].start_address = PKMAP_BASE;
-	address_markers[5].start_address = FIXADDR_START;
-# else
-	address_markers[4].start_address = FIXADDR_START;
+	address_markers[PKMAP_BASE_NR].start_address = PKMAP_BASE;
 # endif
+	address_markers[FIXADDR_START_NR].start_address = FIXADDR_START;
 #endif
 
 	pe = debugfs_create_file("kernel_page_tables", 0600, NULL, NULL,
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-mm-create-symbolic-index-into-address_markers-array.patch
x86-olpc-add-support-for-calling-into-openfirmware.patch
gxfb-fix-incorrect-__init-annotation.patch
lxfb-fix-incorrect-__init-annotation.patch

