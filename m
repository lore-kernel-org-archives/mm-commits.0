Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807A7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhKXAQ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240625AbhKXAQ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60FF460F6F;
        Wed, 24 Nov 2021 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712827;
        bh=kHrpBbffm+cFClBm2u13SKfcldx8WrXokCix4fEZSEI=;
        h=Date:From:To:Subject:From;
        b=RqtwUg7QhJMXlSpPZ2Eo/gS/dBB8bDPsA0/CJmFG/Qog3lua7jNxR77GqgrdVpCeO
         rq3AlQTRbCPeNyAcpy4hyVWLziuI39ciYs8DKX5M+cVBXOW7coSwxJZwu9IkWVxgz/
         AF0NBTvIFLp3GHlDLBxwu92G2lHV4xMZ/+ImHb78=
Date:   Tue, 23 Nov 2021 16:13:45 -0800
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
Subject:  + sysctl-make-ngroups_max-const.patch added to -mm tree
Message-ID: <20211124001345.7ldB7oD14%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: make ngroups_max const
has been added to the -mm tree.  Its filename is
     sysctl-make-ngroups_max-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-make-ngroups_max-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-make-ngroups_max-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Kitt <steve@sk2.org>
Subject: sysctl: make ngroups_max const

ngroups_max is a read-only sysctl entry, reflecting NGROUPS_MAX.  Make it
const, in the same way as cap_last_cap.

Link: https://lkml.kernel.org/r/20211123202347.818157-6-mcgrof@kernel.org
Signed-off-by: Stephen Kitt <steve@sk2.org>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
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

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sysctl.c~sysctl-make-ngroups_max-const
+++ a/kernel/sysctl.c
@@ -124,7 +124,7 @@ static unsigned long dirty_bytes_min = 2
 static int maxolduid = 65535;
 static int minolduid;
 
-static int ngroups_max = NGROUPS_MAX;
+static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
 
@@ -2290,7 +2290,7 @@ static struct ctl_table kern_table[] = {
 #endif
 	{
 		.procname	= "ngroups_max",
-		.data		= &ngroups_max,
+		.data		= (void *)&ngroups_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
_

Patches currently in -mm which might be from steve@sk2.org are

sysctl-make-ngroups_max-const.patch

