From: akpm@linux-foundation.org
Subject: + mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
 added to -mm tree
Date: Thu, 19 Jun 2014 13:40:47 -0700
Message-ID: <53a34acf.Dk9B2n4zm2Gvmn9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbaFSUkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 16:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, zhenzhang.zhang@huawei.com


The patch titled
     Subject: mm/mem-hotplug: replace simple_strtoull() with kstrtoull()
has been added to the -mm tree.  Its filename is
     mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/mem-hotplug: replace simple_strtoull() with kstrtoull()

use the newer and more pleasant kstrtoull() to replace simple_strtoull(),
because simple_strtoull() is marked for obsoletion.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: David Rientjes <rientjes@google.com>
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

mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
linux-next.patch

