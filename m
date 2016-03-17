From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:57:31 -0700
Message-ID: <56eb1a3b.SwzQX5wf5SGzPmQD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965087AbcCQU5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, aarcange@redhat.com, hannes@cmpxchg.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: Set THP defrag by default to madvise and add a stall-free defrag option -fix
has been removed from the -mm tree.  Its filename was
     mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix.patch

This patch was dropped because it was folded into mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: thp: Set THP defrag by default to madvise and add a stall-free defrag option -fix

The following is a fix to the patch
mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option.patch
based on feedback from Vlastimil Babka.  It removes an unnecessary
VM_BUG_ON for tidyness, clarifies documentation and adds a check
forbidding someone writing "defer" to the enable knob for transparent huge
pages.  The ack from Vlastimil applies for the original patch plus this
fix combined.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    2 +-
 mm/huge_memory.c               |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/transhuge.txt~mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix
+++ a/Documentation/vm/transhuge.txt
@@ -129,7 +129,7 @@ available in the near future. It's the r
 to then install the THP pages later.
 
 "madvise" will enter direct reclaim like "always" but only for regions
-that are have used madvise(). This is the default behaviour.
+that are have used madvise(MADV_HUGEPAGE). This is the default behaviour.
 
 "never" should be self-explanatory.
 
diff -puN mm/huge_memory.c~mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option-fix
+++ a/mm/huge_memory.c
@@ -279,6 +279,8 @@ static ssize_t triple_flag_store(struct
 {
 	if (!memcmp("defer", buf,
 		    min(sizeof("defer")-1, count))) {
+		if (enabled == deferred)
+			return -EINVAL;
 		clear_bit(enabled, &transparent_hugepage_flags);
 		clear_bit(req_madv, &transparent_hugepage_flags);
 		set_bit(deferred, &transparent_hugepage_flags);
@@ -306,10 +308,9 @@ static ssize_t triple_flag_store(struct
 static ssize_t enabled_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
 {
-	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags)) {
-		VM_BUG_ON(test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags));
+	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags))
 		return sprintf(buf, "[always] madvise never\n");
-	} else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags))
+	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags))
 		return sprintf(buf, "always [madvise] never\n");
 	else
 		return sprintf(buf, "always madvise [never]\n");
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-thp-set-thp-defrag-by-default-to-madvise-and-add-a-stall-free-defrag-option.patch

