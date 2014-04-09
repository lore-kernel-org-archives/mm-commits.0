From: akpm@linux-foundation.org
Subject: [merged] autofs4-check-dev-ioctl-size-before-allocating.patch
 removed from -mm tree
Date: Wed, 09 Apr 2014 10:55:31 -0700
Message-ID: <53458993.X1oJ8P69/58Otutw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIRzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, sasha.levin@oracle.com

Subject: [merged] autofs4-check-dev-ioctl-size-before-allocating.patch removed from -mm tree
To: sasha.levin@oracle.com,raven@themaw.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:55:31 -0700


The patch titled
     Subject: autofs4: check dev ioctl size before allocating
has been removed from the -mm tree.  Its filename was
     autofs4-check-dev-ioctl-size-before-allocating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

