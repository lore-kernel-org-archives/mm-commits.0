From: akpm@linux-foundation.org
Subject: [merged]
 dax-fix-inefficiency-in-dax_writeback_mapping_range.patch removed from -mm
 tree
Date: Mon, 26 Jun 2017 13:22:44 -0700
Message-ID: <20170626202244.wcW1sJlqZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdFZUWp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 16:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.cz, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, stable@vger.kernel.org


The patch titled
     Subject: fs/dax.c: fix inefficiency in dax_writeback_mapping_range()
has been removed from the -mm tree.  Its filename was
     dax-fix-inefficiency-in-dax_writeback_mapping_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs/dax.c: fix inefficiency in dax_writeback_mapping_range()

dax_writeback_mapping_range() fails to update iteration index when
searching radix tree for entries needing cache flushing.  Thus each
pagevec worth of entries is searched starting from the start which is
inefficient and prone to livelocks.  Update index properly.

Link: http://lkml.kernel.org/r/20170619124531.21491-1-jack@suse.cz
Fixes: 9973c98ecfda3 ("dax: add support for fsync/sync")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dax.c~dax-fix-inefficiency-in-dax_writeback_mapping_range fs/dax.c
--- a/fs/dax.c~dax-fix-inefficiency-in-dax_writeback_mapping_range
+++ a/fs/dax.c
@@ -859,6 +859,7 @@ int dax_writeback_mapping_range(struct a
 			if (ret < 0)
 				goto out;
 		}
+		start_index = indices[pvec.nr - 1] + 1;
 	}
 out:
 	put_dax(dax_dev);
_

Patches currently in -mm which might be from jack@suse.cz are

mm-fix-thp-handling-in-invalidate_mapping_pages.patch

