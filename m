From: akpm@linux-foundation.org
Subject: + fat-fix-mount-option-parsing.patch added to -mm tree
Date: Tue, 13 Nov 2012 17:12:11 -0800
Message-ID: <20121114011211.9F0A6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57980 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2KNBMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 20:12:12 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so932745qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 17:12:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: ix mount option parsing
has been added to the -mm tree.  Its filename is
     fat-fix-mount-option-parsing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
fat-provide-option-for-setting-timezone-offset.patch
fat-fix-mount-option-parsing.patch

