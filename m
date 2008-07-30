From: akpm@linux-foundation.org
Subject: + docsrc-fix-procfs-example.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:31:29 -0700
Message-ID: <200807300031.m6U0VTIp030209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbYG3Aby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, J.A.K.Mouw@its.tudelft.nl, alan@lxorguk.ukuu.org.uk, sam@ravnborg.org


The patch titled
     docsrc: fix procfs example
has been added to the -mm tree.  Its filename is
     docsrc-fix-procfs-example.patch

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
Subject: docsrc: fix procfs example
From: Randy Dunlap <randy.dunlap@oracle.com>

Add MODULE_LICENSE() to DocBook/procfs_example.c since modpost complained
about a missing license there.

Remove tty procfs removal since the creation was deleted long ago
(http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=5ad9cb65e9b15e5b83e2dd1c10a4bcaccc4ec644).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <J.A.K.Mouw@its.tudelft.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/procfs_example.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN Documentation/DocBook/procfs_example.c~docsrc-fix-procfs-example Documentation/DocBook/procfs_example.c
--- a/Documentation/DocBook/procfs_example.c~docsrc-fix-procfs-example
+++ a/Documentation/DocBook/procfs_example.c
@@ -189,8 +189,6 @@ static int __init init_procfs_example(vo
 	return 0;
 
 no_symlink:
-	remove_proc_entry("tty", example_dir);
-no_tty:
 	remove_proc_entry("bar", example_dir);
 no_bar:
 	remove_proc_entry("foo", example_dir);
@@ -206,7 +204,6 @@ out:
 static void __exit cleanup_procfs_example(void)
 {
 	remove_proc_entry("jiffies_too", example_dir);
-	remove_proc_entry("tty", example_dir);
 	remove_proc_entry("bar", example_dir);
 	remove_proc_entry("foo", example_dir);
 	remove_proc_entry("jiffies", example_dir);
@@ -222,3 +219,4 @@ module_exit(cleanup_procfs_example);
 
 MODULE_AUTHOR("Erik Mouw");
 MODULE_DESCRIPTION("procfs examples");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
documentation-build-source-files-in-documentation-sub-dir.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

