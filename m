From: akpm@linux-foundation.org
Subject: + uml-64-bit-tlb-fixes.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:47:36 -0800
Message-ID: <200712061947.lB6JlatS008676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422AbXLFTrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: 64-bit tlb fixes
has been added to the -mm tree.  Its filename is
     uml-64-bit-tlb-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: 64-bit tlb fixes
From: Jeff Dike <jdike@addtoit.com>

Some 64-bit tlb fixes -
	moved pmd_page_vaddr to pgtable.h since it's the same for both
2-level and 3-level page tables
	fixed a bogus cast on pud_page_vaddr
	made the address checking in update_*_range more careful

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c            |    8 ++++----
 include/asm-um/pgtable-2level.h |    3 ---
 include/asm-um/pgtable-3level.h |    3 +--
 include/asm-um/pgtable.h        |    3 +++
 4 files changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/um/kernel/tlb.c~uml-64-bit-tlb-fixes arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-64-bit-tlb-fixes
+++ a/arch/um/kernel/tlb.c
@@ -207,7 +207,7 @@ static inline int update_pte_range(pmd_t
 		} else if (pte_newprot(*pte))
 			ret = add_mprotect(addr, PAGE_SIZE, prot, hvc);
 		*pte = pte_mkuptodate(*pte);
-	} while (pte++, addr += PAGE_SIZE, ((addr != end) && !ret));
+	} while (pte++, addr += PAGE_SIZE, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -229,7 +229,7 @@ static inline int update_pmd_range(pud_t
 			}
 		}
 		else ret = update_pte_range(pmd, addr, next, hvc);
-	} while (pmd++, addr = next, ((addr != end) && !ret));
+	} while (pmd++, addr = next, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -251,7 +251,7 @@ static inline int update_pud_range(pgd_t
 			}
 		}
 		else ret = update_pmd_range(pud, addr, next, hvc);
-	} while (pud++, addr = next, ((addr != end) && !ret));
+	} while (pud++, addr = next, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -274,7 +274,7 @@ void fix_range_common(struct mm_struct *
 			}
 		}
 		else ret = update_pud_range(pgd, addr, next, &hvc);
-	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
+	} while (pgd++, addr = next, ((addr < end_addr) && !ret));
 
 	if (!ret)
 		ret = do_ops(&hvc, hvc.index, 1);
diff -puN include/asm-um/pgtable-2level.h~uml-64-bit-tlb-fixes include/asm-um/pgtable-2level.h
--- a/include/asm-um/pgtable-2level.h~uml-64-bit-tlb-fixes
+++ a/include/asm-um/pgtable-2level.h
@@ -41,9 +41,6 @@ static inline void pgd_mkuptodate(pgd_t 
 #define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
-#define pmd_page_vaddr(pmd) \
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
 /*
  * Bits 0 through 4 are taken
  */
diff -puN include/asm-um/pgtable-3level.h~uml-64-bit-tlb-fixes include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-64-bit-tlb-fixes
+++ a/include/asm-um/pgtable-3level.h
@@ -87,8 +87,7 @@ static inline void pud_clear (pud_t *pud
 }
 
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
-#define pud_page_vaddr(pud) \
-	((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
 /* Find an entry in the second-level page table.. */
 #define pmd_offset(pud, address) ((pmd_t *) pud_page_vaddr(*(pud)) + \
diff -puN include/asm-um/pgtable.h~uml-64-bit-tlb-fixes include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-64-bit-tlb-fixes
+++ a/include/asm-um/pgtable.h
@@ -308,6 +308,9 @@ static inline pte_t pte_modify(pte_t pte
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
+#define pmd_page_vaddr(pmd) \
+	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
 /*
  * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
  *
_

Patches currently in -mm which might be from jdike@addtoit.com are

aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
git-kvm.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-customize-tlbh.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
