Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD92C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiAWX4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:56:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51520 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240496AbiAWX4f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:56:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B1660C98
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA533C340E3;
        Sun, 23 Jan 2022 23:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982194;
        bh=pFmfvWjhmjjIWRpaWBJvIY6MK14swiVRndw0WLiEPUA=;
        h=Date:From:To:Subject:From;
        b=zbjV1EnohNeF4QQZHYyzZBh1oLRXsd/BB3OKGcoO8RZXzgXNZxV7m/uRACMqMgUyK
         84/u6dw4Gnrn9ksNkgIHgT++dGAoN2CrI+e+6mq1Skj58BWEO+20je3DilDmA2TefJ
         JVZt6NGEstGQcRt94dbYCHL7VsthxHdKvEFyGQ0A=
Date:   Sun, 23 Jan 2022 15:56:32 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        mark@fasheh.com, martin.petersen@oracle.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org,
        phil@philpotter.co.uk, pjt@google.com, pmladek@suse.com,
        rafael@kernel.org, rodrigo.vivi@intel.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, sre@kernel.org, steve@sk2.org,
        surenb@google.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  [merged]
 sysctl-add-helper-to-register-a-sysctl-mount-point.patch removed from -mm
 tree
Message-ID: <20220123235632.ul4uVOftf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add helper to register a sysctl mount point
has been removed from the -mm tree.  Its filename was
     sysctl-add-helper-to-register-a-sysctl-mount-point.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: sysctl: add helper to register a sysctl mount point

The way to create a subdirectory on top of sysctl_mount_point is a bit
obscure, and *why* we do that even so more.  Provide a helper which makes
it clear why we do this.

[akpm@linux-foundation.org: export register_sysctl_mount_point() to modules]
Link: https://lkml.kernel.org/r/20211124231435.1445213-4-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |   14 ++++++++++++++
 include/linux/sysctl.h |    7 +++++++
 2 files changed, 21 insertions(+)

--- a/fs/proc/proc_sysctl.c~sysctl-add-helper-to-register-a-sysctl-mount-point
+++ a/fs/proc/proc_sysctl.c
@@ -35,6 +35,20 @@ struct ctl_table sysctl_mount_point[] =
 	{ }
 };
 
+/**
+ * register_sysctl_mount_point() - registers a sysctl mount point
+ * @path: path for the mount point
+ *
+ * Used to create a permanently empty directory to serve as mount point.
+ * There are some subtle but important permission checks this allows in the
+ * case of unprivileged mounts.
+ */
+struct ctl_table_header *register_sysctl_mount_point(const char *path)
+{
+	return register_sysctl(path, sysctl_mount_point);
+}
+EXPORT_SYMBOL(register_sysctl_mount_point);
+
 static bool is_empty_dir(struct ctl_table_header *head)
 {
 	return head->ctl_table[0].child == sysctl_mount_point;
--- a/include/linux/sysctl.h~sysctl-add-helper-to-register-a-sysctl-mount-point
+++ a/include/linux/sysctl.h
@@ -209,6 +209,8 @@ extern int sysctl_init(void);
 extern void __register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name);
 #define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
+extern struct ctl_table_header *register_sysctl_mount_point(const char *path);
+
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
@@ -223,6 +225,11 @@ static inline struct ctl_table_header *r
 {
 	return NULL;
 }
+
+static inline struct sysctl_header *register_sysctl_mount_point(const char *path)
+{
+	return NULL;
+}
 
 static inline struct ctl_table_header *register_sysctl_paths(
 			const struct ctl_path *path, struct ctl_table *table)
_

Patches currently in -mm which might be from mcgrof@kernel.org are


