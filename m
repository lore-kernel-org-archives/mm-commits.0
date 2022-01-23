Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471CCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiAWX5f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiAWX5d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA0CC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:57:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96A92B80E48
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C407AC340E3;
        Sun, 23 Jan 2022 23:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982250;
        bh=97LGHuFZwQHUHYrdBzSJaa85UNBcpnaf1vHC7f8uJAM=;
        h=Date:From:To:Subject:From;
        b=u3CDER7cvXLBXoOR+oH54qs5JWnGhNuyAfPqzx7RluoZDbBEF4dI9TtnhOJ3/nmB9
         Kv+MCQ1Vaf1dQ2IY8xHWYRmx9th7XpV/Ayqraa8heyPG55P8Ms6ueD3t3d2yFaWZwH
         PdWr5zbbTcjfTK0En/YCntbibj7718bUKAK7r3CU=
Date:   Sun, 23 Jan 2022 15:57:29 -0800
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, christian.brauner@ubuntu.com,
        crope@iki.fi, davem@davemloft.net, ebiederm@xmission.com,
        ebiggers@google.com, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mhiramat@kernel.org, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, nixiaoming@huawei.com, steve@sk2.org,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [merged]
 kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch removed from
 -mm tree
Message-ID: <20220123235729.JtAMFNGVg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: rename sysctl_init() to sysctl_init_bases()
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: kernel/sysctl.c: rename sysctl_init() to sysctl_init_bases()

Rename sysctl_init() to sysctl_init_bases() so to reflect exactly what
this is doing.

Link: https://lkml.kernel.org/r/20211129211943.640266-4-mcgrof@kernel.org
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

 arch/arm/mm/alignment.c |    2 +-
 arch/sh/mm/alignment.c  |    2 +-
 fs/proc/proc_sysctl.c   |    4 ++--
 include/linux/sysctl.h  |    2 +-
 kernel/sysctl.c         |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/mm/alignment.c~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/arch/arm/mm/alignment.c
@@ -1005,7 +1005,7 @@ static int __init noalign_setup(char *__
 __setup("noalign", noalign_setup);
 
 /*
- * This needs to be done after sysctl_init, otherwise sys/ will be
+ * This needs to be done after sysctl_init_bases(), otherwise sys/ will be
  * overwritten.  Actually, this shouldn't be in sys/ at all since
  * it isn't a sysctl, and it doesn't contain sysctl information.
  * We now locate it in /proc/cpu/alignment instead.
--- a/arch/sh/mm/alignment.c~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/arch/sh/mm/alignment.c
@@ -161,7 +161,7 @@ static const struct proc_ops alignment_p
 };
 
 /*
- * This needs to be done after sysctl_init, otherwise sys/ will be
+ * This needs to be done after sysctl_init_bases(), otherwise sys/ will be
  * overwritten.  Actually, this shouldn't be in sys/ at all since
  * it isn't a sysctl, and it doesn't contain sysctl information.
  * We now locate it in /proc/cpu/alignment instead.
--- a/fs/proc/proc_sysctl.c~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/fs/proc/proc_sysctl.c
@@ -1419,7 +1419,7 @@ EXPORT_SYMBOL(register_sysctl);
  * Context: Can only be called after your respective sysctl base path has been
  * registered. So for instance, most base directories are registered early on
  * init before init levels are processed through proc_sys_init() and
- * sysctl_init().
+ * sysctl_init_bases().
  */
 void __init __register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name)
@@ -1768,7 +1768,7 @@ int __init proc_sys_init(void)
 	proc_sys_root->proc_dir_ops = &proc_sys_dir_file_operations;
 	proc_sys_root->nlink = 0;
 
-	return sysctl_init();
+	return sysctl_init_bases();
 }
 
 struct sysctl_alias {
--- a/include/linux/sysctl.h~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/include/linux/sysctl.h
@@ -228,7 +228,7 @@ struct ctl_table_header *register_sysctl
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 
-extern int sysctl_init(void);
+extern int sysctl_init_bases(void);
 extern void __register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name);
 #define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
--- a/kernel/sysctl.c~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/kernel/sysctl.c
@@ -2844,7 +2844,7 @@ DECLARE_SYSCTL_BASE(vm, vm_table);
 DECLARE_SYSCTL_BASE(debug, debug_table);
 DECLARE_SYSCTL_BASE(dev, dev_table);
 
-int __init sysctl_init(void)
+int __init sysctl_init_bases(void)
 {
 	register_sysctl_base(kernel);
 	register_sysctl_base(vm);
_

Patches currently in -mm which might be from mcgrof@kernel.org are


