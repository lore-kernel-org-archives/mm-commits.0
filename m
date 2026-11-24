Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540978;
	b=5Zw3S8gWWGNk5pfVFERhAfCDPH4FaP79nLVjISlcQLOtwRwgLHbsNs3BCGQOcM+7XpGK
	 XFAGR4/pmT4ls26ZxOUrBw83CL60TxD3WLAZKRrHr3V7edpucIa/IUgGo0O0SKXWeq56L
	 ps+nXyJktaiZBAzoCi44w7jcNCKP1ClmeWFRy4azt3/ei4QIdCQAvph1ji2fJ19WEmdYD
	 gm6eGMaOZTe6DJTkkK/O3VdgPZbefUT3N28hLZ2tKuQRiE1zCnkzChfL/xiioOggD+wZS
	 tjLVVIixH64DLolbHFsb5sEATq5l0bMvLMMFjE92Lo61K5VmveFHAQdv33LDm49WXoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540978;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=WpJNusi52mmTJdAtIP1m6CV1Do+TBsjXkNtRMaY6BRw=;
	b=wuXJp7CIgYp5divvXjbkmLAeLAkD4onfXtgIYryzg0jQSCtKxVDRJkmKHD7HsFrAFnGc
	 Bb7TamFUZRhgAcDEmPV5OQj/HcjPUg+bN7zo0s3C12RPDDXbats6Ou0cgBiDZqQh35vIl
	 VZYTTmDGL700CC+TKw2aIqbNdwrm8qKEC9ufFzHnX+TMcrgG9E3HQSg5qU5U/jEW+6UeT
	 rN0+Coa3r41TBMOtKJdtgRljp02mqO/T+A2xrqoM7cq1QkPKednfD1L9B+kCHT5TzDLvM
	 lxGXGbwNeyXLszn9r7hg8L1nOwvV1K3cJHw/5njN1F3kw/dnUVUhBkUJeIg2Pn6DHGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x2uPVD9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60C606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x2uPVD9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EC81F000C0;
	Tue, 24 Nov 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540978;
	bh=WpJNusi52mmTJdAtIP1m6CV1Do+TBsjXkNtRMaY6BRw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=x2uPVD9q3lDvM/vDvqSkzoeLpz0hbXhs+EIbsfo+p5Pxz6mmaAg4RTOwZAsxKtoXi
	 dKrrC41w8BMrT+l65Z8YPNGtAvSNmUdAXrqBa9AuqNnmU1tJ92WyomNGSZTpywu29z
	 //zBqfpKrl3oqji8K2wcfDy6BUbfIwz+UUi2KIkc=
Date: Tue, 24 Nov 2026 09:22:57 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-3-sj@kernel.org>
References: <20261124153636.91854-3-sj@kernel.org>
Subject: + mm-damon-core-implement-data-attribute-report-queue.patch added to mm-new branch
Message-Id: <20261124172258.25EC81F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: implement data attribute report queue
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-implement-data-attribute-report-queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-data-attribute-report-queue.patch

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
Subject: mm/damon/core: implement data attribute report queue
Date: Tue, 24 Nov 2026 07:36:08 -0800

Implement DAMON core internal data structure for queuing received
data attribute reports.  Initialize the queue for up to 1,000 reports,
inside the DAMON init routine.  Destroy damon_region_cache and reset the
pointer for the queue setup failures.

Link: https://patch.msgid.link/20261124153636.91854-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 mm/damon/core.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-implement-data-attribute-report-queue
+++ a/mm/damon/core.c
@@ -2338,6 +2338,25 @@ int damos_walk(struct damon_ctx *ctx, st
 }
 
 /*
+ * struct damon_report_queue - &struct damon_report queue.
+ *
+ * @lock:	Represent if this queue is being used by someone.
+ * @tail:	Tail of the queue.
+ * @size:	Size of the queue.
+ * @nr_reports:	Number of reports stored in the queue.
+ * @reports:	Array of &struct damon_report.
+ */
+struct damon_report_queue {
+	atomic_t lock;
+	unsigned int tail;
+	unsigned int size;
+	unsigned int nr_reports;
+	struct damon_report *reports;
+};
+
+static struct damon_report_queue damon_report_queue;
+
+/*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
 static void kdamond_reset_aggregated(struct damon_ctx *c)
@@ -4323,7 +4342,7 @@ void damon_update_region_access_rate(str
  */
 bool damon_initialized(void)
 {
-	return damon_region_cache != NULL;
+	return damon_region_cache;
 }
 
 static int __init damon_init(void)
@@ -4334,6 +4353,16 @@ static int __init damon_init(void)
 		return -ENOMEM;
 	}
 
+	damon_report_queue.size = 1000;
+	damon_report_queue.reports = kmalloc_objs(*damon_report_queue.reports,
+			1000, GFP_KERNEL);
+	if (!damon_report_queue.reports) {
+		pr_err("report queue alloc fail\n");
+		kmem_cache_destroy(damon_region_cache);
+		damon_region_cache = NULL;
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
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

