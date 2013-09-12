From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:37 -0700
Message-ID: <523219e1.VkOmr0DF9Xns74yB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3ILTpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:37 -0700


The patch titled
     Subject: mm/hwpoison-inject.c: change permission of corrupt-pfn/unpoison-pfn to 0200
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison-inject.c: change permission of corrupt-pfn/unpoison-pfn to 0200

Hwpoison injection doesn't implement read method for
corrupt-pfn/unpoison-pfn attributes:

# cat /sys/kernel/debug/hwpoison/corrupt-pfn
cat: /sys/kernel/debug/hwpoison/corrupt-pfn: Permission denied
# cat /sys/kernel/debug/hwpoison/unpoison-pfn
cat: /sys/kernel/debug/hwpoison/unpoison-pfn: Permission denied

This patch changes the permission of corrupt-pfn/unpoison-pfn to 0200.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200 mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200
+++ a/mm/hwpoison-inject.c
@@ -88,12 +88,12 @@ static int pfn_inject_init(void)
 	 * hardware status change, hence do not require hardware support.
 	 * They are mainly for testing hwpoison in software level.
 	 */
-	dentry = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("corrupt-pfn", 0200, hwpoison_dir,
 					  NULL, &hwpoison_fops);
 	if (!dentry)
 		goto fail;
 
-	dentry = debugfs_create_file("unpoison-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("unpoison-pfn", 0200, hwpoison_dir,
 				     NULL, &unpoison_fops);
 	if (!dentry)
 		goto fail;
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

