From: akpm@linux-foundation.org
Subject: - fix-pointer-mismatches-in-proc_sysctlc.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:07 -0700
Message-ID: <200710261848.l9QIm7Vi009111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbXJZSsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Fix pointer mismatches in proc_sysctl.c
has been removed from the -mm tree.  Its filename was
     fix-pointer-mismatches-in-proc_sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix pointer mismatches in proc_sysctl.c
From: David Howells <dhowells@redhat.com>

Fix pointer mismatches in proc_sysctl.c.  The proc_handler() method returns
a size_t through an arg pointer, but is given a pointer to a ssize_t to
return into.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~fix-pointer-mismatches-in-proc_sysctlc fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~fix-pointer-mismatches-in-proc_sysctlc
+++ a/fs/proc/proc_sysctl.c
@@ -171,7 +171,8 @@ static ssize_t proc_sys_read(struct file
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	ssize_t error, res;
+	ssize_t error;
+	size_t res;
 
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 	/* Has the sysctl entry disappeared on us? */
@@ -209,7 +210,8 @@ static ssize_t proc_sys_write(struct fil
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	ssize_t error, res;
+	ssize_t error;
+	size_t res;
 
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 	/* Has the sysctl entry disappeared on us? */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
mutex-subsystem-synchro-test-module.patch
