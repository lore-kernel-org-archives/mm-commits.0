Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BA6C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiAVGMd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53978 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiAVGMc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B02CCB81FCB
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26C6C004E1;
        Sat, 22 Jan 2022 06:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831950;
        bh=EtmeLJef+Wm5mN+Nfdd85JrWXCA3/cMXVKE5Ob79Oa8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q6C8JWP9lI22Qh8sKUz5luVEOJYnd4HRDe17Iord11jrYxRlyhF0TsNoh/dIHBnKw
         RIWKsrf8lNitTuQiegflmogIrihVl9vHREqzjvw5FUaWmEXCGUvm+uwB/Df+cO5i7D
         HaNSRK/twywluCb5yjsewzmezLoaeAFtvZL7JdtQ=
Date:   Fri, 21 Jan 2022 22:12:28 -0800
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
Subject:  [patch 22/69] fs: move binfmt_misc sysctl to its own file
Message-ID: <20220122061228.nmuo75sDn%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move binfmt_misc sysctl to its own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

This moves the binfmt_misc sysctl to its own file to help remove clutter
from kernel/sysctl.c.

Link: https://lkml.kernel.org/r/20211124231435.1445213-5-mcgrof@kernel.org
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

 fs/binfmt_misc.c |    6 +++++-
 kernel/sysctl.c  |    7 -------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/fs/binfmt_misc.c~fs-move-binfmt_misc-sysctl-to-its-own-file
+++ a/fs/binfmt_misc.c
@@ -822,7 +822,11 @@ static int __init init_misc_binfmt(void)
 	int err = register_filesystem(&bm_fs_type);
 	if (!err)
 		insert_binfmt(&misc_format);
-	return err;
+	if (!register_sysctl_mount_point("fs/binfmt_misc")) {
+		pr_warn("Failed to create fs/binfmt_misc sysctl mount point");
+		return -ENOMEM;
+	}
+	return 0;
 }
 
 static void __exit exit_misc_binfmt(void)
--- a/kernel/sysctl.c~fs-move-binfmt_misc-sysctl-to-its-own-file
+++ a/kernel/sysctl.c
@@ -3127,13 +3127,6 @@ static struct ctl_table fs_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
 	},
-#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-	{
-		.procname	= "binfmt_misc",
-		.mode		= 0555,
-		.child		= sysctl_mount_point,
-	},
-#endif
 	{
 		.procname	= "pipe-max-size",
 		.data		= &pipe_max_size,
_
