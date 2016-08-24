From: akpm@linux-foundation.org
Subject: + mm-silently-skip-readahead-for-dax-inodes.patch added to -mm
 tree
Date: Wed, 24 Aug 2016 15:49:02 -0700
Message-ID: <57be245e.IBe4TcIQR4NEWjLt%akpm__17397.4803103649$1472078978$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757043AbcHXWtR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2016 18:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, jack@suse.com, jmoyer@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: silently skip readahead for DAX inodes
has been added to the -mm tree.  Its filename is
     mm-silently-skip-readahead-for-dax-inodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-silently-skip-readahead-for-dax-inodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-silently-skip-readahead-for-dax-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm: silently skip readahead for DAX inodes

For DAX inodes we need to be careful to never have page cache pages in the
mapping->page_tree.  This radix tree should be composed only of DAX
exceptional entries and zero pages.

ltp's readahead02 test was triggering a warning because we were trying to
insert a DAX exceptional entry but found that a page cache page had
already been inserted into the tree.  This page was being inserted into
the radix tree in response to a readahead(2) call.

Readahead doesn't make sense for DAX inodes, but we don't want it to report
a failure either.  Instead, we just return success and don't do any work.

Link: http://lkml.kernel.org/r/20160824221429.21158-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/readahead.c~mm-silently-skip-readahead-for-dax-inodes mm/readahead.c
--- a/mm/readahead.c~mm-silently-skip-readahead-for-dax-inodes
+++ a/mm/readahead.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/dax.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/blkdev.h>
@@ -544,6 +545,14 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
+	/*
+	 * Readahead doesn't make sense for DAX inodes, but we don't want it
+	 * to report a failure either.  Instead, we just return success and
+	 * don't do any work.
+	 */
+	if (dax_mapping(mapping))
+		return 0;
+
 	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-silently-skip-readahead-for-dax-inodes.patch
radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch
radix-tree-tests-add-iteration-test.patch
radix-tree-tests-properly-initialize-mutex.patch

