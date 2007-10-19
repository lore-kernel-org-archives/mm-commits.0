From: akpm@linux-foundation.org
Subject: - kmap-leak-fix-for-x86_32-kdump.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:09 -0700
Message-ID: <200710192249.l9JMn9jn023943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418AbXJSWtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kmap leak fix for x86_32 kdump
has been removed from the -mm tree.  Its filename was
     kmap-leak-fix-for-x86_32-kdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
make-smart-battery-system-depend-on-acpi_sbs.patch
