Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC27CC61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 22:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjBIWPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBIWO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 17:14:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A0436FFE
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 14:14:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9368EB82296
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 22:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A288C433D2;
        Thu,  9 Feb 2023 22:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675980895;
        bh=0hMXidRiHYpHzzR+OJdLGcH/p9oi/BBJ2cKlNtAlWVA=;
        h=Date:To:From:Subject:From;
        b=uGRw8zdsJyf1JZe3AhGT5wFk5lensxsCUi0AHGtkBJPWm1uXYLVIK0ajzH+OCIbt8
         DkrE9twUVXLw/O5JkpA4j0yTBbyfMYfxnBUP7SUbNC+H/ryPFeGGA6pBYQGemA/dur
         5S+GIlI1auOQ316THCov6hNss4N29PhgjhXhC7NA=
Date:   Thu, 09 Feb 2023 14:14:54 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch added to mm-unstable branch
Message-Id: <20230209221455.3A288C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: print DAMON debugfs interface deprecation message
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

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

Link: https://lkml.kernel.org/r/20230209192009.7885-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message
+++ a/mm/damon/dbgfs.c
@@ -20,6 +20,11 @@ static int dbgfs_nr_ctxs;
 static struct dentry **dbgfs_dirs;
 static DEFINE_MUTEX(damon_dbgfs_lock);
 
+static void damon_dbgfs_warn_deprecation(void)
+{
+	pr_warn_once("DAMON debugfs interface is deprecated, so users should move to the sysfs interface (DAMON_SYSFS).  If you depend on this and cannot move, please report your usecase to damon@lists.linux.dev and linux-mm@kvack.org.\n");
+}
+
 /*
  * Returns non-empty string on success, negative error code otherwise.
  */
@@ -711,6 +716,8 @@ out:
 
 static int damon_dbgfs_open(struct inode *inode, struct file *file)
 {
+	damon_dbgfs_warn_deprecation();
+
 	file->private_data = inode->i_private;
 
 	return nonseekable_open(inode, file);
@@ -1039,15 +1046,24 @@ static ssize_t dbgfs_monitor_on_write(st
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

docs-admin-guide-mm-damon-usage-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-kconfig-add-damon-debugfs-interface-deprecation-notice.patch
mm-damon-dbgfs-print-damon-debugfs-interface-deprecation-message.patch

