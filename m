From: akpm@linux-foundation.org
Subject: [merged]
 mm-change-confusing-ifdef-use-in-__access_remote_vm.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:06:35 -0700
Message-ID: <53e3dc4b.AfpnSwSI8imiCv9J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:57262 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHGUGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:36 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so879256igi.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change confusing #ifdef use in __access_remote_vm
has been removed from the -mm tree.  Its filename was
     mm-change-confusing-ifdef-use-in-__access_remote_vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: change confusing #ifdef use in __access_remote_vm

This patch changes confusing #ifdef use in __access_remote_vm
into merely ugly #ifdef use.

Addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=81651

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-change-confusing-ifdef-use-in-__access_remote_vm mm/memory.c
--- a/mm/memory.c~mm-change-confusing-ifdef-use-in-__access_remote_vm
+++ a/mm/memory.c
@@ -3613,11 +3613,13 @@ static int __access_remote_vm(struct tas
 		ret = get_user_pages(tsk, mm, addr, 1,
 				write, 1, &page, &vma);
 		if (ret <= 0) {
+#ifndef CONFIG_HAVE_IOREMAP_PROT
+			break;
+#else
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
 			 */
-#ifdef CONFIG_HAVE_IOREMAP_PROT
 			vma = find_vma(mm, addr);
 			if (!vma || vma->vm_start > addr)
 				break;
@@ -3625,9 +3627,9 @@ static int __access_remote_vm(struct tas
 				ret = vma->vm_ops->access(vma, addr, buf,
 							  len, write);
 			if (ret <= 0)
-#endif
 				break;
 			bytes = ret;
+#endif
 		} else {
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

