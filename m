From: akpm@linux-foundation.org
Subject: + sparsemem-reduce-i386-pae-section-size.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:33:38 -0700
Message-ID: <200803312133.m2VLXcwH027081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYCaVfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, clameter@sgi.com, dave@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de, y-goto@jp.fujitsu.com


The patch titled
     sparsemem: reduce i386 PAE section size
has been added to the -mm tree.  Its filename is
     sparsemem-reduce-i386-pae-section-size.patch

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
Subject: sparsemem: reduce i386 PAE section size
From: Jeremy Fitzhardinge <jeremy@goop.org>

A 1G section size makes memory hotplug too coarse in a virtual environment. 
Retuce it by a factor of 2 to 512M.  I would have liked to make it smaller,
but it runs out of reserved flags in the page flags.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/sparsemem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/sparsemem.h~sparsemem-reduce-i386-pae-section-size include/asm-x86/sparsemem.h
--- a/include/asm-x86/sparsemem.h~sparsemem-reduce-i386-pae-section-size
+++ a/include/asm-x86/sparsemem.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_PAE
-#  define SECTION_SIZE_BITS	30
+#  define SECTION_SIZE_BITS	29
 #  define MAX_PHYSADDR_BITS	36
 #  define MAX_PHYSMEM_BITS	36
 # else
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

