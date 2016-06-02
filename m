From: akpm@linux-foundation.org
Subject: + nilfs2-refactor-parser-of-snapshot-mount-option.patch added to
 -mm tree
Date: Thu, 02 Jun 2016 13:20:04 -0700
Message-ID: <575094f4.mYokJ6rgG0F1oM/f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbcFBUUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: refactor parser of snapshot mount option
has been added to the -mm tree.  Its filename is
     nilfs2-refactor-parser-of-snapshot-mount-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-refactor-parser-of-snapshot-mount-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-refactor-parser-of-snapshot-mount-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: refactor parser of snapshot mount option

Move parser of snapshot mount option to a separate function
nilfs_parse_snapshot_option(), replace simple_strtoull() with kstrtoull()
to avoid checkpatch.pl warning "WARNING: simple_strtoull is obsolete, use
kstrtoull instead", and refine the error message of the parser.

Link: http://lkml.kernel.org/r/1464875891-5443-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |   53 +++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-refactor-parser-of-snapshot-mount-option fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-refactor-parser-of-snapshot-mount-option
+++ a/fs/nilfs2/super.c
@@ -1205,6 +1205,38 @@ struct nilfs_super_data {
 	int flags;
 };
 
+static int nilfs_parse_snapshot_option(const char *option,
+				       const substring_t *arg,
+				       struct nilfs_super_data *sd)
+{
+	unsigned long long val;
+	const char *msg = NULL;
+	int err;
+
+	if (!(sd->flags & MS_RDONLY)) {
+		msg = "read-only option is not specified";
+		goto parse_error;
+	}
+
+	err = kstrtoull(arg->from, 0, &val);
+	if (err) {
+		if (err == -ERANGE)
+			msg = "too large checkpoint number";
+		else
+			msg = "malformed argument";
+		goto parse_error;
+	} else if (val == 0) {
+		msg = "invalid checkpoint number 0";
+		goto parse_error;
+	}
+	sd->cno = val;
+	return 0;
+
+parse_error:
+	nilfs_msg(NULL, KERN_ERR, "invalid option \"%s\": %s", option, msg);
+	return 1;
+}
+
 /**
  * nilfs_identify - pre-read mount options needed to identify mount instance
  * @data: mount options
@@ -1221,24 +1253,9 @@ static int nilfs_identify(char *data, st
 		p = strsep(&options, ",");
 		if (p != NULL && *p) {
 			token = match_token(p, tokens, args);
-			if (token == Opt_snapshot) {
-				if (!(sd->flags & MS_RDONLY)) {
-					ret++;
-				} else {
-					sd->cno = simple_strtoull(args[0].from,
-								  NULL, 0);
-					/*
-					 * No need to see the end pointer;
-					 * match_token() has done syntax
-					 * checking.
-					 */
-					if (sd->cno == 0)
-						ret++;
-				}
-			}
-			if (ret)
-				nilfs_msg(NULL, KERN_ERR,
-					  "invalid mount option: %s", p);
+			if (token == Opt_snapshot)
+				ret = nilfs_parse_snapshot_option(p, &args[0],
+								  sd);
 		}
 		if (!options)
 			break;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch

