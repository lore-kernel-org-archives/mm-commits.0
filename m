From: akpm@linux-foundation.org
Subject: [merged] dax-dirty-inode-only-if-required.patch removed from -mm
 tree
Date: Wed, 10 Feb 2016 11:36:03 -0800
Message-ID: <56bb9123.9mO7tHYJoxau3Nxx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbcBJTgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, jack@suse.cz, matthew.r.wilcox@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: dirty inode only if required
has been removed from the -mm tree.  Its filename was
     dax-dirty-inode-only-if-required.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: dax: dirty inode only if required

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-dirty-inode-only-if-required fs/dax.c
--- a/fs/dax.c~dax-dirty-inode-only-if-required
+++ a/fs/dax.c
@@ -358,7 +358,8 @@ static int dax_radix_entry(struct addres
 	void *entry;
 
 	WARN_ON_ONCE(pmd_entry && !dirty);
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	if (dirty)
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	spin_lock_irq(&mapping->tree_lock);
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are


