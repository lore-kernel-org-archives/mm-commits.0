From: akpm@linux-foundation.org
Subject: + doc-thp-cow-fault-no-longer-allocate-thp.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 14:06:14 -0700
Message-ID: <20200617210614.nicVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgFQVGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, kirill.shutemov@linux.intel.com, corbet@lwn.net, yang.shi@linux.alibaba.com


The patch titled
     Subject: doc: THP CoW fault no longer allocate THP
has been added to the -mm tree.  Its filename is
     doc-thp-cow-fault-no-longer-allocate-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-thp-cow-fault-no-longer-allocate-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-thp-cow-fault-no-longer-allocate-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: doc: THP CoW fault no longer allocate THP

Since commit 3917c80280c93a7123f ("thp: change CoW semantics for
anon-THP"), THP CoW page fault is rewritten.  Now it just splits pmd then
fallback to base page fault, it doesn't try to allocate THP anymore.  So
it is no longer counted in THP_FAULT_ALLOC.

Remove the obsolete statement in documentation about THP CoW allocation to
avoid confusion.

Link: http://lkml.kernel.org/r/1592424895-5421-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst    |    4 ++--
 Documentation/admin-guide/mm/transhuge.rst |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~doc-thp-cow-fault-no-longer-allocate-thp
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1356,8 +1356,8 @@ PAGE_SIZE multiple when read back.
 
 	  thp_fault_alloc
 		Number of transparent hugepages which were allocated to satisfy
-		a page fault, including COW faults. This counter is not present
-		when CONFIG_TRANSPARENT_HUGEPAGE is not set.
+		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
+                is not set.
 
 	  thp_collapse_alloc
 		Number of transparent hugepages which were allocated to allow
--- a/Documentation/admin-guide/mm/transhuge.rst~doc-thp-cow-fault-no-longer-allocate-thp
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -305,8 +305,7 @@ monitor how successfully the system is p
 
 thp_fault_alloc
 	is incremented every time a huge page is successfully
-	allocated to handle a page fault. This applies to both the
-	first time a page is faulted and for COW faults.
+	allocated to handle a page fault.
 
 thp_collapse_alloc
 	is incremented by khugepaged when it has found
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

doc-thp-cow-fault-no-longer-allocate-thp.patch
mm-thp-remove-debug_cow-switch.patch
