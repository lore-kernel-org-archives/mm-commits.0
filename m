From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch removed from -mm tree
Date: Tue, 15 Oct 2013 15:27:26 -0700
Message-ID: <525dc14e.IYI+xbe7hM/puw+Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab3JOW12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 18:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, gang.chen@asianux.com

Subject: [to-be-updated] mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch removed from -mm tree
To: gang.chen@asianux.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 15:27:26 -0700


The patch titled
     Subject: mm/readahead.c: return the value which force_page_cache_readahead() returns
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/readahead.c: return the value which force_page_cache_readahead() returns

force_page_cache_readahead() may fail, so let the related upper system
calls know about it by its return value.

For system call fadvise64_64(), ignore return value because fadvise()
shall return success even if filesystem can't retrieve a hint.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c   |    4 ++--
 mm/readahead.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/madvise.c~mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns mm/madvise.c
--- a/mm/madvise.c~mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns
+++ a/mm/madvise.c
@@ -247,8 +247,8 @@ static long madvise_willneed(struct vm_a
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping, file, start, end - start);
-	return 0;
+	return force_page_cache_readahead(file->f_mapping, file,
+					start, end - start);
 }
 
 /*
diff -puN mm/readahead.c~mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns
+++ a/mm/readahead.c
@@ -572,8 +572,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
+	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
 SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
_

Patches currently in -mm which might be from gang.chen@asianux.com are

mm-revert-mremap-pud_free-anti-fix.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch

