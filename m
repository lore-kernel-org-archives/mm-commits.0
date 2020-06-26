From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 24/32] doc: THP CoW fault no longer allocate THP
Date: Thu, 25 Jun 2020 20:30:28 -0700
Message-ID: <20200626033028.Z6nJq9s5E%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgFZDa3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:29 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yang.shi@linux.alibaba.com, ziy@nvidia.com

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
