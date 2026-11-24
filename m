Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541010;
	b=X44zz3vpGHZ67fClgyY+EdZP3I55iXUG+ncFkaEl3vsFM2EVc2Yf9lJ7UXvALLSx3HV2
	 gUEmS3pBXEjbeZBmXIljDCkyIgybfGCMot035oWx6HYfuua5T8f7GPS9iAGrHFF4cVWyM
	 w3i1nUcoOisZMsPYuz3mXS+rYV8UYMoKkOzrAdYvBQH2i+4ELCPEUIZkQMANpaaE4zaMW
	 JvV9RLL88b4DsMRk1tHvHTaWk1HVUCkHNYItFLRuTppvt6/HALRENTdP6Ccto8dpkV9zr
	 99sCP7uJqT84VD4teOkoa+JNklui86IAtf5jkfZIb21SiFmIZ5orDHRmJ59zWMHMbKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541010;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=4m9k9+NP84uTsgaFFfpmYIHMjEQd5Ll+mSP/EwBGdrE=;
	b=x43KCWp/eVGWbbDfLh7Gl4H/ZUxWR8REa/vzYoQGT9oBTMHyxPTYqeTH7l6wkSpcc3Sp
	 InYP3m6Kl04clb9rhx2gioIz1RmoQcVs4VXERZSWdTkUxP/1X9oZ2NqtdwGGBoTBUY1i1
	 tGvO+dc3qW+tgImxydu4iFvQmWvvJUHSloK0ZabN3kbKnGGvg4vqRQ1uoEY4cPmusLGUa
	 gsZsOxpeYTdgngl9rvcnbLmneY6kOaeV33hAYID+evPkbtHQlE6vH08cj0zznh1UgbROu
	 35kF/gdudwdHw+IcWNy3bavWLWuKjl+cmu0IM03RH6vEDGsLLjbU0/5vES5qSaPLkVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x0em6vpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CA606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x0em6vpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFC41F000E0;
	Tue, 24 Nov 2026 17:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541010;
	bh=4m9k9+NP84uTsgaFFfpmYIHMjEQd5Ll+mSP/EwBGdrE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=x0em6vppLBSWTD4ovNG07FZbFOAhHN8VZGx16mVtFe/nxDg0G7v3bdAe+eVD9KOKq
	 P8vw1IkG0j59/EC3S8lQzBeEsxDdR3tpbll/rGq/4fd7F5XxAWRXSVeeENs4e5jLlU
	 1yGCS0kLfEuZXOnjn0e8KiPDh8eu+eIlXZOe5Vi4=
Date: Tue, 24 Nov 2026 09:23:29 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-14-sj@kernel.org>
References: <20261124153636.91854-14-sj@kernel.org>
Subject: + mm-damon-core-introduce-damon_report_exist.patch added to mm-new branch
Message-Id: <20261124172330.3CFC41F000E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: introduce damon_report_exist()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_report_exist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_report_exist.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_report_exist()
Date: Tue, 24 Nov 2026 07:36:19 -0800

Implement and expose a new DAMON API function for searching data
attribute reports from the report queue.  The purpose is to let
operation sets use it for supporting the REPORT_MADE type probe filters.

The caller can specify the type, associated memory address range, and
the creation time range of reports to search.

The function uses CAS-based try-locking for the mutual-exclusive
synchronization.  If any parallel access to the queue is detected, it
forgives searching.

Link: https://patch.msgid.link/20261124153636.91854-14-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Lian Wang <lianux.mm@gmail.com>

 include/linux/damon.h |    3 ++
 mm/damon/core.c       |   46 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_report_exist
+++ a/include/linux/damon.h
@@ -1199,6 +1199,9 @@ int damon_call(struct damon_ctx *ctx, st
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_submit_report(struct damon_report *report);
+bool damon_report_exist(enum damon_report_type report_type,
+		struct damon_addr_range *addr_range,
+		unsigned long jiffies_old);
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_report_exist
+++ a/mm/damon/core.c
@@ -2392,6 +2392,52 @@ int damon_submit_report(struct damon_rep
 	return 0;
 }
 
+/**
+ * damon_report_exist() - Find if a report of a given condition exists.
+ *
+ * @report_type:	Type of the report.
+ * @addr_range:		Address range of the report.
+ * @jiffies_old:	Oldest jiffies to find the report for.
+ *
+ * Returns true if the report is found, false otherwise.
+ */
+bool damon_report_exist(enum damon_report_type report_type,
+		struct damon_addr_range *addr_range, unsigned long jiffies_old)
+{
+	struct damon_report_queue *queue;
+	int lock_old_val;
+	unsigned int idx, nr_read;
+	struct damon_report *report;
+	bool found = false;
+
+	queue = &damon_report_queue;
+	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
+
+	if (lock_old_val)
+		return false;
+	idx = queue->tail;
+	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
+		if (idx)
+			idx--;
+		else
+			idx = queue->size - 1;
+		report = &queue->reports[idx];
+
+		if (time_before(report->jiffies, jiffies_old))
+			break;
+		if (report->type != report_type)
+			continue;
+		if (addr_range->end <= report->addr_range.start ||
+				report->addr_range.end <= addr_range->start)
+			continue;
+		found = true;
+		break;
+	}
+
+	atomic_cmpxchg(&queue->lock, 1, 0);
+	return found;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch
mm-damon-api-introduce-struct-damon_report.patch
mm-damon-core-implement-data-attribute-report-queue.patch
mm-damon-core-introduce-damon_submit_report.patch
mm-damon-sysfs-add-admin-reports-directory.patch
mm-damon-sysfs-add-reports-producers-directory.patch
mm-damon-sysfs-add-producers-nr_producers-file.patch
mm-damon-sysfs-implement-report-producer-directory.patch
mm-damon-sysfs-implement-report-producer-type-and-state-files.patch
docs-mm-damon-design-update-for-report-system.patch
docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch
docs-abi-damon-update-for-report-producer-sysfs-files.patch
mm-damon-core-introduce-damon_filter_type_report_made.patch
mm-damon-core-introduce-damon_report_exist.patch
mm-damon-paddr-support-report_made-type-probe-filter.patch
mm-damon-sysfs-add-filter_report_type-file-under-probe-filter-directory.patch
mm-damon-sysfs-support-report_made-type-probe-filter-setup.patch
docs-mm-damon-design-update-for-report_made-probe-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch
docs-abi-damon-update-for-report_made-probe-filter.patch
mm-damon-api-introduce-user_report-report-type.patch
mm-damon-sysfs-add-user_report-support-for-report-type-input.patch
mm-damon-sysfs-implement-report-producer-addr_startend-files.patch
mm-damon-sysfs-implement-submit-command-for-report-producer.patch
selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch
docs-mm-damon-design-update-for-user-report-support.patch
docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch
docs-abi-damon-update-for-user_report-report-support.patch

