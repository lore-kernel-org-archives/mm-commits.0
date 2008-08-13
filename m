From: akpm@linux-foundation.org
Subject: - docsrc-fix-procfs-example.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:23 -0700
Message-ID: <200808130853.m7D8rNeX008322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYHMIzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, J.A.K.Mouw@its.tudelft.nl, alan@lxorguk.ukuu.org.uk, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     docsrc: fix procfs example
has been removed from the -mm tree.  Its filename was
     docsrc-fix-procfs-example.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

