Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B505CC636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjBMX41 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjBMXzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB4A19688
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F5876135D
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9933AC4339B;
        Mon, 13 Feb 2023 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332540;
        bh=1j16ZxNFe8Hi/dXZiqAw51RHcdVyFV7KUIFDTUe3ao8=;
        h=Date:To:From:Subject:From;
        b=GcqutjJHlaue39Bkwy7xAy6b38V6A3C4bJIh2jJzDz6576lJVquZGfkpGkq6yDnw/
         dFrKvv16l6FhMZ3q9UnQWkiS+xghXJ+Y7bBQWRbGVdRxHTg3b6/Em4bJW7uMSYJb03
         3QMeC8DTKPboPWqI/LEhVr1OjjBKaZeCt16wRMjY=
Date:   Mon, 13 Feb 2023 15:55:40 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch removed from -mm tree
Message-Id: <20230213235540.9933AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/dbgfs: print DAMON debugfs interface deprecation message
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: print DAMON debugfs interface deprecation message
Date: Thu, 9 Feb 2023 19:20:09 +0000

DAMON debugfs interface has announced to be deprecated after >v5.15 LTS
kernel is released.  And, v6.1.y has announced to be an LTS[1].

Though the announcement was there for a while, some people might not
noticed that so far.  Also, some users could depend on it and have
problems at  movng to the alternative (DAMON sysfs interface).

For such cases, warn DAMON debugfs interface deprecation with contacts
to ask helps when any DAMON debugfs interface file is opened.

[1] https://git.kernel.org/pub/scm/docs/kernel/website.git/commit/?id=332e9121320bc7461b2d3a79665caf153e51732c

[sj@kernel.org: split DAMON debugfs file open warning message, per Randy]
  Link: https://lkml.kernel.org/r/20230209192009.7885-4-sj@kernel.org
  Link: https://lkml.kernel.org/r/20230210044838.63723-4-sj@kernel.org
Link: https://lkml.kernel.org/r/20230209192009.7885-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message
+++ a/mm/damon/dbgfs.c
@@ -20,6 +20,14 @@ static int dbgfs_nr_ctxs;
 static struct dentry **dbgfs_dirs;
 static DEFINE_MUTEX(damon_dbgfs_lock);
 
+static void damon_dbgfs_warn_deprecation(void)
+{
+	pr_warn_once("DAMON debugfs interface is deprecated, "
+		     "so users should move to DAMON_SYSFS. If you cannot, "
+		     "please report your usecase to damon@lists.linux.dev and "
+		     "linux-mm@kvack.org.\n");
+}
+
 /*
  * Returns non-empty string on success, negative error code otherwise.
  */
@@ -711,6 +719,8 @@ out:
 
 static int damon_dbgfs_open(struct inode *inode, struct file *file)
 {
+	damon_dbgfs_warn_deprecation();
+
 	file->private_data = inode->i_private;
 
 	return nonseekable_open(inode, file);
@@ -1039,15 +1049,24 @@ static ssize_t dbgfs_monitor_on_write(st
 	return ret;
 }
 
+static int damon_dbgfs_static_file_open(struct inode *inode, struct file *file)
+{
+	damon_dbgfs_warn_deprecation();
+	return nonseekable_open(inode, file);
+}
+
 static const struct file_operations mk_contexts_fops = {
+	.open = damon_dbgfs_static_file_open,
 	.write = dbgfs_mk_context_write,
 };
 
 static const struct file_operations rm_contexts_fops = {
+	.open = damon_dbgfs_static_file_open,
 	.write = dbgfs_rm_context_write,
 };
 
 static const struct file_operations monitor_on_fops = {
+	.open = damon_dbgfs_static_file_open,
 	.read = dbgfs_monitor_on_read,
 	.write = dbgfs_monitor_on_write,
 };
_

Patches currently in -mm which might be from sj@kernel.org are


