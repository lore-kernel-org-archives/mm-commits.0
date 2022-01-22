Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C82C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiAVGM0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiAVGM0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAB4C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C85560C5D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A23C340E4;
        Sat, 22 Jan 2022 06:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831945;
        bh=UPmbSMh7QphyG3WMf24B9AsIcfJqmYQrWbAqNXon6f4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k04CIHSp4U0tSHL75astEEyTION0Jn1aK7rx+L1fHzDIen/VpPf9oz57BJVHWk/Ey
         gxhUCU41UE0sVN6jNjUBdEy6IdaOTsvInLTjj41JUTDwNDWe9Zqg/fOL7HY+JgS96M
         DXbYEk11WWNzD0RvEiGZsdqxWOq9u0vYDPq7WNbY=
Date:   Fri, 21 Jan 2022 22:12:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mark@fasheh.com, martin.petersen@oracle.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, torvalds@linux-foundation.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk, wangqing@vivo.com,
        yzaikin@google.com
Subject:  [patch 21/69] sysctl: add helper to register a sysctl
 mount point
Message-ID: <20220122061223.m4kWDxt5y%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
