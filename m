Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE1CC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjHBVvt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjHBVvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5446119
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F5C61B23
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0B9C433C8;
        Wed,  2 Aug 2023 21:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013103;
        bh=6JKmhWzXT6dM98zjaT1XRfOQLtRpJ6ctJG9pBq2LJlY=;
        h=Date:To:From:Subject:From;
        b=yaQAWQzCSk4EBIYd/5mxQxT2QyOSZegNOD9Sc6Hyhk0HIwDo5SvCpVo92lZrC0r0Z
         SFGIkKp95LiKYhgR4DDDBBnznxm9tHoxnGFTrC1k1HMquRnDq3OwNmQF79nSDttPDf
         D8Ux3VdAz7KXT8IiKSjYtbspv/xJW++41CTBSGPQ=
Date:   Wed, 02 Aug 2023 14:51:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215143.AD0B9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: support address range type DAMOS filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/sysfs-schemes: support address range type DAMOS filter
Date: Wed, 2 Aug 2023 21:43:01 +0000

Extend DAMON sysfs interface to support address range based DAMOS filters,
by adding a special keyword for the filter/<N>/type file, namely 'addr',
and two files under filter/<N>/ for specifying the start and the end
addresses of the range, namely 'addr_start' and 'addr_end'.

Link: https://lkml.kernel.org/r/20230802214312.110532-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   56 +++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-address-range-type-damos-filter
+++ a/mm/damon/sysfs-schemes.c
@@ -282,6 +282,7 @@ struct damon_sysfs_scheme_filter {
 	enum damos_filter_type type;
 	bool matching;
 	char *memcg_path;
+	struct damon_addr_range addr_range;
 };
 
 static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(void)
@@ -293,6 +294,7 @@ static struct damon_sysfs_scheme_filter
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
 	"memcg",
+	"addr",
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -373,6 +375,44 @@ static ssize_t memcg_path_store(struct k
 	return count;
 }
 
+static ssize_t addr_start_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->addr_range.start);
+}
+
+static ssize_t addr_start_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->addr_range.start);
+
+	return err ? err : count;
+}
+
+static ssize_t addr_end_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->addr_range.end);
+}
+
+static ssize_t addr_end_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->addr_range.end);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_scheme_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
@@ -391,10 +431,18 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_filter_memcg_path_attr =
 		__ATTR_RW_MODE(memcg_path, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_filter_addr_start_attr =
+		__ATTR_RW_MODE(addr_start, 0600);
+
+static struct kobj_attribute damon_sysfs_scheme_filter_addr_end_attr =
+		__ATTR_RW_MODE(addr_end, 0600);
+
 static struct attribute *damon_sysfs_scheme_filter_attrs[] = {
 	&damon_sysfs_scheme_filter_type_attr.attr,
 	&damon_sysfs_scheme_filter_matching_attr.attr,
 	&damon_sysfs_scheme_filter_memcg_path_attr.attr,
+	&damon_sysfs_scheme_filter_addr_start_attr.attr,
+	&damon_sysfs_scheme_filter_addr_end_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_filter);
@@ -1484,7 +1532,15 @@ static int damon_sysfs_set_scheme_filter
 				damos_destroy_filter(filter);
 				return err;
 			}
+		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
+			if (sysfs_filter->addr_range.end <
+					sysfs_filter->addr_range.start) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
+			filter->addr_range = sysfs_filter->addr_range;
 		}
+
 		damos_add_filter(scheme, filter);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

