From: akpm@linux-foundation.org
Subject: + x86-use-generic-early-mem-copy.patch added to -mm tree
Date: Fri, 07 Aug 2015 15:19:52 -0700
Message-ID: <55c52f08.Nw2XKmBp2QgBvz+N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946394AbbHGWTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, ard.biesheuvel@linaro.org, arnd@arndb.de, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use generic early mem copy
has been added to the -mm tree.  Its filename is
     x86-use-generic-early-mem-copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-generic-early-mem-copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-generic-early-mem-copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: x86: use generic early mem copy

The early_ioremap library now has a generic copy_from_early_mem()
function.  Use the generic copy function for x86 relocate_initrd().

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff -puN arch/x86/kernel/setup.c~x86-use-generic-early-mem-copy arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-use-generic-early-mem-copy
+++ a/arch/x86/kernel/setup.c
@@ -324,8 +324,6 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = get_ramdisk_image();
 	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
-	unsigned long slop, clen, mapaddr;
-	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
 	relocated_ramdisk = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
@@ -343,25 +341,8 @@ static void __init relocate_initrd(void)
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
 	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 
-	q = (char *)initrd_start;
+	copy_from_early_mem((void *)initrd_start, ramdisk_image, ramdisk_size);
 
-	/* Copy the initrd */
-	while (ramdisk_size) {
-		slop = ramdisk_image & ~PAGE_MASK;
-		clen = ramdisk_size;
-		if (clen > MAX_MAP_CHUNK-slop)
-			clen = MAX_MAP_CHUNK-slop;
-		mapaddr = ramdisk_image & PAGE_MASK;
-		p = early_memremap(mapaddr, clen+slop);
-		memcpy(q, p+slop, clen);
-		early_memunmap(p, clen+slop);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
