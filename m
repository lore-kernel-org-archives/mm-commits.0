From: akpm@linux-foundation.org
Subject: + hfsplus-implement-norecovery-mount-option-support.patch added
 to -mm tree
Date: Tue, 04 Feb 2014 14:33:35 -0800
Message-ID: <52f16abf.v7HqUBQ5a2+pmulV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbaBDWdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-norecovery-mount-option-support.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:35 -0800


The patch titled
     Subject: hfsplus: implement "norecovery" mount option support
has been added to the -mm tree.  Its filename is
     hfsplus-implement-norecovery-mount-option-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-norecovery-mount-option-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-norecovery-mount-option-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement "norecovery" mount option support

Implement support of "norecovery" mount option.  Such an option is useful
in the case of necessity to mount a HFS+ journaled volume in READ-ONLY
mode without journal replay.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/hfsplus.txt |   16 ++++++++++++++--
 fs/hfsplus/hfsplus_fs.h               |    3 ++-
 fs/hfsplus/options.c                  |   15 ++++++++++++---
 fs/hfsplus/super.c                    |   10 +++++++---
 4 files changed, 35 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/hfsplus.txt~hfsplus-implement-norecovery-mount-option-support Documentation/filesystems/hfsplus.txt
--- a/Documentation/filesystems/hfsplus.txt~hfsplus-implement-norecovery-mount-option-support
+++ a/Documentation/filesystems/hfsplus.txt
@@ -44,12 +44,24 @@ When mounting an HFSPlus filesystem, the
 	Do not decompose file name characters.
 
   force
-	Used to force write access to volumes that are marked as journalled
-	or locked.  Use at your own risk.
+	Used to force write access to volumes that are marked as locked.
+	Use at your own risk. This option doesn't work for journaled
+	volumes with non-empty journal. First of all, driver tries to
+	replay journal and ignores forcing write access in the case of
+	journal replay failure. It is possible to access HFS+ volume in
+	read-only mode only for such case. The "force" option is ignored
+	for the case of "norecovery" option request too.
 
   nls=cccc
 	Encoding to use when presenting file names.
 
+  norecovery
+	Don't load the journal on mounting. Note that this forces
+	mount of inconsistent filesystem, which can lead to
+	various problems. Please, take into account that "force"
+	mount option is ignored for the case of "norecovery" request.
+	You can mount HFS+ file system only in read-only mode for
+	the case of "norecovery" request.
 
 References
 ==========
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-implement-norecovery-mount-option-support fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-implement-norecovery-mount-option-support
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -221,6 +221,7 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_NORECOVERY	6
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
@@ -507,7 +508,7 @@ long hfsplus_ioctl(struct file *filp, un
 
 /* options.c */
 int hfsplus_parse_options(char *, struct hfsplus_sb_info *);
-int hfsplus_parse_options_remount(char *input, int *force);
+int hfsplus_parse_options_remount(char *, struct hfsplus_sb_info *);
 void hfsplus_fill_defaults(struct hfsplus_sb_info *);
 int hfsplus_show_options(struct seq_file *, struct dentry *);
 
diff -puN fs/hfsplus/options.c~hfsplus-implement-norecovery-mount-option-support fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~hfsplus-implement-norecovery-mount-option-support
+++ a/fs/hfsplus/options.c
@@ -24,7 +24,7 @@ enum {
 	opt_part, opt_session, opt_nls,
 	opt_nodecompose, opt_decompose,
 	opt_barrier, opt_nobarrier,
-	opt_force, opt_err
+	opt_force, opt_norecovery, opt_err
 };
 
 static const match_table_t tokens = {
@@ -41,6 +41,7 @@ static const match_table_t tokens = {
 	{ opt_barrier, "barrier" },
 	{ opt_nobarrier, "nobarrier" },
 	{ opt_force, "force" },
+	{ opt_norecovery, "norecovery" },
 	{ opt_err, NULL }
 };
 
@@ -68,7 +69,7 @@ static inline int match_fourchar(substri
 	return 0;
 }
 
-int hfsplus_parse_options_remount(char *input, int *force)
+int hfsplus_parse_options_remount(char *input, struct hfsplus_sb_info *sbi)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -84,7 +85,10 @@ int hfsplus_parse_options_remount(char *
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case opt_force:
-			*force = 1;
+			set_bit(HFSPLUS_SB_FORCE, &sbi->flags);
+			break;
+		case opt_norecovery:
+			set_bit(HFSPLUS_SB_NORECOVERY, &sbi->flags);
 			break;
 		default:
 			break;
@@ -196,6 +200,9 @@ int hfsplus_parse_options(char *input, s
 		case opt_force:
 			set_bit(HFSPLUS_SB_FORCE, &sbi->flags);
 			break;
+		case opt_norecovery:
+			set_bit(HFSPLUS_SB_NORECOVERY, &sbi->flags);
+			break;
 		default:
 			return 0;
 		}
@@ -235,5 +242,7 @@ int hfsplus_show_options(struct seq_file
 		seq_printf(seq, ",nodecompose");
 	if (test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
 		seq_printf(seq, ",nobarrier");
+	if (test_bit(HFSPLUS_SB_NORECOVERY, &sbi->flags))
+		seq_printf(seq, ",norecovery");
 	return 0;
 }
diff -puN fs/hfsplus/super.c~hfsplus-implement-norecovery-mount-option-support fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-implement-norecovery-mount-option-support
+++ a/fs/hfsplus/super.c
@@ -324,15 +324,19 @@ static int hfsplus_statfs(struct dentry
 
 static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 {
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 	if (!(*flags & MS_RDONLY)) {
-		struct hfsplus_vh *vhdr = HFSPLUS_SB(sb)->s_vhdr;
-		int force = 0;
+		struct hfsplus_vh *vhdr = sbi->s_vhdr;
+		int force;
 
-		if (!hfsplus_parse_options_remount(data, &force))
+		if (!hfsplus_parse_options_remount(data, sbi))
 			return -EINVAL;
 
+		force = test_and_clear_bit(HFSPLUS_SB_FORCE, &sbi->flags);
+
 		if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
 			pr_warn("filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-journal-replay.patch
hfsplus-rework-hfsplus_submit_bio-method.patch
hfsplus-implement-init-destroy-journal-object-functionality.patch
hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
hfsplus-implement-norecovery-mount-option-support.patch
hfsplus-fix-remount-issue.patch
hfsplus-implement-check-consistency-of-journal-log-file.patch
hfsplus-introduce-descriptor-of-block-list-buffer.patch
hfsplus-implement-get-and-verify-block-list-header-functionality.patch
hfsplus-implement-functionality-of-getting-transactions-block-info.patch
hfsplus-implement-functionality-of-journal-log-wrapping.patch
hfsplus-implement-functionality-of-transactions-block-check.patch
hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

