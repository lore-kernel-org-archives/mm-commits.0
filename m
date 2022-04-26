Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684EFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355202AbiDZVBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355200AbiDZVBa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 17:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F7248E7F
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36186B82353
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AA2C385A4;
        Tue, 26 Apr 2022 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651006698;
        bh=MDVjZBPXsKrtCpc9bCs1t2utCJasdBj5MS7wQoKtndI=;
        h=Date:To:From:Subject:From;
        b=2sHjDO5rDfhF6Fh/tb1bWpWM/FEFy7ayb0++X/Rek2pkeKFSi6oSA9VJ+XvYXEsvG
         lMHrKseVZHHTnETbe2pV/dATYdqPxiMs1Msr4DJPDjaD8nCuoGrHTF/McURkA90As1
         a2ie3tC6C20GJNdGoGj4PXnoyneaVlcIi+cPV2gA=
Date:   Tue, 26 Apr 2022 13:58:17 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch added to -mm tree
Message-Id: <20220426205817.E3AA2C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: add a file for listing available monitoring ops
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: add a file for listing available monitoring ops

DAMON programming interface users can know if specific monitoring ops set
is registered or not using 'damon_is_registered_ops()', but there is no
such method for the user space.  To help the case, this commit adds a new
DAMON sysfs file called 'avail_operations' under each context directory
for listing available monitoring ops.  Reading the file will list each
registered monitoring ops on each line.

Link: https://lkml.kernel.org/r/20220426203843.45238-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops
+++ a/mm/damon/sysfs.c
@@ -1810,6 +1810,21 @@ static void damon_sysfs_context_rm_dirs(
 	kobject_put(&context->schemes->kobj);
 }
 
+static ssize_t avail_operations_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	enum damon_ops_id id;
+	int len = 0;
+
+	for (id = 0; id < NR_DAMON_OPS; id++) {
+		if (!damon_is_registered_ops(id))
+			continue;
+		len += sysfs_emit_at(buf, len, "%s\n",
+				damon_sysfs_ops_strs[id]);
+	}
+	return len;
+}
+
 static ssize_t operations_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -1840,10 +1855,14 @@ static void damon_sysfs_context_release(
 	kfree(container_of(kobj, struct damon_sysfs_context, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_context_avail_operations_attr =
+		__ATTR_RO_MODE(avail_operations, 0400);
+
 static struct kobj_attribute damon_sysfs_context_operations_attr =
 		__ATTR_RW_MODE(operations, 0600);
 
 static struct attribute *damon_sysfs_context_attrs[] = {
+	&damon_sysfs_context_avail_operations_attr.attr,
 	&damon_sysfs_context_operations_attr.attr,
 	NULL,
 };
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch

