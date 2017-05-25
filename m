From: akpm@linux-foundation.org
Subject: + mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch added to -mm tree
Date: Thu, 25 May 2017 16:11:26 -0700
Message-ID: <5927649e.rusbG2Qwi8wI4F1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163136AbdEYXL1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mapping_set_error call in me_pagecache_dirty
has been added to the -mm tree.  Its filename is
     mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-drop-wait-parameter-from-write_one_page.patch
mm-fix-mapping_set_error-call-in-me_pagecache_dirty.patch

