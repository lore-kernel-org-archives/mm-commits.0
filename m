From: akpm@linux-foundation.org
Subject: + dax-fix-inefficiency-in-dax_writeback_mapping_range.patch added to -mm tree
Date: Mon, 19 Jun 2017 15:22:26 -0700
Message-ID: <59484ea2.ULJvjYft9m86Sc6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdFSWW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 18:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dax.c: fix inefficiency in dax_writeback_mapping_range()
has been added to the -mm tree.  Its filename is
     dax-fix-inefficiency-in-dax_writeback_mapping_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-inefficiency-in-dax_writeback_mapping_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-inefficiency-in-dax_writeback_mapping_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dax-fix-inefficiency-in-dax_writeback_mapping_range.patch
mm-fix-thp-handling-in-invalidate_mapping_pages.patch

