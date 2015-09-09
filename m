From: akpm@linux-foundation.org
Subject: [merged]
 mm-improve-__gfp_noretry-comment-based-on-implementation.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:44:13 -0700
Message-ID: <55f08c0d.qWUsUh/4uCUvf0s3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbbIIToN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve __GFP_NORETRY comment based on implementation
has been removed from the -mm tree.  Its filename was
     mm-improve-__gfp_noretry-comment-based-on-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: improve __GFP_NORETRY comment based on implementation

Explicitly state that __GFP_NORETRY will attempt direct reclaim and memory
compaction before returning NULL and that the oom killer is not called in
the current implementation of the page allocator.

[akpm@linux-foundation.org: s/has/have/]
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation include/linux/gfp.h
--- a/include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation
+++ a/include/linux/gfp.h
@@ -63,7 +63,10 @@ struct vm_area_struct;
  * but it is definitely preferable to use the flag rather than opencode endless
  * loop around allocator.
  *
- * __GFP_NORETRY: The VM implementation must not retry indefinitely.
+ * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
+ * return NULL when direct reclaim and memory compaction have failed to allow
+ * the allocation to succeed.  The OOM killer is not called with the current
+ * implementation.
  *
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
  * mechanism or reclaimed
_

Patches currently in -mm which might be from rientjes@google.com are


