Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E40C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjASBQ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjASBP3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA73E68405
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6232861B0E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60ADC433F0;
        Thu, 19 Jan 2023 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090876;
        bh=aYmI/+2G640JDsvZmq8O/Bn+Il+OLD1+EKyPqA3D6es=;
        h=Date:To:From:Subject:From;
        b=OiHtTNCn3aW24Q2TdIfnhgvwFRjMqu7st7byJojZCEfGk1lC95RG8HwsywBNYqAVL
         sTMZs3pp18jrh67K8CpR0ZWZqc+4C2zFAXimcIF3YDfxnLRBnHZBJ5+muj6XSpk/FC
         pbPc4vBSVRRDV6QOEEX5iKu1i4dpEAUb8IbXDrWc=
Date:   Wed, 18 Jan 2023 17:14:36 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-filter-directory.patch removed from -mm tree
Message-Id: <20230119011436.B60ADC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement filter directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-filter-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement filter directory
Date: Mon, 5 Dec 2022 23:08:25 +0000

Implement DAMOS filter directory which will be located under the filters
directory.  The directory provides three files, namely type, matching, and
memcg_path.  'type' and 'matching' will be directly connected to the
fields of 'struct damos_filter' having same name.  'memcg_path' will
receive the path of the memory cgroup of the interest and later converted
to memcg id when it's committed.

Link: https://lkml.kernel.org/r/20221205230830.144349-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |  128 +++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-filter-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -259,6 +259,134 @@ static struct kobj_type damon_sysfs_stat
 };
 
 /*
+ * filter directory
+ */
+
+struct damon_sysfs_scheme_filter {
+	struct kobject kobj;
+	enum damos_filter_type type;
+	bool matching;
+	char *memcg_path;
+};
+
+/* Should match with enum damos_filter_type */
+static const char * const damon_sysfs_scheme_filter_type_strs[] = {
+	"anon",
+	"memcg",
+};
+
+static ssize_t type_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%s\n",
+			damon_sysfs_scheme_filter_type_strs[filter->type]);
+}
+
+static ssize_t type_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	enum damos_filter_type type;
+	ssize_t ret = -EINVAL;
+
+	for (type = 0; type < NR_DAMOS_FILTER_TYPES; type++) {
+		if (sysfs_streq(buf, damon_sysfs_scheme_filter_type_strs[
+					type])) {
+			filter->type = type;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
+static ssize_t matching_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->matching ? 'Y' : 'N');
+}
+
+static ssize_t matching_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	bool matching;
+	int err = kstrtobool(buf, &matching);
+
+	if (err)
+		return err;
+
+	filter->matching = matching;
+	return count;
+}
+
+static ssize_t memcg_path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%s\n",
+			filter->memcg_path ? filter->memcg_path : "");
+}
+
+static ssize_t memcg_path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	char *path = kmalloc(sizeof(*path) * (count + 1), GFP_KERNEL);
+
+	if (!path)
+		return -ENOMEM;
+
+	strncpy(path, buf, count);
+	path[count] = '\0';
+	filter->memcg_path = path;
+	return count;
+}
+
+static void damon_sysfs_scheme_filter_release(struct kobject *kobj)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	kfree(filter->memcg_path);
+	kfree(filter);
+}
+
+static struct kobj_attribute damon_sysfs_scheme_filter_type_attr =
+		__ATTR_RW_MODE(type, 0600);
+
+static struct kobj_attribute damon_sysfs_scheme_filter_matching_attr =
+		__ATTR_RW_MODE(matching, 0600);
+
+static struct kobj_attribute damon_sysfs_scheme_filter_memcg_path_attr =
+		__ATTR_RW_MODE(memcg_path, 0600);
+
+static struct attribute *damon_sysfs_scheme_filter_attrs[] = {
+	&damon_sysfs_scheme_filter_type_attr.attr,
+	&damon_sysfs_scheme_filter_matching_attr.attr,
+	&damon_sysfs_scheme_filter_memcg_path_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_scheme_filter);
+
+static struct kobj_type damon_sysfs_scheme_filter_ktype = {
+	.release = damon_sysfs_scheme_filter_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_scheme_filter_groups,
+};
+
+/*
  * filters directory
  */
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

