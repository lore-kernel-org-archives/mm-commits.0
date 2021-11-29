Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34ADC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbhK2XC5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:02:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbhK2XBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:01:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7EDBB81204
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DD4C8D102;
        Mon, 29 Nov 2021 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226670;
        bh=NwAQc7CbIzH/WQ4YANtdpE9nCgEOSPpXJLnm92iRDnE=;
        h=Date:From:To:Subject:From;
        b=vrV/I9GkIysB/nkh0W9pBpW2oOWWKALKTnciV8+MZeINZtQW/K03omX6R2NoTcz2J
         /YsMO/RW6eILfQeoiARusMbsqoWjmdvS5x5qsvYz+uQsS7BMncL8UxsvsZo1afPuTm
         hQkMq9EkKAKH6y1ezsNUGBN212iCrURkBzBzjj9M=
Date:   Mon, 29 Nov 2021 14:57:49 -0800
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, christian.brauner@ubuntu.com,
        crope@iki.fi, davem@davemloft.net, ebiederm@xmission.com,
        ebiggers@google.com, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mchehab@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, naveen.n.rao@linux.ibm.com,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  +
 kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch added to -mm
 tree
Message-ID: <20211129225749.v5m1EF4oA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: rename sysctl_init() to sysctl_init_bases()
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -227,7 +227,7 @@ struct ctl_table_header *register_sysctl
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 
-extern int sysctl_init(void);
+extern int sysctl_init_bases(void);
 extern void __register_sysctl_init(const char *path, struct ctl_table *table,
 				 const char *table_name);
 #define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
--- a/kernel/sysctl.c~kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases
+++ a/kernel/sysctl.c
@@ -2843,7 +2843,7 @@ DECLARE_SYSCTL_BASE(vm, vm_table);
 DECLARE_SYSCTL_BASE(debug, debug_table);
 DECLARE_SYSCTL_BASE(dev, dev_table);
 
-int __init sysctl_init(void)
+int __init sysctl_init_bases(void)
 {
 	register_sysctl_base(kernel);
 	register_sysctl_base(vm);
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
fs-move-inode-sysctls-to-its-own-file.patch
fs-move-fs-stat-sysctls-to-file_tablec.patch
fs-move-dcache-sysctls-to-its-own-file.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
fs-move-shared-sysctls-to-fs-sysctlsc.patch
fs-move-locking-sysctls-where-they-are-used.patch
fs-move-namei-sysctls-to-its-own-file.patch
fs-move-fs-execc-sysctls-into-its-own-file.patch
fs-move-pipe-sysctls-to-is-own-file.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

