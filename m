From: akpm@linux-foundation.org
Subject: +
 mm-mmapc-change-static-function-__install_special_mapping-args-order.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 14:12:29 -0700
Message-ID: <5612e7bd.1B9hvc03r70RMhMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbJEVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: change __install_special_mapping() args order
has been added to the -mm tree.  Its filename is
     mm-mmapc-change-static-function-__install_special_mapping-args-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-change-static-function-__install_special_mapping-args-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-change-static-function-__install_special_mapping-args-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: change __install_special_mapping() args order

Make __install_special_mapping() args order match the caller, so the
caller can pass their register args directly to callee with no touch.

For most of architectures, args (at least the first 5th args) are in
registers, so this change will have effect on most of architectures.

For -O2, __install_special_mapping() may be inlined under most of
architectures, but for -Os, it should not. So this change can get a
little better performance for -Os, at least.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-change-static-function-__install_special_mapping-args-order mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-change-static-function-__install_special_mapping-args-order
+++ a/mm/mmap.c
@@ -3052,8 +3052,8 @@ static int special_mapping_fault(struct
 static struct vm_area_struct *__install_special_mapping(
 	struct mm_struct *mm,
 	unsigned long addr, unsigned long len,
-	unsigned long vm_flags, const struct vm_operations_struct *ops,
-	void *priv)
+	unsigned long vm_flags, void *priv,
+	const struct vm_operations_struct *ops)
 {
 	int ret;
 	struct vm_area_struct *vma;
@@ -3102,8 +3102,8 @@ struct vm_area_struct *_install_special_
 	unsigned long addr, unsigned long len,
 	unsigned long vm_flags, const struct vm_special_mapping *spec)
 {
-	return __install_special_mapping(mm, addr, len, vm_flags,
-					 &special_mapping_vmops, (void *)spec);
+	return __install_special_mapping(mm, addr, len, vm_flags, (void *)spec,
+					&special_mapping_vmops);
 }
 
 int install_special_mapping(struct mm_struct *mm,
@@ -3111,8 +3111,8 @@ int install_special_mapping(struct mm_st
 			    unsigned long vm_flags, struct page **pages)
 {
 	struct vm_area_struct *vma = __install_special_mapping(
-		mm, addr, len, vm_flags, &legacy_special_mapping_vmops,
-		(void *)pages);
+		mm, addr, len, vm_flags, (void *)pages,
+		&legacy_special_mapping_vmops);
 
 	return PTR_ERR_OR_ZERO(vma);
 }
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch
mm-mmapc-change-static-function-__install_special_mapping-args-order.patch

