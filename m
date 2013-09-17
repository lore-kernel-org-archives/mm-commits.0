From: akpm@linux-foundation.org
Subject: +
 mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch added to -mm tree
Date: Tue, 17 Sep 2013 15:56:56 -0700
Message-ID: <5238de38.XTeY7QLPC1v5HGih%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IQW45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 18:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, gang.chen@asianux.com

Subject: + mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch added to -mm tree
To: gang.chen@asianux.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 15:56:56 -0700


The patch titled
     Subject: mm/readahead.c: return the value which force_page_cache_readahead() returns
has been added to the -mm tree.  Its filename is
     mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/readahead.c: return the value which force_page_cache_readahead() returns

force_page_cache_readahead() may fail, so let the related upper system
calls know about it by its return value.

For system call fadvise64_64(), ignore return value because fadvise()
shall return success even if filesystem can't retrieve a hint.


(akpm: actually, force_page_cache_readahead() cannot fail - I see no code
path via which it returns a -ve errno.

Of course, that might change in the future and although readahead is
usually a best-effort-dont-care-if-it-fails thing, I suppose that in
the case of madvise() and sys_readahead() we should inform userspace,
as readhead is the primary reason for thier performing the syscall.)

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

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch

