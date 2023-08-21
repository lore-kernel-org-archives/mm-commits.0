Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F0BEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjHUUkR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjHUUkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0AD131
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BAE464A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B13C433C7;
        Mon, 21 Aug 2023 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650378;
        bh=PzrHusY6XgqR67DRZr6sVDNSVZDukdW+5DYOQ/NuceM=;
        h=Date:To:From:Subject:From;
        b=f1gWWe0z+SobJba5o9bDG39+jMyoJMoDGkDODZLUzZEcnGSDf5CcuMz131X80TJMt
         ElKDi66/T5OWa544b3bi8FQJ/Ioe+Dyv7GKET+0TFj2urlxvRZZQ2lDHqGV5NFpt/6
         R/5L4Du3l1/hXLY3It709Idpwcaxec/mhxCrqEJ8=
Date:   Mon, 21 Aug 2023 13:39:37 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch removed from -mm tree
Message-Id: <20230821203937.E0B13C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement DAMOS tried total bytes file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement DAMOS tried total bytes file
Date: Wed, 2 Aug 2023 21:32:17 +0000

Patch series "mm/damon/sysfs-schemes: implement DAMOS tried total bytes
file".

The tried_regions directory of DAMON sysfs interface is useful for
retrieving monitoring results snapshot or DAMOS debugging.  However, for
common use case that need to monitor only the total size of the scheme
tried regions (e.g., monitoring working set size), the kernel overhead for
directory construction and user overhead for reading the content could be
high if the number of monitoring region is not small.  This patchset
implements DAMON sysfs files for efficient support of the use case.

The first patch implements the sysfs file to reduce the user space
overhead, and the second patch implements a command for reducing the
kernel space overhead.

The third patch adds a selftest for the new file, and following two
patches update documents.

[1] https://lore.kernel.org/damon/20230728201817.70602-1-sj@kernel.org/


This patch (of 5):

The tried_regions directory can be used for retrieving the monitoring
results snapshot for regions of specific access pattern, by setting the
scheme's action as 'stat' and the access pattern as required.  While the
interface provides every detail of the monitoring results, some use cases
including working set size monitoring requires only the total size of the
regions.  For such cases, users should read all the information and
calculate the total size of the regions.  However, it could incur high
overhead if the number of regions is high.  Add a file for retrieving only
the information, namely 'total_bytes' file.  It allows users to get the
total size by reading only the file.

Link: https://lkml.kernel.org/r/20230802213222.109841-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230802213222.109841-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file
+++ a/mm/damon/sysfs-schemes.c
@@ -117,6 +117,7 @@ struct damon_sysfs_scheme_regions {
 	struct kobject kobj;
 	struct list_head regions_list;
 	int nr_regions;
+	unsigned long total_bytes;
 };
 
 static struct damon_sysfs_scheme_regions *
@@ -128,9 +129,19 @@ damon_sysfs_scheme_regions_alloc(void)
 	regions->kobj = (struct kobject){};
 	INIT_LIST_HEAD(&regions->regions_list);
 	regions->nr_regions = 0;
+	regions->total_bytes = 0;
 	return regions;
 }
 
+static ssize_t total_bytes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_regions *regions = container_of(kobj,
+			struct damon_sysfs_scheme_regions, kobj);
+
+	return sysfs_emit(buf, "%lu\n", regions->total_bytes);
+}
+
 static void damon_sysfs_scheme_regions_rm_dirs(
 		struct damon_sysfs_scheme_regions *regions)
 {
@@ -148,7 +159,11 @@ static void damon_sysfs_scheme_regions_r
 	kfree(container_of(kobj, struct damon_sysfs_scheme_regions, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_scheme_regions_total_bytes_attr =
+		__ATTR_RO_MODE(total_bytes, 0400);
+
 static struct attribute *damon_sysfs_scheme_regions_attrs[] = {
+	&damon_sysfs_scheme_regions_total_bytes_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_regions);
@@ -1648,6 +1663,7 @@ static int damon_sysfs_before_damos_appl
 		return 0;
 
 	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
+	sysfs_regions->total_bytes += r->ar.end - r->ar.start;
 	region = damon_sysfs_scheme_region_alloc(r);
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
@@ -1678,6 +1694,7 @@ int damon_sysfs_schemes_clear_regions(
 		sysfs_scheme = sysfs_schemes->schemes_arr[schemes_idx++];
 		damon_sysfs_scheme_regions_rm_dirs(
 				sysfs_scheme->tried_regions);
+		sysfs_scheme->tried_regions->total_bytes = 0;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


