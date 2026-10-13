Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3090485503
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866032; cv=none; b=E4BTgTwLrwiBXk45T7eXw165StQ20A6QRNViMxogyrGFBYbtl974oQOtHzCm8vQyezomMerkqmDlcIY02iaDGsjNrwlNeNqg6aQbTeiSiTOEFU6AxJvm+C30C9KATfrOQ3Z4DZJ0uRyf/XW9vcVrp6dTjDUYL+WO5mTUs7LGj90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866032; c=relaxed/simple;
	bh=wzKnUXzwJfJF9CcsVwerRrQjZvJ7ZlepAU+4MFjEU9w=;
	h=Date:To:From:Subject:Message-Id; b=RnPNHcqtdvnGP1+HOeaukDoUH0zMhARVeNtgKYwRd5XGNgALap3wyG1J1+7uaM/bi9EgcsXYREpRAWwlJjA3YlogkcUE9O+siAZeZ923xTLpq1nEZJMFwL1hxKzOoxfYV+6Dc7Iz/uWWpcQS/53fgg0ZettBsVgX/WKiNYZ3f4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXN2ksu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXN2ksu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AAC1F000FF;
	Tue, 13 Oct 2026 04:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866027;
	bh=ehhUA3tWwXVE68bz1qSGMa/j69OYEXNcnCrNnOWieYQ=;
	h=Date:To:From:Subject;
	b=cXN2ksu0UcKUnJB6shFGxfAWmTVlGn+ayyNBPYpaaa8M1D16sgPFC0cIM6fdi2XKh
	 ji93zjQSyVZPLDmnwdjBDLX7JAsMHMlkCwNlAtqaxrt5E3ta409KcdIm65sHXQ2OZS
	 mHEU3PO1NN/pxjdQ6l6TfdN45iDupQ3EsPfKeeTc=
Date: Mon, 12 Oct 2026 21:33:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-khugepaged-completion-barrier-helper.patch removed from -mm tree
Message-Id: <20261013043347.C6AAC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add khugepaged completion barrier helper
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-khugepaged-completion-barrier-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add khugepaged completion barrier helper
Date: Sat, 19 Sep 2026 01:24:40 +0100

A khugepaged test has to tell "not collapsed" from "not scanned yet", and
nothing in the selftests can.  wait_for_scan() in khugepaged.c comes
closest: it polls full_scans until the counter has advanced by two, since
the pass in progress may already have passed the test's mm.  But it only
returns in time if scan_sleep_millisecs happens to be short, and it is
private to that one test.

Add khugepaged_full_pass() to hugepage_settings, built on the same
advance-by-two wait but driven through sysfs: a store to
scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
the scan cadence.  A store made while the daemon is scanning rather than
sleeping is lost, so the helper keeps storing until the pass lands.

One wake completes one pass only if pages_to_scan covers every mm on the
list, so callers need it large.

Settings pushes must not start passes of their own.  A store to either
sleep knob wakes the daemon, so thp_write_settings() now writes a
khugepaged knob only when its value changes.

Link: https://lore.kernel.org/20260919002451.496763-11-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/lib/mm/hugepage_settings.c |   60 ++++++++++++++++++++++++-----
 tools/lib/mm/hugepage_settings.h |    2 
 2 files changed, 53 insertions(+), 9 deletions(-)

--- a/tools/lib/mm/hugepage_settings.c~selftests-mm-add-khugepaged-completion-barrier-helper
+++ a/tools/lib/mm/hugepage_settings.c
@@ -217,6 +217,13 @@ void thp_read_settings(struct thp_settin
 	}
 }
 
+/* A store to either sleep knob wakes khugepaged, so write only on change */
+static void thp_update_num(const char *name, unsigned long num)
+{
+	if (thp_read_num(name) != num)
+		thp_write_num(name, num);
+}
+
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
@@ -232,15 +239,15 @@ void thp_write_settings(struct thp_setti
 			shmem_enabled_strings[settings->shmem_enabled]);
 	thp_write_num("use_zero_page", settings->use_zero_page);
 
-	thp_write_num("khugepaged/defrag", khugepaged->defrag);
-	thp_write_num("khugepaged/alloc_sleep_millisecs",
-			khugepaged->alloc_sleep_millisecs);
-	thp_write_num("khugepaged/scan_sleep_millisecs",
-			khugepaged->scan_sleep_millisecs);
-	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
-	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
-	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
-	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
+	thp_update_num("khugepaged/defrag", khugepaged->defrag);
+	thp_update_num("khugepaged/alloc_sleep_millisecs",
+		       khugepaged->alloc_sleep_millisecs);
+	thp_update_num("khugepaged/scan_sleep_millisecs",
+		       khugepaged->scan_sleep_millisecs);
+	thp_update_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
+	thp_update_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
+	thp_update_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
+	thp_update_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 
 	if (dev_queue_read_ahead_path[0]) {
 		int ret = write_num(dev_queue_read_ahead_path,
@@ -271,6 +278,41 @@ void thp_write_settings(struct thp_setti
 	}
 }
 
+/*
+ * Wait for a full khugepaged scan pass that started after this call: the
+ * pass in progress may already have passed this mm, so full_scans has to
+ * advance twice.
+ *
+ * A store to scan_sleep_millisecs wakes the daemon, but one made while it
+ * is scanning rather than sleeping is lost, so keep storing until the pass
+ * lands.
+ *
+ * One wake is one pass only if pages_to_scan covers every mm on the list.
+ */
+bool khugepaged_full_pass(unsigned int timeout_s)
+{
+	unsigned long deadline_ms = timeout_s * 1000UL;
+	unsigned long elapsed_ms = 0, poll_ms = 10;
+	unsigned long sleep_ms;
+	int pass;
+
+	sleep_ms = thp_read_num("khugepaged/scan_sleep_millisecs");
+	for (pass = 0; pass < 2; pass++) {
+		unsigned long target =
+			thp_read_num("khugepaged/full_scans") + 1;
+
+		while (thp_read_num("khugepaged/full_scans") < target) {
+			if (elapsed_ms >= deadline_ms)
+				return false;
+			thp_write_num("khugepaged/scan_sleep_millisecs",
+				      sleep_ms);
+			usleep(poll_ms * 1000);
+			elapsed_ms += poll_ms;
+		}
+	}
+	return true;
+}
+
 struct thp_settings *thp_current_settings(void)
 {
 	if (!settings_index) {
--- a/tools/lib/mm/hugepage_settings.h~selftests-mm-add-khugepaged-completion-barrier-helper
+++ a/tools/lib/mm/hugepage_settings.h
@@ -83,6 +83,8 @@ static inline void thp_save_settings(voi
 	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
 }
 
+bool khugepaged_full_pass(unsigned int timeout_s);
+
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

