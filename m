Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4971C2264C7
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622808; cv=none; b=U+QmmwvKBMEx1mGdwiyb6iECcnb0Pxf+aomVEQj4dobmkrrdjis0t/PPLB9+JocOo9wWnpwaFRWUm5X/yByQXTDCf645u9WYCE71ShSu4bec5w7E+nFZutiQToJRjtR+LsX55z6vIeJWqPJOJOp7AIXjp81tVpzkzbbf9wyQkAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622808; c=relaxed/simple;
	bh=bZe7goO7wLLLsDc1JwFLN8340fuCUTCoTLhMiJo3Zg4=;
	h=Date:To:From:Subject:Message-Id; b=ZjPm6WgDSfR3Yj4GGWbyetLibWzsmX5DZB73vuTnqivVSpRZbKdT6oNDbhBCp8lGJSQmAeNCAv4EZzQNDrpB+8fKzVtClmx8W4ddy+5i22uU5QIcjbD2jShofZFX6Qg0uHX99jkLknZbIT5b/bnkgs70Hb/RBOiS3IgY0UtdK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qH+e6tMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qH+e6tMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8981F00A3D;
	Tue, 25 Aug 2026 01:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622806;
	bh=brFQWxYA06hqEAFRbwyW4ZWLkZomYDIiNW9BAU/OrpM=;
	h=Date:To:From:Subject;
	b=qH+e6tMUUOBdB/1wIL5L9jGX55omLZDbRaH6ATnZ05wdp7+KLh0amNIn4gIWVMzG/
	 qp2655vM0P2+IWN1fHJfdueex2A6tSBPcW89/K7aX6ldoTSEaUtPeJn84UXGNcHali
	 +GIuIm9ZlgvLlNpx5iFu+AtYhkbzl1x3dukwO2MM=
Date: Mon, 24 Aug 2026 18:53:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,gthelen@google.com,david@kernel.org,corbet@lwn.net,anshuman.khandual@arm.com,pratmal@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch removed from -mm tree
Message-Id: <20260825015326.CD8981F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_reporting: add page_reporting_delay_ms module parameter
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-add-page_reporting_delay_ms-module-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Mallick <pratmal@google.com>
Subject: mm/page_reporting: add page_reporting_delay_ms module parameter
Date: Fri, 31 Jul 2026 19:37:05 +0000

Free page reporting currently hardcodes a 2-second interval between
reports.  This rigid delay cannot accommodate diverse guest workloads.

This patch introduces a module parameter, page_reporting_delay_ms
(default: 2000), allowing users to tune the reporting rate:
 - Lower values enable aggressive memory reclamation by returning unused
   pages to the host immediately.
 - Higher values help batch pages during spiky allocation/free churn,
   reducing hypercalls and nested page fault overheads.

Setting the delay to 0 is safe and execution is strictly gated by:
 - reporting is only triggered by high-order page frees.
 - expensive hypercalls are bounded by a slot capacity watermark check
   before proceeding.

Link: https://lore.kernel.org/20260731193705.2902728-1-pratmal@google.com
Signed-off-by: Pratyush Mallick <pratmal@google.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 +++
 mm/page_reporting.c                             |   28 +++++++++-----
 2 files changed, 24 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4810,6 +4810,12 @@ Kernel parameters
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
@@ -57,6 +61,13 @@ enum {
 	PAGE_REPORTING_ACTIVE
 };
 
+/* schedule work for page reporting */
+static void page_reporting_schedule_work(struct page_reporting_dev_info *prdev)
+{
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   msecs_to_jiffies(page_reporting_delay_ms));
+}
+
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -77,12 +88,10 @@ __page_reporting_request(struct page_rep
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
-	queue_delayed_work(system_freezable_wq, &prdev->work,
-			   PAGE_REPORTING_DELAY);
+	page_reporting_schedule_work(prdev);
 }
 
 /* notify prdev of free page reporting request */
@@ -337,13 +346,12 @@ static void page_reporting_process(struc
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
-		queue_delayed_work(system_freezable_wq, &prdev->work,
-				   PAGE_REPORTING_DELAY);
+		page_reporting_schedule_work(prdev);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
_

Patches currently in -mm which might be from pratmal@google.com are


