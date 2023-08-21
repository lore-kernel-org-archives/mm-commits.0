Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF67EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjHUUk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjHUUkK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6DACE2
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D953064B09
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E8C433C7;
        Mon, 21 Aug 2023 20:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650384;
        bh=Qsg0z854CUWYiSyN+bQAyB0ymLCA+Mfs/S3Vl9cZW80=;
        h=Date:To:From:Subject:From;
        b=bGrjIs1ivsgyebFq8fvWOfFerJ0L/k9mOV0JCF9vzRAbW+BBJSyqZbOVdKsWhaqcZ
         +ZlCi/hOGbZQRAdwN9nIGoYZERyPcxYJ2X1wbQ3sRhb9ym4mltOt4zYQNXEMfv7F8j
         UEo3/LLeMzIAABNHPAx38J7qRxYr6Bg+5yrNitKw=
Date:   Mon, 21 Aug 2023 13:39:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203944.396E8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support address range type DAMOS filter
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


