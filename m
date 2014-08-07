From: akpm@linux-foundation.org
Subject: [merged]
 mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:04:41 -0700
Message-ID: <53e3dbd9.XE5z7UsAei5zII6i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:56255 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:42 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so607098qgd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mem-hotplug: replace simple_strtoull() with kstrtoull()
has been removed from the -mm tree.  Its filename was
     mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/mem-hotplug: replace simple_strtoull() with kstrtoull()

use the newer and more pleasant kstrtoull() to replace simple_strtoull(),
because simple_strtoull() is marked for obsoletion.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull drivers/base/memory.c
--- a/drivers/base/memory.c~mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull
+++ a/drivers/base/memory.c
@@ -406,7 +406,9 @@ memory_probe_store(struct device *dev, s
 	int i, ret;
 	unsigned long pages_per_block = PAGES_PER_SECTION * sections_per_block;
 
-	phys_addr = simple_strtoull(buf, NULL, 0);
+	ret = kstrtoull(buf, 0, &phys_addr);
+	if (ret)
+		return ret;
 
 	if (phys_addr & ((pages_per_block << PAGE_SHIFT) - 1))
 		return -EINVAL;
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

origin.patch

