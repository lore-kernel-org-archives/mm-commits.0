From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
 added to -mm tree
Date: Wed, 07 Jan 2015 13:31:46 -0800
Message-ID: <54ada5c2.6q6CmfuHUehvnhDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbbAGVbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 16:31:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, wangww631@huawei.comm, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add a mount option journal_async_commit on ocfs2 filesystem
has been added to the -mm tree.  Its filename is
     ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: add a mount option journal_async_commit on ocfs2 filesystem

Add a mount option to support JBD2 feature:

JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT.  When this feature is opened, journal
commit block can be written to disk without waiting for descriptor blocks,
which can improve journal commit performance.  This option will enable
'journal_checksum' internally.

Using the fs_mark benchmark, using journal_async_commit shows a 50%
improvement, the files per second go up from 215.2 to 317.5.

test script:
fs_mark  -d  /mnt/ocfs2/  -s  10240  -n  1000

default:
FSUse%        Count         Size    Files/sec     App Overhead
     0         1000        10240        215.2            17878

with journal_async_commit option:
FSUse%        Count         Size    Files/sec     App Overhead
     0         1000        10240        317.5            17881

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Signed-off-by: Weiwei Wang <wangww631@huawei.comm>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ocfs2.txt |    4 ++++
 fs/ocfs2/ocfs2.h                    |    2 ++
 fs/ocfs2/super.c                    |   17 +++++++++++++++++
 3 files changed, 23 insertions(+)

diff -puN Documentation/filesystems/ocfs2.txt~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem Documentation/filesystems/ocfs2.txt
--- a/Documentation/filesystems/ocfs2.txt~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem
+++ a/Documentation/filesystems/ocfs2.txt
@@ -100,3 +100,7 @@ coherency=full  (*)	Disallow concurrent
 coherency=buffered	Allow concurrent O_DIRECT writes without EX lock among
 			nodes, which gains high performance at risk of getting
 			stale data on other nodes.
+journal_async_commit	Commit block can be written to disk without waiting
+			for descriptor blocks. If enabled older kernels cannot
+			mount the device. This will enable 'journal_checksum'
+			internally.
diff -puN fs/ocfs2/ocfs2.h~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem
+++ a/fs/ocfs2/ocfs2.h
@@ -279,6 +279,8 @@ enum ocfs2_mount_options
 						     writes */
 	OCFS2_MOUNT_HB_NONE = 1 << 13, /* No heartbeat */
 	OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
+
+	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff -puN fs/ocfs2/super.c~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem
+++ a/fs/ocfs2/super.c
@@ -191,6 +191,7 @@ enum {
 	Opt_coherency_full,
 	Opt_resv_level,
 	Opt_dir_resv_level,
+	Opt_journal_async_commit,
 	Opt_err,
 };
 
@@ -222,6 +223,7 @@ static const match_table_t tokens = {
 	{Opt_coherency_full, "coherency=full"},
 	{Opt_resv_level, "resv_level=%u"},
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
+	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err, NULL}
 };
 
@@ -1500,6 +1502,9 @@ static int ocfs2_parse_options(struct su
 			    option < OCFS2_MAX_RESV_LEVEL)
 				mopt->dir_resv_level = option;
 			break;
+		case Opt_journal_async_commit:
+			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1606,6 +1611,9 @@ static int ocfs2_show_options(struct seq
 	if (osb->osb_dir_resv_level != osb->osb_resv_level)
 		seq_printf(s, ",dir_resv_level=%d", osb->osb_resv_level);
 
+	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
+		seq_printf(s, ",journal_async_commit");
+
 	return 0;
 }
 
@@ -2475,6 +2483,15 @@ static int ocfs2_check_volume(struct ocf
 		goto finally;
 	}
 
+	if (osb->s_mount_opt & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
+		jbd2_journal_set_features(osb->journal->j_journal,
+				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+	else
+		jbd2_journal_clear_features(osb->journal->j_journal,
+				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
+
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
 		status = ocfs2_begin_local_alloc_recovery(osb,
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
ocfs2-add-a-mount-option-journal_async_commit-on-ocfs2-filesystem.patch
ocfs2-implement-ocfs2_direct_io_write.patch

