From: akpm@osdl.org
Subject: + kvm-fix-bogus-pagefault-on-writable-pages.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:07:49 -0800
Message-ID: <200701112107.l0BL7nrE003067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXAKVIS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: fix bogus pagefault on writable pages
has been added to the -mm tree.  Its filename is
     kvm-fix-bogus-pagefault-on-writable-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

kvm-add-vm-exit-profiling.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
