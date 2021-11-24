Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89734C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbhKXARE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240606AbhKXARE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:17:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698A060FE6;
        Wed, 24 Nov 2021 00:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712835;
        bh=gtxtwgIAhW+cgz+IEhK48QAgz6N1u8N0b+iOA0D4Y1k=;
        h=Date:From:To:Subject:From;
        b=uSfCKNbZkGGU0MS/20JEVYC2QwqsjrCm077URsQv7WcW9WUsF8CSsPY6xTaH/kqkB
         MRONcV3QTojAEgBtkphXDE0eA5me1HQl9LoB0Nk1PwI65m8EBCwy6ZB1KI7nWgIJ4D
         7pMnZvhEh0/3tUh00PRlqVKsfPDBqW92Jm19MP3g=
Date:   Tue, 23 Nov 2021 16:13:53 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        ebiederm@xmission.com, gregkh@linuxfoundation.org, jack@suse.cz,
        jani.nikula@linux.intel.com, jlbec@evilplan.org,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        liu.hailong6@zte.com.cn, mark@fasheh.com, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rodrigo.vivi@intel.com, senozhatsky@chromium.org,
        sre@kernel.org, steve@sk2.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  +
 sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch added to
 -mm tree
Message-ID: <20211124001353.nUBugunpB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use SYSCTL_ZERO to replace some static int zero uses
has been added to the -mm tree.  Its filename is
     sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Hailong Liu <liu.hailong6@zte.com.cn>
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/kernel/sysctl.c~sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses
+++ a/kernel/sysctl.c
@@ -122,7 +122,7 @@ static const unsigned long dirty_bytes_m
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static const int maxolduid = 65535;
-static const int minolduid;
+/* minolduid is SYSCTL_ZERO */
 
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -170,7 +170,7 @@ int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_COMPACTION
-static const int min_extfrag_threshold;
+/* min_extfrag_threshold is SYSCTL_ZERO */;
 static const int max_extfrag_threshold = 1000;
 #endif
 
@@ -2175,7 +2175,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 	{
@@ -2184,7 +2184,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_S390
@@ -2758,7 +2758,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&min_extfrag_threshold,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&max_extfrag_threshold,
 	},
 	{
@@ -3070,7 +3070,7 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 	{
@@ -3079,7 +3079,7 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&minolduid,
+		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_FILE_LOCKING
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

sysctl-add-a-new-register_sysctl_init-interface.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals.patch
hung_task-move-hung_task-sysctl-interface-to-hung_taskc.patch
watchdog-move-watchdog-sysctl-interface-to-watchdogc.patch
sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch
sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch
aio-move-aio-sysctl-to-aioc.patch
dnotify-move-dnotify-sysctl-to-dnotifyc.patch
inotify-simplify-subdirectory-registration-with-register_sysctl.patch
eventpoll-simplify-sysctl-declaration-with-register_sysctl.patch

