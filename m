From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix.patch removed from
 -mm tree
Date: Tue, 10 Feb 2015 14:02:49 -0800
Message-ID: <54da8009.xDrK8weoKotakFYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbbBJWCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 17:02:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dan.carpenter@oracle.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix static checker warning
has been removed from the -mm tree.  Its filename was
     mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix.patch

This patch was dropped because it was folded into mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: memcg: fix static checker warning

The patch "mm: remove rest usage of VM_NONLINEAR and pte_file()" from
Jan 17, 2015, leads to the following static checker warning:

        mm/memcontrol.c:4794 mc_handle_file_pte()
        warn: passing uninitialized 'pgoff'

After the patch, the only case when mc_handle_file_pte() called is
pte_none(ptent). The 'if' check is redundant and lead to the warning.
Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix
+++ a/mm/memcontrol.c
@@ -4926,8 +4926,7 @@ static struct page *mc_handle_file_pte(s
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
-	if (pte_none(ptent))
-		pgoff = linear_page_index(vma, addr);
+	pgoff = linear_page_index(vma, addr);
 
 	/* page is moved even if it's not RSS of this task(page-faulted). */
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

hugetlb-x86-register-1g-page-size-if-we-can-allocate-them-runtime.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers-fix.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch

