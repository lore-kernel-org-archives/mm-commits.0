From: akpm@linux-foundation.org
Subject: + ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully.patch added to -mm tree
Date: Wed, 17 Sep 2008 11:43:03 -0700
Message-ID: <200809171843.m8HIh52q024858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbYIQSoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 14:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adilger@sun.com, ralf.hildebrandt@charite.de, tytso@mit.edu


The patch titled
     ext4: create /proc/ext4/*/stats et al more carefully
has been added to the -mm tree.  Its filename is
     ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: create /proc/ext4/*/stats et al more carefully
From: Alexey Dobriyan <adobriyan@gmail.com>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11321

ext4 creates per-suberblock directory in /proc/ext4/ .  Name used as basis
is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Tested-by: Ralf Hildebrandt <ralf.hildebrandt@charite.de>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ext4/mballoc.c~ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully
+++ a/fs/ext4/mballoc.c
@@ -2792,6 +2792,15 @@ static int ext4_mb_init_per_dev_proc(str
 		return -EINVAL;
 	}
 	bdevname(sb->s_bdev, devname);
+	{
+		char *p = devname;
+
+		while (*p != '\0') {
+			if (*p == '/')
+				*p = '!';
+			p++;
+		}
+	}
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-more-debugging-for-already-registered-case.patch
linux-next.patch
itimers-fix-itimer-many-thread-hang.patch
itimers-fix-itimer-many-thread-hang-checkpatch-fixes.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
ext4-fix-11321-create-proc-ext4-stats-et-al-more-carefully.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

