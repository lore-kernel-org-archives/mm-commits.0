From: akpm@linux-foundation.org
Subject: [merged] fat-fix-mount-option-parsing.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:47 -0800
Message-ID: <20121218200847.9F4ED82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44597 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:48 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so126027qch.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: ix mount option parsing
has been removed from the -mm tree.  Its filename was
     fat-fix-mount-option-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fat: ix mount option parsing

parse_options() is supposed to return value < 0 on error however we
returned 0 (success) in a lot of cases.  This actually was not a problem
in practice because match_token() used by parse_options() is clever and
catches most of the problems for us.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/fat/inode.c~fat-fix-mount-option-parsing fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-mount-option-parsing
+++ a/fs/fat/inode.c
@@ -972,41 +972,41 @@ static int parse_options(struct super_bl
 			break;
 		case Opt_uid:
 			if (match_int(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->fs_uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(opts->fs_uid))
-				return 0;
+				return -EINVAL;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->fs_gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(opts->fs_gid))
-				return 0;
+				return -EINVAL;
 			break;
 		case Opt_umask:
 			if (match_octal(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->fs_fmask = opts->fs_dmask = option;
 			break;
 		case Opt_dmask:
 			if (match_octal(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->fs_dmask = option;
 			break;
 		case Opt_fmask:
 			if (match_octal(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->fs_fmask = option;
 			break;
 		case Opt_allow_utime:
 			if (match_octal(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->allow_utime = option & (S_IWGRP | S_IWOTH);
 			break;
 		case Opt_codepage:
 			if (match_int(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			opts->codepage = option;
 			break;
 		case Opt_flush:
@@ -1014,9 +1014,9 @@ static int parse_options(struct super_bl
 			break;
 		case Opt_time_offset:
 			if (match_int(&args[0], &option))
-				return 0;
+				return -EINVAL;
 			if (option < -12 * 60 || option > 12 * 60)
-				return 0;
+				return -EINVAL;
 			opts->tz_set = 1;
 			opts->time_offset = option;
 			break;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

