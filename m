From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch removed from -mm
 tree
Date: Wed, 21 Jun 2017 15:05:40 -0700
Message-ID: <20170621220540.A7HEGOVNe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFUWFl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2017 18:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jack@suse.cz, jlayton@redhat.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com


The patch titled
     Subject: mm: fix mapping_set_error call in me_pagecache_dirty
has been removed from the -mm tree.  Its filename was
     mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: mm: fix mapping_set_error call in me_pagecache_dirty

The error code should be negative.  Since this ends up in the default case
anyway, this is harmless, but it's less confusing to negate it.  Also,
later patches will require a negative error code here.

Link: http://lkml.kernel.org/r/20170525103355.6760-1-jlayton@redhat.com
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-fix-mapping_set_error-call-in-me_pagecache_dirty mm/memory-failure.c
--- a/mm/memory-failure.c~mm-fix-mapping_set_error-call-in-me_pagecache_dirty
+++ a/mm/memory-failure.c
@@ -684,7 +684,7 @@ static int me_pagecache_dirty(struct pag
 		 * the first EIO, but we're not worse than other parts
 		 * of the kernel.
 		 */
-		mapping_set_error(mapping, EIO);
+		mapping_set_error(mapping, -EIO);
 	}
 
 	return me_pagecache_clean(p, pfn);
_

Patches currently in -mm which might be from jlayton@redhat.com are


