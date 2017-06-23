From: akpm@linux-foundation.org
Subject: [patch 4/8] fs/dax.c: fix inefficiency in
 dax_writeback_mapping_range()
Date: Fri, 23 Jun 2017 15:08:46 -0700
Message-ID: <594d916e.9lyXOgTQKWAveym4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754466AbdFWWIr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org

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
