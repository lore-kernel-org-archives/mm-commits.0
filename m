From: akpm@linux-foundation.org
Subject: + dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch
 added to -mm tree
Date: Tue, 14 Mar 2017 14:57:31 -0700
Message-ID: <58c8674b.PYg3aRLz18OmiR1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdCNV5d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, mawilcox@microsoft.com, mingo@redhat.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, xzhou@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix regression in dax_writeback_mapping_range()
has been added to the -mm tree.  Its filename is
     dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch

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
Subject: dax: fix regression in dax_writeback_mapping_range()

commit 354ae7432ee8 ("dax: add tracepoints to
dax_writeback_mapping_range()") in the -next tree, which appears in
next-20170310, inadvertently changed dax_writeback_mapping_range() so that
it could end up returning a positive value: the number of bytes flushed,
as returned by dax_writeback_one().  This was incorrect.  This function
either needs to return a negative error value, or zero on success.

This change was causing xfstest failures, as reported by Xiong:

https://lkml.org/lkml/2017/3/13/1220

With this fix applied to next-20170310, all the test failures reported by
Xiong (generic/075 generic/112 generic/127 generic/231 generic/263) are
resolved.

Link: http://lkml.kernel.org/r/20170314215358.31451-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Xiong Zhou <xzhou@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range-fix fs/dax.c
--- a/fs/dax.c~dax-add-tracepoints-to-dax_writeback_mapping_range-fix
+++ a/fs/dax.c
@@ -906,7 +906,7 @@ int dax_writeback_mapping_range(struct a
 	}
 out:
 	trace_dax_writeback_range_done(inode, start_index, end_index);
-	return ret;
+	return (ret < 0 ? ret : 0);
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-add-tracepoints-to-dax_iomap_pte_fault.patch
dax-add-tracepoints-to-dax_pfn_mkwrite.patch
dax-add-tracepoints-to-dax_load_hole.patch
dax-add-tracepoints-to-dax_writeback_mapping_range.patch
dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch
dax-add-tracepoint-to-dax_writeback_one.patch
dax-add-tracepoint-to-dax_insert_mapping.patch

