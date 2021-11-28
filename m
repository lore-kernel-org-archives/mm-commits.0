Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F147C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhK1BKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356795AbhK1BIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:08:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D78EC06174A
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 17:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E10B80B35
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D26C53FAD;
        Sun, 28 Nov 2021 01:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061506;
        bh=0HGN6YaIpBBPLUm0QrigPAPlseA/uLP8kSX0tO/z3zg=;
        h=Date:From:To:Subject:From;
        b=rll/+72zUYKiY4pCtuzDZcG0oHXkOtH4Uw3vznm36TlgDtlNNKzN1SBaDQlt81iMV
         CriFpYSUB2IoRnadwhzCGDrVEKUOx1QWKYccPdSt2iqafmScV9rX9hCFVygjh/bjCU
         54npXoMIoAlkI84NbeDiITo1cwFa+MbnO2MPtXJg=
Date:   Sat, 27 Nov 2021 17:05:05 -0800
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
Subject:  + sysctl-share-unsigned-long-const-values.patch added to
 -mm tree
Message-ID: <20211128010505.6FHJE3s87%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: share unsigned long const values
has been added to the -mm tree.  Its filename is
     sysctl-share-unsigned-long-const-values.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-share-unsigned-long-const-values.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-share-unsigned-long-const-values.patch

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
Subject: sysctl: share unsigned long const values

Provide a way to share unsigned long values.  This will allow others to
not have to re-invent these values.

Link: https://lkml.kernel.org/r/20211124231435.1445213-9-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
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
Cc: Eric Biederman <ebiederm@xmission.com>
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

 fs/proc/proc_sysctl.c  |    3 +++
 include/linux/sysctl.h |    6 ++++++
 kernel/sysctl.c        |    9 +++------
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/fs/proc/proc_sysctl.c~sysctl-share-unsigned-long-const-values
+++ a/fs/proc/proc_sysctl.c
@@ -29,6 +29,9 @@ static const struct inode_operations pro
 const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
 EXPORT_SYMBOL(sysctl_vals);
 
+const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
+EXPORT_SYMBOL_GPL(sysctl_long_vals);
+
 /* Support for permanently empty directories */
 
 struct ctl_table sysctl_mount_point[] = {
--- a/include/linux/sysctl.h~sysctl-share-unsigned-long-const-values
+++ a/include/linux/sysctl.h
@@ -51,6 +51,12 @@ struct ctl_dir;
 
 extern const int sysctl_vals[];
 
+#define SYSCTL_LONG_ZERO	((void *)&sysctl_long_vals[0])
+#define SYSCTL_LONG_ONE		((void *)&sysctl_long_vals[1])
+#define SYSCTL_LONG_MAX		((void *)&sysctl_long_vals[2])
+
+extern const unsigned long sysctl_long_vals[];
+
 typedef int proc_handler(struct ctl_table *ctl, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
 
--- a/kernel/sysctl.c~sysctl-share-unsigned-long-const-values
+++ a/kernel/sysctl.c
@@ -99,9 +99,6 @@
 
 /* Constants used for minimum and  maximum */
 
-static const unsigned long zero_ul;
-static const unsigned long one_ul = 1;
-static const unsigned long long_max = LONG_MAX;
 #ifdef CONFIG_PRINTK
 static const int ten_thousand = 10000;
 #endif
@@ -2512,7 +2509,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= (void *)&one_ul,
+		.extra1		= SYSCTL_LONG_ONE,
 	},
 	{
 		.procname	= "dirty_ratio",
@@ -2930,8 +2927,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= (void *)&zero_ul,
-		.extra2		= (void *)&long_max,
+		.extra1		= SYSCTL_LONG_ZERO,
+		.extra2		= SYSCTL_LONG_MAX,
 	},
 	{
 		.procname	= "nr_open",
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

