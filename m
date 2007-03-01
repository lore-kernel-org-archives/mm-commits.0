From: akpm@linux-foundation.org
Subject: + afs-remove-all-afs-proc-entries-in-module-cleanup.patch added to -mm tree
Date: Wed, 28 Feb 2007 23:50:04 -0800
Message-ID: <200703010750.l217o4Uq007890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXCAHu3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 02:50:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: poornima@in.ibm.com, dhowells@redhat.com


The patch titled
     AFS: remove all AFS /proc entries in module cleanup
has been added to the -mm tree.  Its filename is
     afs-remove-all-afs-proc-entries-in-module-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFS: remove all AFS /proc entries in module cleanup
From: B N Poornima <poornima@in.ibm.com>

This is regarding a bug in the 'kafs' module.  Whenever the kafs module is
unloaded, it produces the following stack trace.

********************************************************************
kAFS: Red Hat AFS client v0.1 unregistering.
BUG: at fs/proc/generic.c:732 remove_proc_entry()
 [<c0195380>] remove_proc_entry+0x11b/0x175
 [<c013b52e>] sys_delete_module+0x1a5/0x1cf
 [<c0158bc2>] remove_vma+0x36/0x3b
 [<c01594ca>] do_munmap+0x193/0x1ac
 [<c0103da0>] syscall_call+0x7/0xb
 [<c02a0033>] nf_ip_checksum+0xd4/0xe1
 =======================
***************************************************************

The problem is reproducible on the latest rc kernel - 2.6.20-rc5.  The
cause of the problem being kafs driver trying to free the /proc/fs/afs
directory which is not empty.

Signed-off-by: B N Poornima <poornima@in.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/afs/proc.c~afs-remove-all-afs-proc-entries-in-module-cleanup fs/afs/proc.c
--- a/fs/afs/proc.c~afs-remove-all-afs-proc-entries-in-module-cleanup
+++ a/fs/afs/proc.c
@@ -178,6 +178,8 @@ void afs_proc_cleanup(void)
 {
 	remove_proc_entry("cells", proc_afs);
 
+	remove_proc_entry("rootcell", proc_afs);
+
 	remove_proc_entry("fs/afs", NULL);
 
 } /* end afs_proc_cleanup() */
_

Patches currently in -mm which might be from poornima@in.ibm.com are

afs-remove-all-afs-proc-entries-in-module-cleanup.patch
