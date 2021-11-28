Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8855AC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356808AbhK1BKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:10:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34510 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245022AbhK1BIA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:08:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ED1BB80B2F
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75751C53FAD;
        Sun, 28 Nov 2021 01:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061483;
        bh=l3mf/N/8LoJbZ/Gpuk3IuFEgGwjHUjxxlwhZoiWL8BE=;
        h=Date:From:To:Subject:From;
        b=AZSlhhDlsxTniTBV28Hr1H+ehBEBpyRjKql/5RyNBio2HTYHP4cby/o83uXU0bBKo
         RWLxkEH1jF428sHFyVVX5J8isK4aXeli025NWKdSd2cua23htY0vmZux+feRuVXS8g
         6i1tKY935blEIWNydbI+6xVcU3xPzIXTgJRmkCGc=
Date:   Sat, 27 Nov 2021 17:04:41 -0800
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
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, wangqing@vivo.com, yzaikin@google.com
Subject:  +
 sysctl-add-helper-to-register-a-sysctl-mount-point.patch added to -mm tree
Message-ID: <20211128010441.TUoaIZ63V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add helper to register a sysctl mount point
has been added to the -mm tree.  Its filename is
     sysctl-add-helper-to-register-a-sysctl-mount-point.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-add-helper-to-register-a-sysctl-mount-point.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-add-helper-to-register-a-sysctl-mount-point.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: sysctl: add helper to register a sysctl mount point

The way to create a subdirectory on top of sysctl_mount_point is a bit
obscure, and *why* we do that even so more.  Provide a helper which makes
it clear why we do this.

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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

 fs/proc/proc_sysctl.c  |   13 +++++++++++++
 include/linux/sysctl.h |    7 +++++++
 2 files changed, 20 insertions(+)

--- a/fs/proc/proc_sysctl.c~sysctl-add-helper-to-register-a-sysctl-mount-point
+++ a/fs/proc/proc_sysctl.c
@@ -35,6 +35,19 @@ struct ctl_table sysctl_mount_point[] =
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

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
sysctl-add-helper-to-register-a-sysctl-mount-point.patch
fs-move-binfmt_misc-sysctl-to-its-own-file.patch
sysctl-share-unsigned-long-const-values.patch

