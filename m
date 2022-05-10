Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFC3C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiEJEWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbiEJEUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E145A2AED86
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D58E6176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6055C385C2;
        Tue, 10 May 2022 04:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156130;
        bh=DWX0wZrSd07nExqvZkR6mxP8MhImHA/2vRP03kT73HM=;
        h=Date:To:From:Subject:From;
        b=qA3QV++AR/dhDRnd+ABQRC85tc/Dn+1E5QdrYsgu7YBTSDr/UpXnVInGQh/vSBA1v
         4ibqSYJFsD9YPmYztUfUWQUJ7W2vBog5wWmwez8OqNkUNd4+ThT+iHUR2YAcGA8eDi
         u0fv0kGaX5J7chOc0uoNUbfzICUtQQReHJ3UxCFU=
Date:   Mon, 09 May 2022 21:15:30 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch removed from -mm tree
Message-Id: <20220510041530.D6055C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: add a file for listing available monitoring ops
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch

This patch was dropped because it was merged into mm-stable

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


