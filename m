From: akpm@osdl.org
Subject: - kvm-fix-bogus-pagefault-on-writable-pages.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:30 -0800
Message-ID: <200701260751.l0Q7pU4T010730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030802AbXAZHvd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: fix bogus pagefault on writable pages
has been removed from the -mm tree.  Its filename was
     kvm-fix-bogus-pagefault-on-writable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: fix bogus pagefault on writable pages
From: Avi Kivity <avi@qumranet.com>

If a page is marked as dirty in the guest pte, set_pte_common() can set the
writable bit on newly-instantiated shadow pte.  This optimization avoids
a write fault after the initial read fault.

However, if a write fault instantiates the pte, fix_write_pf() incorrectly
reports the fault as a guest page fault, and the guest oopses on what appears
to be a correctly-mapped page.

Fix is to detect the condition and only report a guest page fault on a user
access to a kernel page.

With the fix, a kvm guest can survive a whole night of running the kernel
hacker's screensaver (make -j9 in a loop).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-fix-bogus-pagefault-on-writable-pages drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-fix-bogus-pagefault-on-writable-pages
+++ a/drivers/kvm/paging_tmpl.h
@@ -274,7 +274,7 @@ static int FNAME(fix_write_pf)(struct kv
 	struct kvm_mmu_page *page;
 
 	if (is_writeble_pte(*shadow_ent))
-		return 0;
+		return !user || (*shadow_ent & PT_USER_MASK);
 
 	writable_shadow = *shadow_ent & PT_SHADOW_WRITABLE_MASK;
 	if (user) {
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-svm-fix-svm-idt-confusion.patch
kvm-emulate-ia32_misc_enable-msr.patch
kvm-mmu-perform-access-checks-in-walk_addr.patch
kvm-mmu-report-nx-faults-to-the-guest.patch
kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
