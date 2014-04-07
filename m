From: akpm@linux-foundation.org
Subject: + autofs4-check-dev-ioctl-size-before-allocating.patch added to
 -mm tree
Date: Mon, 07 Apr 2014 12:03:44 -0700
Message-ID: <5342f690.HEJkeikn7+ZYH0yE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaDGTDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 15:03:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, sasha.levin@oracle.com

Subject: + autofs4-check-dev-ioctl-size-before-allocating.patch added to -mm tree
To: sasha.levin@oracle.com,raven@themaw.net
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 12:03:44 -0700


The patch titled
     Subject: autofs4: check dev ioctl size before allocating
has been added to the -mm tree.  Its filename is
     autofs4-check-dev-ioctl-size-before-allocating.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-check-dev-ioctl-size-before-allocating.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-check-dev-ioctl-size-before-allocating.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: autofs4: check dev ioctl size before allocating

There wasn't any check of the size passed from userspace before
trying to allocate the memory required.

This meant that userspace might request more space than allowed,
triggering an OOM.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-check-dev-ioctl-size-before-allocating fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-check-dev-ioctl-size-before-allocating
+++ a/fs/autofs4/dev-ioctl.c
@@ -103,6 +103,9 @@ static struct autofs_dev_ioctl *copy_dev
 	if (tmp.size < sizeof(tmp))
 		return ERR_PTR(-EINVAL);
 
+	if (tmp.size > (PATH_MAX + sizeof(tmp)))
+		return ERR_PTR(-ENAMETOOLONG);
+
 	return memdup_user(in, tmp.size);
 }
 
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
autofs4-check-dev-ioctl-size-before-allocating.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-per-thread-vma-caching-fix-5.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
mm-page_allocc-change-mm-debug-routines-back-to-export_symbol.patch
zram-delete-zram_init_device-fix.patch
zram-move-comp-allocation-out-of-init_lock.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

