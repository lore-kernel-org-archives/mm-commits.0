From: akpm@linux-foundation.org
Subject: + fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device.patch added to -mm tree
Date: Tue, 27 May 2008 22:22:46 -0700
Message-ID: <200805280522.m4S5MkYJ030704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYE1FXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, jens.axboe@oracle.com, kay.sievers@vrfy.org, sfr@canb.auug.org.au


The patch titled
     block: genhd errors when CONFIG_PROC_FS=n
has been added to the -mm tree.  Its filename is
     fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device.patch

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
Subject: block: genhd errors when CONFIG_PROC_FS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

block/genhd.c has build errors when CONFIG_PROC_FS=n, so omit some of its
functions in that case.

/local/linsrc/linux-next-20080523/block/genhd.c: In function 'diskstats_start':
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: 'find_start' undeclared (first use in this function)
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: (Each undeclared identifier is reported only once
/local/linsrc/linux-next-20080523/block/genhd.c:555: error: for each function it appears in.)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN block/genhd.c~fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device block/genhd.c
--- a/block/genhd.c~fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device
+++ a/block/genhd.c
@@ -544,6 +544,7 @@ static struct device_type disk_type = {
 	.release	= disk_release,
 };
 
+#ifdef CONFIG_PROC_FS
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
@@ -646,6 +647,7 @@ const struct seq_operations diskstats_op
 	.stop	= diskstats_stop,
 	.show	= diskstats_show
 };
+#endif /* CONFIG_PROC_FS */
 
 static void media_change_notify_thread(struct work_struct *work)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fix-gregkh-driver-block-make-proc-files-seq_start-use-the-class_find_device.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
audit-fix-kernel-doc-parameter-notation.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

