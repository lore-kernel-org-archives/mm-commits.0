Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2F19E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905832; cv=none; b=CUdJNboTomzITX/j/xwS/Kyk62/EHCui96qTJCKjAUUt5rkuyRzc61OLpXWl5kbZTgsUD76o/i5qQeEghf4p1B2HrlXUEifzSXf4LhaRk1K2r56EQjTxwZwkkTC6B4g2OwTVxFUl487pR8fAA3nS/DrhaUXgrapMlUknNvH2FU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905832; c=relaxed/simple;
	bh=xnEwY/mFMmgHR97H8wsRn2QWOJDYYPkgr+z1bD6RUys=;
	h=Date:To:From:Subject:Message-Id; b=i5QZAVXjc94lqgA4g/CFGqZzP1AYZm0sx4QQJObE1SGY/I3MbSzeBYXq6Ll+PUJMNgVp+yq0U1xc3Fxj9RCXslQMebeayE/KBmYR3xRb+O7nPzz+eI11MPnNnHfFVwtt6DcTds2h9Xx8RYyotebwswmAgQAWhUQa8Wph1zmmThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vlUFbtXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vlUFbtXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D822C4CEED;
	Fri, 22 Aug 2025 23:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905832;
	bh=xnEwY/mFMmgHR97H8wsRn2QWOJDYYPkgr+z1bD6RUys=;
	h=Date:To:From:Subject:From;
	b=vlUFbtXY5HF/IwT27qHqQHCPLazywbxrx96DmWI6rlNGEVv01Su+st4y7kJv0KbsY
	 ZIWeRIFTf6ijIoGg9Ojq8ee5HuPM2mABvwElNPZjs5RO6umQA/Y6SR88qn06RA21GC
	 3dZiSlbVkbmqVEbuhbbrd0X9+izodOn7jiUViXh0=
Date: Fri, 22 Aug 2025 16:37:12 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch added to mm-new branch
Message-Id: <20250822233712.8D822C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement addr_unit file under context dir
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement addr_unit file under context dir
Date: Fri, 22 Aug 2025 17:34:15 +0800

Only DAMON kernel API callers can use addr_unit parameter.  Implement a
sysfs file to let DAMON sysfs ABI users use it.

Additionally, addr_unit must be set to a non-zero value.

Link: https://lkml.kernel.org/r/20250822093420.2103803-8-yanquanmin1@huawei.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-addr_unit-file-under-context-dir
+++ a/mm/damon/sysfs.c
@@ -834,6 +834,7 @@ static const struct damon_sysfs_ops_name
 struct damon_sysfs_context {
 	struct kobject kobj;
 	enum damon_ops_id ops_id;
+	unsigned long addr_unit;
 	struct damon_sysfs_attrs *attrs;
 	struct damon_sysfs_targets *targets;
 	struct damon_sysfs_schemes *schemes;
@@ -849,6 +850,7 @@ static struct damon_sysfs_context *damon
 		return NULL;
 	context->kobj = (struct kobject){};
 	context->ops_id = ops_id;
+	context->addr_unit = 1;
 	return context;
 }
 
@@ -997,6 +999,32 @@ static ssize_t operations_store(struct k
 	return -EINVAL;
 }
 
+static ssize_t addr_unit_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+
+	return sysfs_emit(buf, "%lu\n", context->addr_unit);
+}
+
+static ssize_t addr_unit_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_context *context = container_of(kobj,
+			struct damon_sysfs_context, kobj);
+	unsigned long input_addr_unit;
+	int err = kstrtoul(buf, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	context->addr_unit = input_addr_unit;
+	return count;
+}
+
 static void damon_sysfs_context_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
@@ -1008,9 +1036,13 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_context_operations_attr =
 		__ATTR_RW_MODE(operations, 0600);
 
+static struct kobj_attribute damon_sysfs_context_addr_unit_attr =
+		__ATTR_RW_MODE(addr_unit, 0600);
+
 static struct attribute *damon_sysfs_context_attrs[] = {
 	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
+	&damon_sysfs_context_addr_unit_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_context);
@@ -1397,6 +1429,7 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
+	ctx->addr_unit = sys_ctx->addr_unit;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

