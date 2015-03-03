From: akpm@linux-foundation.org
Subject: + mm-change-__get_vm_area_node-to-use-fls_long.patch added to -mm tree
Date: Tue, 03 Mar 2015 14:45:56 -0800
Message-ID: <54f639a4.KpTvInGrUxZvjDAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change __get_vm_area_node() to use fls_long()
has been added to the -mm tree.  Its filename is
     mm-change-__get_vm_area_node-to-use-fls_long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-__get_vm_area_node-to-use-fls_long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-__get_vm_area_node-to-use-fls_long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: change __get_vm_area_node() to use fls_long()

ioremap() and its related interfaces are used to create I/O mappings to
memory-mapped I/O devices.  The mapping sizes of the traditional I/O
devices are relatively small.  Non-volatile memory (NVM), however, has
many GB and is going to have TB soon.  It is not very efficient to create
large I/O mappings with 4KB.  

This patchset extends the ioremap() interfaces to transparently create I/O
mappings with huge pages whenever possible.  ioremap() continues to use
4KB mappings when a huge page does not fit into a requested range.  There
is no change necessary to the drivers using ioremap().  A requested
physical address must be aligned by a huge page size (1GB or 2MB on x86)
for using huge page mapping, though.  The kernel huge I/O mapping will
improve performance of NVM and other devices with large memory, and reduce
the time to create their mappings as well.

On x86, MTRRs can override PAT memory types with a 4KB granularity.  When
using a huge page, MTRRs can override the memory type of the huge page,
which may lead a performance penalty.  The processor can also behave in an
undefined manner if a huge page is mapped to a memory range that MTRRs
have mapped with multiple different memory types.  Therefore, the mapping
code falls back to use a smaller page size toward 4KB when a mapping range
is covered by non-WB type of MTRRs.  The WB type of MTRRs has no affect on
the PAT memory types.

The patchset introduces HAVE_ARCH_HUGE_VMAP, which indicates that the arch
supports huge KVA mappings for ioremap().  User may specify a new kernel
option "nohugeiomap" to disable the huge I/O mapping capability of
ioremap() when necessary.

Patch 1-4 change common files to support huge I/O mappings.  There is no
change in the functinalities unless HAVE_ARCH_HUGE_VMAP is defined on the
architecture of the system.

Patch 5-6 implement the HAVE_ARCH_HUGE_VMAP funcs on x86, and set
HAVE_ARCH_HUGE_VMAP on x86.



This patch (of 6):

__get_vm_area_node() takes unsigned long size, which is a 64-bit value on
a 64-bit kernel.  However, fls(size) simply ignores the upper 32-bit. 
Change to use fls_long() to handle the size properly.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-change-__get_vm_area_node-to-use-fls_long mm/vmalloc.c
--- a/mm/vmalloc.c~mm-change-__get_vm_area_node-to-use-fls_long
+++ a/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/llist.h>
+#include <linux/bitops.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -1314,7 +1315,8 @@ static struct vm_struct *__get_vm_area_n
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP)
-		align = 1ul << clamp(fls(size), PAGE_SHIFT, IOREMAP_MAX_ORDER);
+		align = 1ul << clamp_t(int, fls_long(size),
+				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

