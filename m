Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FDF26A1C4
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 01:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785201286; cv=none; b=ETjx6qnOM3rLOmN6Jhl5llvsXlJakiw/xUUFLU91+l1YaEjK3C2P0xJgxN1EceyQbdU69nNyo4c2nynba7p21j4AXA6rH5eFRJ0Woi20pze+ht5sQqMW3N2EU3iBCFxLmsttNF1WZsTI6Pe0mYL0GSUw5UwQxOE1SF/3kI/QP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785201286; c=relaxed/simple;
	bh=8FzWt5cQDvFl0boAjLXtEynzyyzMGvDbfYk8xEqTn78=;
	h=Date:To:From:Subject:Message-Id; b=s7KwRiSkgMg3m1uLwGB2Ro5oa9H1aM7XBdG9Mkz5lvXK57QkLHRdkwVdYP9cFDEhCes7m7MIKSaQKWDIeQrpashtaah7OVO24Owh7hnDcwad7LP8vrjnUdq+ypCt55Uwex5mQZKxnSMlcFzpg/yWuWjGGZ2dDwUNUABVWiKVqxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h9KxVEmh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h9KxVEmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1EA1F000E9;
	Tue, 28 Jul 2026 01:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785201285;
	bh=3T+nlmvMykk95VhSx0S7GlVdbc+qwAEs8oU07l8AKm4=;
	h=Date:To:From:Subject;
	b=h9KxVEmhNfDdXMi3hJ68vBqkjEA96sdjnBXwHKMJobRVZZnYSJz2ykY6E1/psI0CN
	 /kD1QmSUKXXFOxweO+vA6Owmk7uVx5KsQUwKewTAOGQWnlT5BgiTFnKnAugtBNsuAW
	 lr0drcLtCi5mX/yKBjOWW8zCGjMQKXu+/71++NWw=
Date: Mon, 27 Jul 2026 18:14:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,linkl@google.com,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,gthelen@google.com,david@kernel.org,corbet@lwn.net,anshuman.khandual@arm.com,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch added to mm-new branch
Message-Id: <20260728011445.0D1EA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: Add page_reporting_delay_ms module parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pratyush Mallick <pratmal@google.com>
Subject: mm/page_reporting: Add page_reporting_delay_ms module parameter
Date: Mon, 27 Jul 2026 23:05:45 +0000

Currently, the free page reporting uses a hardcoded delay of (2 HZ)
between reporting intervals.  While this is a reasonable default, it lacks
the flexibility to adapt to varying guest workloads.

A low delay allows aggressive memory reclamation, returning unused pages
to the host as quickly as possible.  However, during spiky allocation/free
churn, this immediate reporting can lead to a severe performance penalty
(nested page faults) as the guest re-allocates memory that the host has
just unmapped.  In these scenarios, there is benefit from increasing the
delay to batch free pages over a longer window, absorbing the churn
without hypercall and re-fault overhead.

This patch exposes the delay as a module parameter:
/sys/module/page_reporting/parameters/page_reporting_delay_ms, measured in
milliseconds and defaults to 2000ms.

Link: https://lore.kernel.org/20260727230545.262579-1-pratmal@google.com
Signed-off-by: Pratyush Mallick <pratmal@google.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Link Lin <linkl@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 ++++
 mm/page_reporting.c                             |   19 ++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4813,6 +4813,12 @@ Kernel parameters
 			Adjust the minimal page reporting order. The page
 			reporting is disabled when it exceeds MAX_PAGE_ORDER.
 
+	page_reporting.page_reporting_delay_ms=
+			[KNL] Free page reporting delay in milliseconds
+			Format: <unsigned integer>
+			Adjust the delay in milliseconds between free page
+			reporting intervals. Default is 2000 (2 seconds).
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/mm/page_reporting.c
@@ -48,7 +48,11 @@ MODULE_PARM_DESC(page_reporting_order, "
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
+static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
+module_param(page_reporting_delay_ms, uint, 0644);
+MODULE_PARM_DESC(page_reporting_delay_ms,
+		 "Set page reporting delay in milliseconds");
+
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
 enum {
@@ -77,12 +81,11 @@ __page_reporting_request(struct page_rep
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
 	queue_delayed_work(system_freezable_wq, &prdev->work,
-			   PAGE_REPORTING_DELAY);
+			   msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 /* notify prdev of free page reporting request */
@@ -337,13 +340,13 @@ static void page_reporting_process(struc
 err_out:
 	/*
 	 * If the state has reverted back to requested then there may be
-	 * additional pages to be processed. We will defer for 2s to allow
-	 * more pages to accumulate.
+	 * additional pages to be processed. We will defer by
+	 * page_reporting_delay_ms to allow more pages to accumulate.
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
 		queue_delayed_work(system_freezable_wq, &prdev->work,
-				   PAGE_REPORTING_DELAY);
+				   msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
_

Patches currently in -mm which might be from pratmal@google.com are

mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch

