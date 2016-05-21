From: akpm@linux-foundation.org
Subject: [patch 129/162] drivers/hwspinlock: use correct radix tree API
Date: Fri, 20 May 2016 17:03:01 -0700
Message-ID: <573fa5b5.KcvsRXZw2iTeg5l+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcEUADC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: drivers/hwspinlock: use correct radix tree API

radix_tree_is_indirect_ptr() is an internal API.  The correct call to use
is radix_tree_deref_retry() which has the appropriate unlikely()
annotation.

Fixes: c6400ba7e13a ("drivers/hwspinlock: fix race between radix tree insertion and lookup")
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwspinlock/hwspinlock_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwspinlock/hwspinlock_core.c~drivers-hwspinlock-use-correct-radix-tree-api drivers/hwspinlock/hwspinlock_core.c
--- a/drivers/hwspinlock/hwspinlock_core.c~drivers-hwspinlock-use-correct-radix-tree-api
+++ a/drivers/hwspinlock/hwspinlock_core.c
@@ -313,7 +313,7 @@ int of_hwspin_lock_get_id(struct device_
 		hwlock = radix_tree_deref_slot(slot);
 		if (unlikely(!hwlock))
 			continue;
-		if (radix_tree_is_indirect_ptr(hwlock)) {
+		if (radix_tree_deref_retry(hwlock)) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
_
