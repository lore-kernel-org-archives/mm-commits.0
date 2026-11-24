Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541035;
	b=Ss7x7Mye/3sXYJxCTMKOWpiC6lUvUif8lnbtXqUs/kwCsPOY/YmIcanofmyTFwFIV9Ev
	 zfbuP0d37c2w5cN7X+AWpe8oUqAbCccd+SoWaQG6CcjvCgq2ue+x2Th/5GfMW2kS15fJu
	 uSoSEmQzLXAbXn3KtVfSlb94OO0/ny4Rfn9HtWl02FFfZi4dP5BnfUnTSaN4EJYqaWrgG
	 Gyx8RRx6V+HbqtvuJVIDgjf3xAqlevRjPsJ+WreuBW/TLjB00CcKeDCCJoH47b1w6I8JL
	 v0Nhu9XtpUyK0ET/4sIJdKoDjv3GkDOKn2cDCgNGwIT0aa4tGtkfiIhXONjNfrCbAkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541035;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=lvA0IkaNH3UtacjO2p02D4YdSETb+yKJELT04jpBhvc=;
	b=oFD1PrCHxnk8CVIslK6HJZ5Kq8uDn1IXvyu+l8aYTsotu3lke8gtdDLkRZC7Tu6pJLfk
	 3wYFSBn/oa6DT9g1oFQmCnI5UGNVuIb0jETVd9Kly6lWwFLzFUqelwkDxpwUj5n/aTdhw
	 WV+du1F7NU0SH2yI/juUAuPaWHCe9z89ajAbG+TaL0oL+9dHk8QaLu2PmpLmHcYB43Kf2
	 +lIT9p7VDyd7G1mAPIYZIOtkjNcx45zmUavYrJzc7eNSB1yVqtwyxFxKabgJrGd1nXwRp
	 9ZdXimwQseNKL1isL6xxVbvcuK1wXZt05BSqsValvwwX/LeNoEIK4fxhEH1o80rqNPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sLpM9ucH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3BF606A326
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sLpM9ucH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9281F000D1;
	Tue, 24 Nov 2026 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541035;
	bh=lvA0IkaNH3UtacjO2p02D4YdSETb+yKJELT04jpBhvc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sLpM9ucHk+uU4dwLw3U3R6mbCmOI6oXmDbkcziMPTplOeREmsPwk39w5uN2WiOIl/
	 UCYsg1EaPlcRrQxTaF+Nfo5nQjHQuMLLWDwlW6nLB27KqYuCxr35C44HpFBWEh+LHT
	 1j5wmvn+6VJEvvHMgOTc649vV8b4xnrkHQcGJyvc=
Date: Tue, 24 Nov 2026 09:23:54 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-23-sj@kernel.org>
References: <20261124153636.91854-23-sj@kernel.org>
Subject: + mm-damon-sysfs-implement-report-producer-addr_startend-files.patch added to mm-new branch
Message-Id: <20261124172355.2A9281F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs: implement report producer addr_{start,end} files
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-report-producer-addr_startend-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-report-producer-addr_startend-files.patch

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
Subject: mm/damon/sysfs: implement report producer addr_{start,end} files
Date: Tue, 24 Nov 2026 07:36:28 -0800

Implement addr_start and addr_end sysfs files under report producer
directory.  Those set and get the address range of the user_report type
data attribute reports.

Link: https://patch.msgid.link/20261124153636.91854-23-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Lian Wang <lianux.mm@gmail.com>

 mm/damon/sysfs.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-report-producer-addr_startend-files
+++ a/mm/damon/sysfs.c
@@ -3047,6 +3047,7 @@ struct damon_sysfs_producer {
 	struct kobject kobj;
 	enum damon_report_type report_type;
 	bool enabled;
+	struct damon_addr_range addr_range;
 };
 
 static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
@@ -3116,6 +3117,44 @@ static ssize_t producer_state_store(stru
 	return count;
 }
 
+static ssize_t addr_start_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.start);
+}
+
+static ssize_t addr_start_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.start);
+
+	return err ? err : count;
+}
+
+static ssize_t addr_end_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+
+	return sysfs_emit(buf, "%lu\n", producer->addr_range.end);
+}
+
+static ssize_t addr_end_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	int err = kstrtoul(buf, 0, &producer->addr_range.end);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_producer_release(struct kobject *kobj)
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
@@ -3127,10 +3166,16 @@ static struct kobj_attribute damon_sysfs
 		__ATTR_RW_MODE(report_type, 0600);
 static struct kobj_attribute damon_sysfs_producer_producer_state_type_attr =
 		__ATTR_RW_MODE(producer_state, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_start_type_attr =
+		__ATTR_RW_MODE(addr_start, 0600);
+static struct kobj_attribute damon_sysfs_producer_addr_end_type_attr =
+		__ATTR_RW_MODE(addr_end, 0600);
 
 static struct attribute *damon_sysfs_producer_attrs[] = {
 	&damon_sysfs_producer_report_type_attr.attr,
 	&damon_sysfs_producer_producer_state_type_attr.attr,
+	&damon_sysfs_producer_addr_start_type_attr.attr,
+	&damon_sysfs_producer_addr_end_type_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_producer);
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

