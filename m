Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CE0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhK2XBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbhK2XAo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC15FB81204
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2219CC53FC7;
        Mon, 29 Nov 2021 22:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226643;
        bh=ZmNZT3IifPc982qXlM4TjzeamQLuYVNc0GaUNw6VAlM=;
        h=Date:From:To:Subject:From;
        b=ozVqpikZgcWrOUr1JzCiVv8fp87wk6Z8Np++1AZeIjdwgpqvaXnf811XqfYq9lFlS
         xKdWaTihXQBquWfqgB5X8xXWEQx7YmUU/LIeLcKf7j63ZSY92RHUFwAkdetJIwLFRq
         ByuR4jCwPs31d9BgMrWLMGQ2Oo+UDCxSiDv1WGi4=
Date:   Mon, 29 Nov 2021 14:57:22 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
 added to -mm tree
Message-ID: <20211129225722.lOoDZaJ-M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: move maxolduid as a sysctl specific const
has been added to the -mm tree.  Its filename is
     sysctl-move-maxolduid-as-a-sysctl-specific-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-move-maxolduid-as-a-sysctl-specific-const.patch

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
Subject: sysctl: move maxolduid as a sysctl specific const

The maxolduid value is only shared for sysctl purposes for use on a max
range.  Just stuff this into our shared const array.

Link: https://lkml.kernel.org/r/20211129205548.605569-5-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    2 +-
 include/linux/sysctl.h |    3 +++
 kernel/sysctl.c        |   12 ++++--------
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/fs/proc/proc_sysctl.c~sysctl-move-maxolduid-as-a-sysctl-specific-const
+++ a/fs/proc/proc_sysctl.c
@@ -26,7 +26,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_sys_dir_operations;
 
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
+const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 65535, INT_MAX };
 EXPORT_SYMBOL(sysctl_vals);
 
 const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
--- a/include/linux/sysctl.h~sysctl-move-maxolduid-as-a-sysctl-specific-const
+++ a/include/linux/sysctl.h
@@ -49,6 +49,9 @@ struct ctl_dir;
 #define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
 #define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
 
+/* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
+#define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])
+
 extern const int sysctl_vals[];
 
 #define SYSCTL_LONG_ZERO	((void *)&sysctl_long_vals[0])
--- a/kernel/sysctl.c~sysctl-move-maxolduid-as-a-sysctl-specific-const
+++ a/kernel/sysctl.c
@@ -109,10 +109,6 @@ static const int six_hundred_forty_kb =
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
-/* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
-static const int maxolduid = 65535;
-/* minolduid is SYSCTL_ZERO */
-
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
@@ -2126,7 +2122,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&maxolduid,
+		.extra2		= SYSCTL_MAXOLDUID,
 	},
 	{
 		.procname	= "overflowgid",
@@ -2135,7 +2131,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&maxolduid,
+		.extra2		= SYSCTL_MAXOLDUID,
 	},
 #ifdef CONFIG_S390
 	{
@@ -2907,7 +2903,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&maxolduid,
+		.extra2		= SYSCTL_MAXOLDUID,
 	},
 	{
 		.procname	= "overflowgid",
@@ -2916,7 +2912,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= (void *)&maxolduid,
+		.extra2		= SYSCTL_MAXOLDUID,
 	},
 #ifdef CONFIG_FILE_LOCKING
 	{
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

