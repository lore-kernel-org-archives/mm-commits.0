Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B18C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8211C61105
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 22:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhJMWye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 18:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhJMWye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 18:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D9B6101E;
        Wed, 13 Oct 2021 22:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634165550;
        bh=rtMWQq2BPN+/ZypHCMJCWsLLwf6QlJa2hZK4QYs9cnA=;
        h=Date:From:To:Subject:From;
        b=AvUFVXup2FRGXEJ0NDU0cT+5mDHg1L2w+dQa0gAJW4+UIqOatfagCDdtn+KeEv5/M
         /9L6VS+EDE39IQxmRSI+c1paP9ULX1JYfnbptvaQSp2AuJuun13spJTD1YR3d6DTyY
         sjlGs40vi/nu+Y6JtSnnlLOUCaCkeQYjOhWFxkOE=
Date:   Wed, 13 Oct 2021 15:52:29 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org,
        brendanhiggins@google.com, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  + mm-damon-dbgfs-support-physical-memory-monitoring.patch
 added to -mm tree
Message-ID: <20211013225229.gtpKO72cU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: support physical memory monitoring
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-support-physical-memory-monitoring.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-support-physical-memory-monitoring.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-support-physical-memory-monitoring.patch

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
Subject: mm/damon/dbgfs: support physical memory monitoring

This commit makes the 'damon-dbgfs' to support the physical memory
monitoring, in addition to the virtual memory monitoring.

Users can do the physical memory monitoring by writing a special keyword,
'paddr' to the 'target_ids' debugfs file.  Then, DAMON will check the
special keyword and configure the monitoring context to run with the
primitives for the physical address space.

Unlike the virtual memory monitoring, the monitoring target region will
not be automatically set.  Therefore, users should also set the monitoring
target address region using the 'init_regions' debugfs file.

Also, note that the physical memory monitoring will not automatically
terminated.  The user should explicitly turn off the monitoring by writing
'off' to the 'monitor_on' debugfs file.

Link: https://lkml.kernel.org/r/20211012205711.29216-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 mm/damon/dbgfs.c |   21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-support-physical-memory-monitoring
+++ a/mm/damon/dbgfs.c
@@ -339,6 +339,7 @@ static ssize_t dbgfs_target_ids_write(st
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
+	bool id_is_pid = true;
 	char *kbuf, *nrs;
 	unsigned long *targets;
 	ssize_t nr_targets;
@@ -351,6 +352,11 @@ static ssize_t dbgfs_target_ids_write(st
 		return PTR_ERR(kbuf);
 
 	nrs = kbuf;
+	if (!strncmp(kbuf, "paddr\n", count)) {
+		id_is_pid = false;
+		/* target id is meaningless here, but we set it just for fun */
+		scnprintf(kbuf, count, "42    ");
+	}
 
 	targets = str_to_target_ids(nrs, ret, &nr_targets);
 	if (!targets) {
@@ -358,7 +364,7 @@ static ssize_t dbgfs_target_ids_write(st
 		goto out;
 	}
 
-	if (targetid_is_pid(ctx)) {
+	if (id_is_pid) {
 		for (i = 0; i < nr_targets; i++) {
 			targets[i] = (unsigned long)find_get_pid(
 					(int)targets[i]);
@@ -372,15 +378,24 @@ static ssize_t dbgfs_target_ids_write(st
 
 	mutex_lock(&ctx->kdamond_lock);
 	if (ctx->kdamond) {
-		if (targetid_is_pid(ctx))
+		if (id_is_pid)
 			dbgfs_put_pids(targets, nr_targets);
 		ret = -EBUSY;
 		goto unlock_out;
 	}
 
+	/* remove targets with previously-set primitive */
+	damon_set_targets(ctx, NULL, 0);
+
+	/* Configure the context for the address space type */
+	if (id_is_pid)
+		damon_va_set_primitives(ctx);
+	else
+		damon_pa_set_primitives(ctx);
+
 	err = damon_set_targets(ctx, targets, nr_targets);
 	if (err) {
-		if (targetid_is_pid(ctx))
+		if (id_is_pid)
 			dbgfs_put_pids(targets, nr_targets);
 		ret = err;
 	}
--- a/mm/damon/Kconfig~mm-damon-dbgfs-support-physical-memory-monitoring
+++ a/mm/damon/Kconfig
@@ -54,7 +54,7 @@ config DAMON_VADDR_KUNIT_TEST
 
 config DAMON_DBGFS
 	bool "DAMON debugfs interface"
-	depends on DAMON_VADDR && DEBUG_FS
+	depends on DAMON_VADDR && DAMON_PADDR && DEBUG_FS
 	help
 	  This builds the debugfs interface for DAMON.  The user space admins
 	  can use the interface for arbitrary data access monitoring.
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch

