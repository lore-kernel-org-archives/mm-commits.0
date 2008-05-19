From: akpm@linux-foundation.org
Subject: + ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch added to -mm tree
Date: Mon, 19 May 2008 14:55:10 -0700
Message-ID: <200805192155.m4JLtAVG022477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763650AbYESVzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com


The patch titled
     ext4: error proc entry creation when the fs/ext4 is not correctly created
has been added to the -mm tree.  Its filename is
     ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: error proc entry creation when the fs/ext4 is not correctly created
From: Shen Feng <shen@cn.fujitsu.com>

When the directory fs/ext4 is not correctly created under proc, the entry
under this directory should not be created.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created
+++ a/fs/ext4/mballoc.c
@@ -2645,6 +2645,10 @@ static int ext4_mb_init_per_dev_proc(str
 	struct proc_dir_entry *proc;
 	char devname[64];
 
+	if (proc_root_ext4 == NULL) {
+		sbi->s_mb_proc = NULL;
+		return -EINVAL;
+	}
 	bdevname(sb->s_bdev, devname);
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

ext4-error-proc-entry-creation-when-the-fs-ext4-is-not-correctly-created.patch

