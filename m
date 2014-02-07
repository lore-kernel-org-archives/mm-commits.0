From: akpm@linux-foundation.org
Subject: + mm-page_cgroupc-mark-functions-as-static.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 14:31:28 -0800
Message-ID: <52f55ec0.P/HV/8ZypARhZewa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGWb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:31:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + mm-page_cgroupc-mark-functions-as-static.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:31:28 -0800


The patch titled
     Subject: mm/page_cgroup.c: mark functions as static
has been added to the -mm tree.  Its filename is
     mm-page_cgroupc-mark-functions-as-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_cgroupc-mark-functions-as-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_cgroupc-mark-functions-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/page_cgroup.c: mark functions as static

Mark functions as static in page_cgroup.c because they are not used
outside this file.

This eliminates the following warning in mm/page_cgroup.c:
mm/page_cgroup.c:177:6: warning: no previous prototype for `__free_page_cgroup' [-Wmissing-prototypes]
mm/page_cgroup.c:190:15: warning: no previous prototype for `online_page_cgroup' [-Wmissing-prototypes]
mm/page_cgroup.c:225:15: warning: no previous prototype for `offline_page_cgroup' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_cgroup.c~mm-page_cgroupc-mark-functions-as-static mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroupc-mark-functions-as-static
+++ a/mm/page_cgroup.c
@@ -175,7 +175,7 @@ static void free_page_cgroup(void *addr)
 	}
 }
 
-void __free_page_cgroup(unsigned long pfn)
+static void __free_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *ms;
 	struct page_cgroup *base;
@@ -188,9 +188,9 @@ void __free_page_cgroup(unsigned long pf
 	ms->page_cgroup = NULL;
 }
 
-int __meminit online_page_cgroup(unsigned long start_pfn,
-			unsigned long nr_pages,
-			int nid)
+static int __meminit online_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages,
+				int nid)
 {
 	unsigned long start, end, pfn;
 	int fail = 0;
@@ -223,8 +223,8 @@ int __meminit online_page_cgroup(unsigne
 	return -ENOMEM;
 }
 
-int __meminit offline_page_cgroup(unsigned long start_pfn,
-		unsigned long nr_pages, int nid)
+static int __meminit offline_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages, int nid)
 {
 	unsigned long start, end, pfn;
 
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch

