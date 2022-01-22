Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788A0C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiAVGNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43960 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGNg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E93E60FB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43328C004E1;
        Sat, 22 Jan 2022 06:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832015;
        bh=cIGG0JpRHjSN1E9Wba5CzZDpZUgTiuPImtGCAuN8YDU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qY3ev5W9XUHB++tXBakSRwqVRVKW+k5+Ny1VzZrKGWe+zg90Gpi6Zs8Gsri+pjdF3
         x2ERqshzAhvuL1e1EI9vwMaAJvOHXAqnS9zfuyq90q7j1n+njrvDLxxrFX/vff3I+T
         FxzXICo+hn+UtwA+Ab73sazn1X4RinSglhLFppRQ=
Date:   Fri, 21 Jan 2022 22:13:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com,
        christian.brauner@ubuntu.com, crope@iki.fi, davem@davemloft.net,
        ebiederm@xmission.com, ebiggers@google.com, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 39/69] printk: fix build warning when
 CONFIG_PRINTK=n
Message-ID: <20220122061334.TbZe0CqSn%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: printk: fix build warning when CONFIG_PRINTK=n

build warning when CONFIG_PRINTK=n
	kernel/printk/printk.c:175:5: warning: no previous prototype for
	 'devkmsg_sysctl_set_loglvl' [-Wmissing-prototypes]

devkmsg_sysctl_set_loglvl() is only used in sysctl.c when CONFIG_PRINTK=y,
but it participates in the build when CONFIG_PRINTK=n.  So add compile
dependency CONFIG_PRINTK=y && CONFIG_SYSCTL=y to fix the build warning.

Link: https://lkml.kernel.org/r/20211129211943.640266-5-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Stephen Kitt <steve@sk2.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h   |    4 ----
 kernel/printk/internal.h |    2 ++
 kernel/printk/printk.c   |    3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/printk.h~printk-fix-build-warning-when-config_printk=n
+++ a/include/linux/printk.h
@@ -183,10 +183,6 @@ extern bool printk_timed_ratelimit(unsig
 extern int printk_delay_msec;
 extern int dmesg_restrict;
 
-extern int
-devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write, void *buf,
-			  size_t *lenp, loff_t *ppos);
-
 extern void wake_up_klogd(void);
 
 char *log_buf_addr_get(void);
--- a/kernel/printk/internal.h~printk-fix-build-warning-when-config_printk=n
+++ a/kernel/printk/internal.h
@@ -6,6 +6,8 @@
 
 #if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
 void __init printk_sysctl_init(void);
+int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos);
 #else
 #define printk_sysctl_init() do { } while (0)
 #endif
--- a/kernel/printk/printk.c~printk-fix-build-warning-when-config_printk=n
+++ a/kernel/printk/printk.c
@@ -171,7 +171,7 @@ static int __init control_devkmsg(char *
 __setup("printk.devkmsg=", control_devkmsg);
 
 char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE] = "ratelimit";
-
+#if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
 int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -210,6 +210,7 @@ int devkmsg_sysctl_set_loglvl(struct ctl
 
 	return 0;
 }
+#endif /* CONFIG_PRINTK && CONFIG_SYSCTL */
 
 /* Number of registered extended console drivers. */
 static int nr_ext_console_drivers;
_
