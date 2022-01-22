Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FFBC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiAVGNc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAVGNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40875C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 090D8B820FE
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BD4C004E1;
        Sat, 22 Jan 2022 06:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832008;
        bh=q4+fkyJpwQK88z7AbihmJeMFqamWTF1j8ax39nIdLbs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PvO2WfMUEcUAa9EaOyAGuT1HYIumPnfoOInUXfk9005ZnZ+r8DPvM28DUBCCYbLC7
         Zy2a35RPPlHh5PwvbhNyajQP9g1CsRpIn/5cGFWOcymKS7KGqo5OLpzDlXW5AQ+ymd
         JE/fM4wiayWyTjkS1eCSSiCTAnZRHumNL2vg329w=
Date:   Fri, 21 Jan 2022 22:13:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com,
        christian.brauner@ubuntu.com, crope@iki.fi, davem@davemloft.net,
        ebiederm@xmission.com, ebiggers@google.com, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 37/69] fs: move namespace sysctls and declare fs
 base directory
Message-ID: <20220122061327.kfLE-FHsZ%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move namespace sysctls and declare fs base directory

This moves the namespace sysctls to its own file as part of the
kernel/sysctl.c spring cleaning

Since we have now removed all sysctls for "fs", we now have to declare it
on the filesystem code, we do that using the new helper, which reduces
boiler plate code.

We rename init_fs_shared_sysctls() to init_fs_sysctls() to reflect that
now fs/sysctls.c is taking on the burden of being the first to register
the base directory as well.

Lastly, since init code will load in the order in which we link it we have
to move the sysctl code to be linked in early, so that its early init
routine runs prior to other fs code.  This way, other filesystem code can
register their own sysctls using the helpers after this:

  * register_sysctl_init()
  * register_sysctl()

Link: https://lkml.kernel.org/r/20211129211943.640266-3-mcgrof@kernel.org
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
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile           |    3 ++-
 fs/namespace.c        |   24 +++++++++++++++++++++++-
 fs/sysctls.c          |    9 +++++----
 include/linux/mount.h |    3 ---
 kernel/sysctl.c       |   14 --------------
 5 files changed, 30 insertions(+), 23 deletions(-)

--- a/fs/Makefile~fs-move-namespace-sysctls-and-declare-fs-base-directory
+++ a/fs/Makefile
@@ -6,6 +6,8 @@
 # Rewritten to use lists instead of if-statements.
 # 
 
+obj-$(CONFIG_SYSCTL)		+= sysctls.o
+
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o dcache.o inode.o \
@@ -28,7 +30,6 @@ obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-y				+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
-obj-$(CONFIG_SYSCTL)		+= sysctls.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
--- a/fs/namespace.c~fs-move-namespace-sysctls-and-declare-fs-base-directory
+++ a/fs/namespace.c
@@ -37,7 +37,7 @@
 #include "internal.h"
 
 /* Maximum number of mounts in a mount namespace */
-unsigned int sysctl_mount_max __read_mostly = 100000;
+static unsigned int sysctl_mount_max __read_mostly = 100000;
 
 static unsigned int m_hash_mask __read_mostly;
 static unsigned int m_hash_shift __read_mostly;
@@ -4620,3 +4620,25 @@ const struct proc_ns_operations mntns_op
 	.install	= mntns_install,
 	.owner		= mntns_owner,
 };
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table fs_namespace_sysctls[] = {
+	{
+		.procname	= "mount-max",
+		.data		= &sysctl_mount_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+	},
+	{ }
+};
+
+static int __init init_fs_namespace_sysctls(void)
+{
+	register_sysctl_init("fs", fs_namespace_sysctls);
+	return 0;
+}
+fs_initcall(init_fs_namespace_sysctls);
+
+#endif /* CONFIG_SYSCTL */
--- a/fs/sysctls.c~fs-move-namespace-sysctls-and-declare-fs-base-directory
+++ a/fs/sysctls.c
@@ -29,10 +29,11 @@ static struct ctl_table fs_shared_sysctl
 	{ }
 };
 
-static int __init init_fs_shared_sysctls(void)
+DECLARE_SYSCTL_BASE(fs, fs_shared_sysctls);
+
+static int __init init_fs_sysctls(void)
 {
-	register_sysctl_init("fs", fs_shared_sysctls);
-	return 0;
+	return register_sysctl_base(fs);
 }
 
-early_initcall(init_fs_shared_sysctls);
+early_initcall(init_fs_sysctls);
--- a/include/linux/mount.h~fs-move-namespace-sysctls-and-declare-fs-base-directory
+++ a/include/linux/mount.h
@@ -113,9 +113,6 @@ extern void mnt_set_expiry(struct vfsmou
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(const char *name);
-
-extern unsigned int sysctl_mount_max;
-
 extern bool path_is_mountpoint(const struct path *path);
 
 extern void kern_unmount_array(struct vfsmount *mnt[], unsigned int num);
--- a/kernel/sysctl.c~fs-move-namespace-sysctls-and-declare-fs-base-directory
+++ a/kernel/sysctl.c
@@ -2811,18 +2811,6 @@ static struct ctl_table vm_table[] = {
 	{ }
 };
 
-static struct ctl_table fs_table[] = {
-	{
-		.procname	= "mount-max",
-		.data		= &sysctl_mount_max,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-	},
-	{ }
-};
-
 static struct ctl_table debug_table[] = {
 #ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
 	{
@@ -2853,7 +2841,6 @@ static struct ctl_table dev_table[] = {
 
 DECLARE_SYSCTL_BASE(kernel, kern_table);
 DECLARE_SYSCTL_BASE(vm, vm_table);
-DECLARE_SYSCTL_BASE(fs, fs_table);
 DECLARE_SYSCTL_BASE(debug, debug_table);
 DECLARE_SYSCTL_BASE(dev, dev_table);
 
@@ -2861,7 +2848,6 @@ int __init sysctl_init(void)
 {
 	register_sysctl_base(kernel);
 	register_sysctl_base(vm);
-	register_sysctl_base(fs);
 	register_sysctl_base(debug);
 	register_sysctl_base(dev);
 
_
