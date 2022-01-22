Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CA1C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiAVGKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiAVGKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:10:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D69C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2E0660C5D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0476C340E0;
        Sat, 22 Jan 2022 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831852;
        bh=KfGTioAsbpw026tqjEeIR2WGzHLX3gglbUet5+Lx/ag=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k2s9MmA9O9Q2yZWrNrTpeh5DhYmrXgFWSRySXxhLNymdfbLfMx0USrIYy+eKraKOf
         N/Gu0rH35fLfvbaXk0bPjrLZuQmswyMpffAR8EYFOFed9ISyCjabNkb9E/u8vTQSym
         9NJm96+7fan9A8UgvZcc2QKRC1ZmMZ4NB8vjL1jY=
Date:   Fri, 21 Jan 2022 22:10:50 -0800
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
Subject:  [patch 02/69] sysctl: add a new register_sysctl_init()
 interface
Message-ID: <20220122061050.iP3ldL9Os%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: sysctl: add a new register_sysctl_init() interface

Patch series "sysctl: first set of kernel/sysctl cleanups", v2.

Finally had time to respin the series of the work we had started last year
on cleaning up the kernel/sysct.c kitchen sink.  People keeps stuffing
their sysctls in that file and this creates a maintenance burden.  So this
effort is aimed at placing sysctls where they actually belong.

I'm going to split patches up into series as there is quite a bit of work.

This first set adds register_sysctl_init() for uses of registerting a
sysctl on the init path, adds const where missing to a few places,
generalizes common values so to be more easy to share, and starts the move
of a few kernel/sysctl.c out where they belong.

The majority of rework on v2 in this first patch set is 0-day fixes.  Eric
W.  Biederman's feedback is later addressed in subsequent patch sets.

I'll only post the first two patch sets for now.  We can address the rest
once the first two patch sets get completely reviewed / Acked.


This patch (of 9):

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

Today though folks heavily rely on tables on kernel/sysctl.c so they can
easily just extend this table with their needed sysctls.  In order to help
users move their sysctls out we need to provide a helper which can be used
during code initialization.

We special-case the initialization use of register_sysctl() since it *is*
safe to fail, given all that sysctls do is provide a dynamic interface to
query or modify at runtime an existing variable.  So the use case of
register_sysctl() on init should *not* stop if the sysctls don't end up
getting registered.  It would be counter productive to stop boot if a
simple sysctl registration failed.

Provide a helper for init then, and document the recommended init levels
to use for callers of this routine.  We will later use this in subsequent
patches to start slimming down kernel/sysctl.c tables and moving sysctl
registration to the code which actually needs these sysctls.

[mcgrof@kernel.org: major commit log and documentation rephrasing also moved to fs/proc/proc_sysctl.c                  ]
Link: https://lkml.kernel.org/r/20211123202347.818157-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211123202347.818157-2-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Turner <pjt@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |   33 +++++++++++++++++++++++++++++++++
 include/linux/sysctl.h |    3 +++
 2 files changed, 36 insertions(+)

--- a/fs/proc/proc_sysctl.c~sysctl-add-a-new-register_sysctl_init-interface
+++ a/fs/proc/proc_sysctl.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/mount.h>
+#include <linux/kmemleak.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1383,6 +1384,38 @@ struct ctl_table_header *register_sysctl
 }
 EXPORT_SYMBOL(register_sysctl);
 
+/**
+ * __register_sysctl_init() - register sysctl table to path
+ * @path: path name for sysctl base
+ * @table: This is the sysctl table that needs to be registered to the path
+ * @table_name: The name of sysctl table, only used for log printing when
+ *              registration fails
+ *
+ * The sysctl interface is used by userspace to query or modify at runtime
+ * a predefined value set on a variable. These variables however have default
+ * values pre-set. Code which depends on these variables will always work even
+ * if register_sysctl() fails. If register_sysctl() fails you'd just loose the
+ * ability to query or modify the sysctls dynamically at run time. Chances of
+ * register_sysctl() failing on init are extremely low, and so for both reasons
+ * this function does not return any error as it is used by initialization code.
+ *
+ * Context: Can only be called after your respective sysctl base path has been
+ * registered. So for instance, most base directories are registered early on
+ * init before init levels are processed through proc_sys_init() and
+ * sysctl_init().
+ */
+void __init __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name)
+{
+	struct ctl_table_header *hdr = register_sysctl(path, table);
+
+	if (unlikely(!hdr)) {
+		pr_err("failed when register_sysctl %s to %s\n", table_name, path);
+		return;
+	}
+	kmemleak_not_leak(hdr);
+}
+
 static char *append_path(const char *path, char *pos, const char *name)
 {
 	int namelen;
--- a/include/linux/sysctl.h~sysctl-add-a-new-register_sysctl_init-interface
+++ a/include/linux/sysctl.h
@@ -199,6 +199,9 @@ struct ctl_table_header *register_sysctl
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+extern void __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name);
+#define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
_
