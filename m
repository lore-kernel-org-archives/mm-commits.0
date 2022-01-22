Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7DDC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiAVGLW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:11:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41368 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiAVGLW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:11:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7D360C5D
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24317C004E1;
        Sat, 22 Jan 2022 06:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831881;
        bh=nnl05lhlnxDMaNqi7wrSEfArfcP+xsixck5h9cMZ+xY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p5ejStsVMtsdSUxQW7P0kBcg4LAuQfRfk6L1XUEtWdjcS8MarxMnvZ7kKlsuiMlQy
         n7pSX9zcRuPV1Se957HJ8mGnS1/3Fp+WnD0tmNsZkOGrEjlWGpw2+F4p6BvM30brK6
         Zf8/Tnv8KzqB7ubxWgk73rN4QQBuA6k0yz1BvF/8=
Date:   Fri, 21 Jan 2022 22:11:19 -0800
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
Subject:  [patch 08/69] sysctl: use SYSCTL_ZERO to replace some
 static int zero uses
Message-ID: <20220122061119.UbG9LtVZO%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: sysctl: use SYSCTL_ZERO to replace some static int zero uses

Use the variable SYSCTL_ZERO to replace some static int boundary variables
with a value of 0 (minolduid, min_extfrag_threshold,
min_wakeup_granularity_ns).

Link: https://lkml.kernel.org/r/20211123202347.818157-8-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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

 kernel/sysctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sysctl.c~sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses
+++ a/kernel/sysctl.c
@@ -123,7 +123,7 @@ static const unsigned long dirty_bytes_m
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static const int maxolduid = 65535;
-static const int minolduid;
+/* minolduid is SYSCTL_ZERO */
 
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -171,7 +171,7 @@ int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_COMPACTION
-static const int min_extfrag_threshold;
+/* min_extfrag_threshold is SYSCTL_ZERO */;
 static const int max_extfrag_threshold = 1000;
 #endif
 
@@ -2176,7 +2176,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 	{
@@ -2185,7 +2185,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_S390
@@ -2759,7 +2759,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&min_extfrag_threshold,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&max_extfrag_threshold,
 	},
 	{
@@ -3071,7 +3071,7 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 	{
@@ -3080,7 +3080,7 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_FILE_LOCKING
_
