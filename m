From: akpm@linux-foundation.org
Subject: + kmap-leak-fix-for-x86_32-kdump.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:37:00 -0700
Message-ID: <200710182137.l9ILb06o032276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763456AbXJRVhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, vgoyal@in.ibm.com


The patch titled
     kmap leak fix for x86_32 kdump
has been added to the -mm tree.  Its filename is
     kmap-leak-fix-for-x86_32-kdump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kmap leak fix for x86_32 kdump
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

copy_oldmem_page should not return leaving a page frame from the
previous kernel mapped.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash_dump_32.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/crash_dump_32.c~kmap-leak-fix-for-x86_32-kdump arch/x86/kernel/crash_dump_32.c
--- a/arch/x86/kernel/crash_dump_32.c~kmap-leak-fix-for-x86_32-kdump
+++ a/arch/x86/kernel/crash_dump_32.c
@@ -47,6 +47,7 @@ ssize_t copy_oldmem_page(unsigned long p
 		if (!kdump_buf_page) {
 			printk(KERN_WARNING "Kdump: Kdump buffer page not"
 				" allocated\n");
+			kunmap_atomic(vaddr, KM_PTE0);
 			return -EFAULT;
 		}
 		copy_page(kdump_buf_page, vaddr);
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch
kmap-leak-fix-for-x86_32-kdump.patch
make-smart-battery-system-depend-on-acpi_sbs.patch
