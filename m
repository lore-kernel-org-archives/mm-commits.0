Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C30C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhKXAR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240645AbhKXARk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C1B610A0;
        Wed, 24 Nov 2021 00:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712871;
        bh=dJHaJgyFmz6+tqbJJM85E53H2prMTTKuWFKRwx2z+rE=;
        h=Date:From:To:Subject:From;
        b=aAxQ5734iAdbH9R1SGOmid+ISLIPejWhc3ykbhwIRwrjmN2kFQY9Te4NEO1PJ1E0b
         U4EHirUYSWvdp/CVorgnGp17SAEa+w8IuLlnImRI2uic9NRv5UBu8uV2WCtZZdu7Yi
         dYLRF2qAZPGY6C0wQ93XBVTTbag9it0R3MKpBMVI=
Date:   Tue, 23 Nov 2021 16:14:29 -0800
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
 cdrom-simplify-subdirectory-registration-with-register_sysctl.patch added
 to -mm tree
Message-ID: <20211124001429.K6-Q3hVSI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cdrom: simplify subdirectory registration with register_sysctl()
has been added to the -mm tree.  Its filename is
     cdrom-simplify-subdirectory-registration-with-register_sysctl.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cdrom-simplify-subdirectory-registration-with-register_sysctl.patch

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
Subject: cdrom: simplify subdirectory registration with register_sysctl()

There is no need to user boiler plate code to specify a set of base
directories we're going to stuff sysctls under.  Simplify this by using
register_sysctl() and specifying the directory path directly.

// pycocci sysctl-subdir-register-sysctl-simplify.cocci PATH

@c1@
expression E1;
identifier subdir, sysctls;
@@

static struct ctl_table subdir[] = {
	{
		.procname = E1,
		.maxlen = 0,
		.mode = 0555,
		.child = sysctls,
	},
	{ }
};

@c2@
identifier c1.subdir;

expression E2;
identifier base;
@@

static struct ctl_table base[] = {
	{
		.procname = E2,
		.maxlen = 0,
		.mode = 0555,
		.child = subdir,
	},
	{ }
};

@c3@
identifier c2.base;
identifier header;
@@

header = register_sysctl_table(base);

@r1 depends on c1 && c2 && c3@
expression c1.E1;
identifier c1.subdir, c1.sysctls;
@@

-static struct ctl_table subdir[] = {
-	{
-		.procname = E1,
-		.maxlen = 0,
-		.mode = 0555,
-		.child = sysctls,
-	},
-	{ }
-};

@r2 depends on c1 && c2 && c3@
identifier c1.subdir;

expression c2.E2;
identifier c2.base;
@@
-static struct ctl_table base[] = {
-	{
-		.procname = E2,
-		.maxlen = 0,
-		.mode = 0555,
-		.child = subdir,
-	},
-	{ }
-};

@initialize:python@
@@

def make_my_fresh_expression(s1, s2):
  return '"' + s1.strip('"') + "/" + s2.strip('"') + '"'

@r3 depends on c1 && c2 && c3@
expression c1.E1;
identifier c1.sysctls;
expression c2.E2;
identifier c2.base;
identifier c3.header;
fresh identifier E3 = script:python(E2, E1) { make_my_fresh_expression(E2, E1) };
@@

header =
-register_sysctl_table(base);
+register_sysctl(E3, sysctls);

Generated-by: Coccinelle SmPL
Link: https://lkml.kernel.org/r/20211123202422.819032-8-mcgrof@kernel.org
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
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hailong Liu <liu.hailong6@zte.com.cn>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

--- a/drivers/cdrom/cdrom.c~cdrom-simplify-subdirectory-registration-with-register_sysctl
+++ a/drivers/cdrom/cdrom.c
@@ -3691,27 +3691,6 @@ static struct ctl_table cdrom_table[] =
 	},
 	{ }
 };
-
-static struct ctl_table cdrom_cdrom_table[] = {
-	{
-		.procname	= "cdrom",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_table,
-	},
-	{ }
-};
-
-/* Make sure that /proc/sys/dev is there */
-static struct ctl_table cdrom_root_table[] = {
-	{
-		.procname	= "dev",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_cdrom_table,
-	},
-	{ }
-};
 static struct ctl_table_header *cdrom_sysctl_header;
 
 static void cdrom_sysctl_register(void)
@@ -3721,7 +3700,7 @@ static void cdrom_sysctl_register(void)
 	if (!atomic_add_unless(&initialized, 1, 1))
 		return;
 
-	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
+	cdrom_sysctl_header = register_sysctl("dev/cdrom", cdrom_table);
 
 	/* set the defaults */
 	cdrom_sysctl_settings.autoclose = autoclose;
_

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch

