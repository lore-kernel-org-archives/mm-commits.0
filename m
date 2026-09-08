Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699B848E0FA
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897031; cv=none; b=VuWvVc53PF5iU+2l3MyhiqjN4alec62dEm9dP0fCI4Qw/hin5din2nBUkaxftFi9qiVi3goPex8TLPmCToG9Doc7nSa1VpgNLnRgdg1p3rc/9Tp61M3RDYfZgL+WlajgM+J0hKFHIqvkrAOcpBMTs3anvBjm2A9TA1x+GGDEKL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897031; c=relaxed/simple;
	bh=hlZFCvCW/Q/eHJJfH1dFi/9X1bRkT/rWKmtfsRj1ZuY=;
	h=Date:To:From:Subject:Message-Id; b=kgsn0A4KXYDzd8lAnG4oXFl6GnIcjT8Wu1IBas8SgY//4OqrjM9BTY6CnMiKAjZr+IqLlHslUUJWux0GVxigVnmmEfQ9uiIQB4i4CXVnnQWmxDUN6MoaPeIKvHsj09hMYLP6K7YrGivS6zw2HtMqZCpFujLeNyE5tfdd6ba6ygM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0pOZlPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0pOZlPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9FA1F00A3D;
	Tue,  8 Sep 2026 19:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897027;
	bh=B0PiLlPHC+CsNcqWOC7bEstHbj4QXbePx7bHmXtxnsQ=;
	h=Date:To:From:Subject;
	b=h0pOZlPreHa0EByCJucW1igJGdrZtaoVcFRhpw+nO7oMo0G+maIKksgpTemyn4zM9
	 HaXY8AZ1iCOFy6yT1GKzu5hiaizrgFe2fMRBPRaWyUpL48lI4k98mTp5nXjU0chaSH
	 mIiO+fR7c8OlhDEjiozbR7qzj804PY3WmevRDw0A=
Date: Tue, 08 Sep 2026 12:50:26 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-khugepaged-completion-barrier-helper.patch added to mm-new branch
Message-Id: <20260908195027.2A9FA1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add khugepaged completion barrier helper
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-khugepaged-completion-barrier-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-khugepaged-completion-barrier-helper.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add khugepaged completion barrier helper
Date: Tue, 8 Sep 2026 13:50:56 +0100

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

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-11-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

