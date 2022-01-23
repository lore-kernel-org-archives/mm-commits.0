Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6727C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiAWX5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45972 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiAWX5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DA2B80DC7
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA77C340E3;
        Sun, 23 Jan 2022 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982226;
        bh=9+Pbzq4o4lzMS4jEu4JFEP9Zgmip8HtJjW5eC+INaDg=;
        h=Date:From:To:Subject:From;
        b=peLL7fyki9TRBfEElmcA6BVb/+eMdZfSdYoxeX76uWQ/wk6DQDBYSSRj9Dz6lk9uW
         uBi8gjlB8SJjDVQ1pNpOLJZPU9QI7obw2NByW+2mg45Umqkj/McmVQmgOhcTMLAcKZ
         oHiBEoKgnmfOT9KtXNqvgSsBQ+xVcEw6Xy/y0oe0=
Date:   Sun, 23 Jan 2022 15:57:05 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mic@digikod.net, mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        steve@sk2.org, viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [merged]
 sysctl-move-maxolduid-as-a-sysctl-specific-const.patch removed from -mm
 tree
Message-ID: <20220123235705.g-S3h5tdN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: move maxolduid as a sysctl specific const
has been removed from the -mm tree.  Its filename was
     sysctl-move-maxolduid-as-a-sysctl-specific-const.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Luis Chamberlain <mcgrof@kernel.org>
Subject: sysctl: move maxolduid as a sysctl specific const

The maxolduid value is only shared for sysctl purposes for use on a max
range.  Just stuff this into our shared const array.

[akpm@linux-foundation.org: fix sysctl_vals[], per Micka=C3=ABl]
Link: https://lkml.kernel.org/r/20211129205548.605569-5-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
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
=20
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MA=
X };
+const int sysctl_vals[] =3D { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MA=
X, 65535 };
 EXPORT_SYMBOL(sysctl_vals);
=20
 const unsigned long sysctl_long_vals[] =3D { 0, 1, LONG_MAX };
--- a/include/linux/sysctl.h~sysctl-move-maxolduid-as-a-sysctl-specific-con=
st
+++ a/include/linux/sysctl.h
@@ -49,6 +49,9 @@ struct ctl_dir;
 #define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
 #define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
=20
+/* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and G=
ID */
+#define SYSCTL_MAXOLDUID		((void *)&sysctl_vals[10])
+
 extern const int sysctl_vals[];
=20
 #define SYSCTL_LONG_ZERO	((void *)&sysctl_long_vals[0])
--- a/kernel/sysctl.c~sysctl-move-maxolduid-as-a-sysctl-specific-const
+++ a/kernel/sysctl.c
@@ -110,10 +110,6 @@ static const int six_hundred_forty_kb =3D
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static const unsigned long dirty_bytes_min =3D 2 * PAGE_SIZE;
=20
-/* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and G=
ID */
-static const int maxolduid =3D 65535;
-/* minolduid is SYSCTL_ZERO */
-
 static const int ngroups_max =3D NGROUPS_MAX;
 static const int cap_last_cap =3D CAP_LAST_CAP;
=20
@@ -2127,7 +2123,7 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec_minmax,
 		.extra1		=3D SYSCTL_ZERO,
-		.extra2		=3D (void *)&maxolduid,
+		.extra2		=3D SYSCTL_MAXOLDUID,
 	},
 	{
 		.procname	=3D "overflowgid",
@@ -2136,7 +2132,7 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec_minmax,
 		.extra1		=3D SYSCTL_ZERO,
-		.extra2		=3D (void *)&maxolduid,
+		.extra2		=3D SYSCTL_MAXOLDUID,
 	},
 #ifdef CONFIG_S390
 	{
@@ -2908,7 +2904,7 @@ static struct ctl_table fs_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec_minmax,
 		.extra1		=3D SYSCTL_ZERO,
-		.extra2		=3D (void *)&maxolduid,
+		.extra2		=3D SYSCTL_MAXOLDUID,
 	},
 	{
 		.procname	=3D "overflowgid",
@@ -2917,7 +2913,7 @@ static struct ctl_table fs_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec_minmax,
 		.extra1		=3D SYSCTL_ZERO,
-		.extra2		=3D (void *)&maxolduid,
+		.extra2		=3D SYSCTL_MAXOLDUID,
 	},
 #ifdef CONFIG_FILE_LOCKING
 	{
_

Patches currently in -mm which might be from mcgrof@kernel.org are


