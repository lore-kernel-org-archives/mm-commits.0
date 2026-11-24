Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540985;
	b=TwbJYGW9u8rVOeLRdnJA9E9zE77zHNH0aBx/6Auu9vJdi58r96G+B9KmOsmL+y8wIOyv
	 KPuuHRHrbjgTSv0N28uEt+atWYS2EQaXWloOMD6gVyCiFZWHCKrfL+jQL02lI/OHFIH1J
	 Mvabi+pk8gcIUNhbdhd9lC1HyY67RagEseswmbkt2kSzvT46veBFVNdFVQv6D8oK9+7Bc
	 dvR1vmXk/SMqkB6nRMMEAYp0FRZnWD5Tyt1Y9Kj4KN3+2Upd/D3Uv/mvQUcSqnKpDqU2/
	 EY2N/cDPCw8PN964As4kMW9ZRvAIdFA9zZ5xBaN2ngHutRjsZmil+s5t3YutpnqbCDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540985;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=v5cxCQ/71HR3Dk5XbAyOhpnTZCsxRQBNS7VNVonTeg0=;
	b=AEe1A7DqEmVZzcKZ/l69IoaBdcv60bk/7ESgg9VHza+ECAEmP8hzQ6GWRB2gAXYT0fst
	 Xde3Y6n6GT/0dc+xTlMeKs8neC1oE54Lem1fob3mudMBIZJ6poz11xv3QZLOEpEl7HpUu
	 3qpqEh1g3ux11LfZqaOn5hcCKY7yijmz2bHgkHMYNz5l1PngyUjRyG3mCDVb/mSQcYpOL
	 YV+u7gWODgXLKwBk/44kqPGxOAnnN+e/39PzGPY0IrMSvQGKn2Ezdmz5823WzPUFSEx4B
	 3bheKqm+VJwzDfhSq8fxq5RffndmlUww8gEHqtXW9Oh27z+syfamesc9v0DxmkAVeiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yzkeL5qW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D93606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yzkeL5qW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC891F000D1;
	Tue, 24 Nov 2026 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540984;
	bh=v5cxCQ/71HR3Dk5XbAyOhpnTZCsxRQBNS7VNVonTeg0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=yzkeL5qW4VCfIpQI8uYZZ7Wb6GUNiplMFrV1g8wAH/PS3y4jiwmrlAasiNlsWIeKI
	 6XbyPpp0jTw0lRW+zGPGsLCbqS2ZLZL16zRxPe8B6DBRvlHv9+DZUemUVZUC9yBG3o
	 8ZDoZyWaqw0BcD3yeK9/pvWD8K17dHYPERUiocVA=
Date: Tue, 24 Nov 2026 09:23:03 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-5-sj@kernel.org>
References: <20261124153636.91854-5-sj@kernel.org>
Subject: + mm-damon-sysfs-add-admin-reports-directory.patch added to mm-new branch
Message-Id: <20261124172304.5EC891F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs: add admin/reports/ directory
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-add-admin-reports-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-add-admin-reports-directory.patch

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
Subject: mm/damon/sysfs: add admin/reports/ directory
Date: Tue, 24 Nov 2026 07:36:10 -0800

Add a new sysfs directory, reports/, as a place holder for sysfs files
that will be used for controlling the data attribute report system.  Put
the directory under the admin/ directory, next to kdamonds/ directory.

Link: https://patch.msgid.link/20261124153636.91854-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 mm/damon/sysfs.c |   63 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-add-admin-reports-directory
+++ a/mm/damon/sysfs.c
@@ -2979,6 +2979,38 @@ static const struct kobj_type damon_sysf
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* reports dir */
+
+struct damon_sysfs_reports {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_reports);
+}
+
+static int damon_sysfs_reports_add_dirs(struct damon_sysfs_reports *reports)
+{
+	return 0;
+}
+
+static void damon_sysfs_reports_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_reports, kobj));
+}
+
+static struct attribute *damon_sysfs_reports_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_reports);
+
+static const struct kobj_type damon_sysfs_reports_ktype = {
+	.release = damon_sysfs_reports_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_reports_groups,
+};
+
 /*
  * damon user interface directory
  */
@@ -2986,6 +3018,7 @@ static const struct kobj_type damon_sysf
 struct damon_sysfs_ui_dir {
 	struct kobject kobj;
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 };
 
 static struct damon_sysfs_ui_dir *damon_sysfs_ui_dir_alloc(void)
@@ -2996,6 +3029,7 @@ static struct damon_sysfs_ui_dir *damon_
 static int damon_sysfs_ui_dir_add_dirs(struct damon_sysfs_ui_dir *ui_dir)
 {
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 	int err;
 
 	kdamonds = damon_sysfs_kdamonds_alloc();
@@ -3005,11 +3039,32 @@ static int damon_sysfs_ui_dir_add_dirs(s
 	err = kobject_init_and_add(&kdamonds->kobj,
 			&damon_sysfs_kdamonds_ktype, &ui_dir->kobj,
 			"kdamonds");
-	if (err) {
-		kobject_put(&kdamonds->kobj);
-		return err;
-	}
+	if (err)
+		goto put_kdamonds_out;
 	ui_dir->kdamonds = kdamonds;
+
+	reports = damon_sysfs_reports_alloc();
+	if (!reports) {
+		err = -ENOMEM;
+		goto put_kdamonds_out;
+	}
+	ui_dir->reports = reports;
+
+	err = kobject_init_and_add(&reports->kobj, &damon_sysfs_reports_ktype,
+			&ui_dir->kobj, "reports");
+	if (err)
+		goto put_reports_out;
+	err = damon_sysfs_reports_add_dirs(reports);
+	if (err)
+		goto put_reports_out;
+	return err;
+
+put_reports_out:
+	kobject_put(&reports->kobj);
+	ui_dir->reports = NULL;
+put_kdamonds_out:
+	kobject_put(&kdamonds->kobj);
+	ui_dir->kdamonds = NULL;
 	return err;
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

