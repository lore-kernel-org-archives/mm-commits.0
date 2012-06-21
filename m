From: akpm@linux-foundation.org
Subject: + mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch added to -mm tree
Date: Thu, 21 Jun 2012 16:58:04 -0700
Message-ID: <20120621235804.BA5BDA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39762 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab2FUX6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 19:58:07 -0400
Received: by vbnl22 with SMTP id l22so144127vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 16:58:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, dhillf@gmail.com, gaowanlong@cn.fujitsu.com, hughd@google.com, normalperson@yhbt.net


The patch titled
     Subject: mm, fadvise: don't return -EINVAL when filesystem cannot implement fadvise()
has been added to the -mm tree.  Its filename is
     mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm, fadvise: don't return -EINVAL when filesystem cannot implement fadvise()

Eric Wong reported his test suite failex when /tmp is tmpfs.

https://lkml.org/lkml/2012/2/24/479

Currentlt the input check of POSIX_FADV_WILLNEED has two problems.

- requires a_ops->readpage.  But in fact, force_page_cache_readahead()
  requires that the target filesystem has either ->readpage or ->readpages.

- returns -EINVAL when the filesystem doesn't have ->readpage.  But
  posix says that fadvise is merely a hint.  Thus fadvise() should return
  0 if filesystem has no means of implementing fadvise().  The userland
  application should not know nor care whcih type of filesystem backs the
  TMPDIR directory, as Eric pointed out.  There is nothing which userspace
  can do to solve this error.

So change the return value to 0 when filesytem doesn't support
  readahead.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Eric Wong <normalperson@yhbt.net>
Tested-by: Eric Wong <normalperson@yhbt.net>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise
+++ a/mm/fadvise.c
@@ -93,11 +93,6 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
-		if (!mapping->a_ops->readpage) {
-			ret = -EINVAL;
-			break;
-		}
-
 		/* First and last PARTIAL page! */
 		start_index = offset >> PAGE_CACHE_SHIFT;
 		end_index = endbyte >> PAGE_CACHE_SHIFT;
@@ -106,12 +101,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		nrpages = end_index - start_index + 1;
 		if (!nrpages)
 			nrpages = ~0UL;
-		
-		ret = force_page_cache_readahead(mapping, file,
-				start_index,
-				nrpages);
-		if (ret > 0)
-			ret = 0;
+
+		/*
+		 * Ignore return value because fadvise() shall return 
+		 * success even if filesystem can't retrieve a hint,
+		 */		
+		force_page_cache_readahead(mapping, file, start_index,
+					   nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
_
Subject: Subject: mm, fadvise: don't return -EINVAL when filesystem cannot implement fadvise()

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch

