Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C0EC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiAVGN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAVGN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEA1C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB4260FBB
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2B1C340E0;
        Sat, 22 Jan 2022 06:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832005;
        bh=FOrAgXA1bNmDcMw8+2eTMWt44iK65E39bgdPyOeUarc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YWiHXVATqCnsuF7RqLZQ/eO2JTHYpAkjpiazbmpHNPNoTU3Y5ZNzIDaJdn6h/lEpF
         DBJ1KDJs4PRKeYlEVYv//sUylSIsRMZEYOskW+KV97fqjvQLjQE78urT3SgJxsmGdr
         lyjCeBJtLyR7ZOftKjFM1sBOZaGphN9iAYaL4P4U=
Date:   Fri, 21 Jan 2022 22:13:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com,
        christian.brauner@ubuntu.com, crope@iki.fi, davem@davemloft.net,
        ebiederm@xmission.com, ebiggers@google.com, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 36/69] sysctl: add and use base directory declarer
 and registration helper
Message-ID: <20220122061324.JT83nC8-w%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: sysctl: add and use base directory declarer and registration helper

Patch series "sysctl: add and use base directory declarer and registration helper".

In this patch series we start addressing base directories, and so we start
with the "fs" sysctls.  The end goal is we end up completely moving all
"fs" sysctl knobs out from kernel/sysctl.


This patch (of 6):

Add a set of helpers which can be used to declare and register base
directory sysctls on their own.  We do this so we can later move each of
the base sysctl directories like "fs", "kernel", etc, to their own
respective files instead of shoving the declarations and registrations all
on kernel/sysctl.c.  The lazy approach has caught up and with this, we
just end up extending the list of base directories / sysctls on one file
and this makes maintenance difficult due to merge conflicts from many
developers.

The declarations are used first by kernel/sysctl.c for registration its
own base which over time we'll try to clean up.  It will be used in the
next patch to demonstrate how to cleanly deal with base sysctl
directories.

[mcgrof@kernel.org: null-terminate the ctl_table arrays]
  Link: https://lkml.kernel.org/r/YafJY3rXDYnjK/gs@bombadil.infradead.org
Link: https://lkml.kernel.org/r/20211129211943.640266-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211129211943.640266-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    9 ++++++++
 include/linux/sysctl.h |   24 ++++++++++++++++++++++
 kernel/sysctl.c        |   41 +++++++++------------------------------
 3 files changed, 43 insertions(+), 31 deletions(-)

--- a/fs/proc/proc_sysctl.c~sysctl-add-and-use-base-directory-declarer-and-registration-helper
+++ a/fs/proc/proc_sysctl.c
@@ -1646,6 +1646,15 @@ struct ctl_table_header *register_sysctl
 }
 EXPORT_SYMBOL(register_sysctl_table);
 
+int __register_sysctl_base(struct ctl_table *base_table)
+{
+	struct ctl_table_header *hdr;
+
+	hdr = register_sysctl_table(base_table);
+	kmemleak_not_leak(hdr);
+	return 0;
+}
+
 static void put_links(struct ctl_table_header *header)
 {
 	struct ctl_table_set *root_set = &sysctl_table_root.default_set;
--- a/include/linux/sysctl.h~sysctl-add-and-use-base-directory-declarer-and-registration-helper
+++ a/include/linux/sysctl.h
@@ -194,6 +194,20 @@ struct ctl_path {
 
 #ifdef CONFIG_SYSCTL
 
+#define DECLARE_SYSCTL_BASE(_name, _table)				\
+static struct ctl_table _name##_base_table[] = {			\
+	{								\
+		.procname	= #_name,				\
+		.mode		= 0555,					\
+		.child		= _table,				\
+	},								\
+	{ },								\
+}
+
+extern int __register_sysctl_base(struct ctl_table *base_table);
+
+#define register_sysctl_base(_name) __register_sysctl_base(_name##_base_table)
+
 void proc_sys_poll_notify(struct ctl_table_poll *poll);
 
 extern void setup_sysctl_set(struct ctl_table_set *p,
@@ -236,6 +250,16 @@ extern int no_unaligned_warning;
 extern struct ctl_table sysctl_mount_point[];
 
 #else /* CONFIG_SYSCTL */
+
+#define DECLARE_SYSCTL_BASE(_name, _table)
+
+static inline int __register_sysctl_base(struct ctl_table *base_table)
+{
+	return 0;
+}
+
+#define register_sysctl_base(table) __register_sysctl_base(table)
+
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
 {
 	return NULL;
--- a/kernel/sysctl.c~sysctl-add-and-use-base-directory-declarer-and-registration-helper
+++ a/kernel/sysctl.c
@@ -2851,41 +2851,20 @@ static struct ctl_table dev_table[] = {
 	{ }
 };
 
-static struct ctl_table sysctl_base_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= kern_table,
-	},
-	{
-		.procname	= "vm",
-		.mode		= 0555,
-		.child		= vm_table,
-	},
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
-	},
-	{
-		.procname	= "debug",
-		.mode		= 0555,
-		.child		= debug_table,
-	},
-	{
-		.procname	= "dev",
-		.mode		= 0555,
-		.child		= dev_table,
-	},
-	{ }
-};
+DECLARE_SYSCTL_BASE(kernel, kern_table);
+DECLARE_SYSCTL_BASE(vm, vm_table);
+DECLARE_SYSCTL_BASE(fs, fs_table);
+DECLARE_SYSCTL_BASE(debug, debug_table);
+DECLARE_SYSCTL_BASE(dev, dev_table);
 
 int __init sysctl_init(void)
 {
-	struct ctl_table_header *hdr;
+	register_sysctl_base(kernel);
+	register_sysctl_base(vm);
+	register_sysctl_base(fs);
+	register_sysctl_base(debug);
+	register_sysctl_base(dev);
 
-	hdr = register_sysctl_table(sysctl_base_table);
-	kmemleak_not_leak(hdr);
 	return 0;
 }
 #endif /* CONFIG_SYSCTL */
_
