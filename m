From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-compile-error-on-tile.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:34 -0800
Message-ID: <569e98ee.TkRY+MyKPb2kA3YU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbcASUNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dhowells@redhat.com, liviu.dudau@arm.com, lorenzo.pieralisi@arm.com, sudeep.holla@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix compile error on tile
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-compile-error-on-tile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: hugetlb: fix compile error on tile

Inlude asm/pgtable.h to get the definition for pud_t to fix:

include/linux/hugetlb.h:203:29: error: unknown type name 'pud_t'

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/hugetlb.h~hugetlb-fix-compile-error-on-tile include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-fix-compile-error-on-tile
+++ a/include/linux/hugetlb.h
@@ -8,6 +8,7 @@
 #include <linux/cgroup.h>
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <asm/pgtable.h>
 
 struct ctl_table;
 struct user_struct;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

