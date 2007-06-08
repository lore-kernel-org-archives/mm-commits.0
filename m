From: akpm@linux-foundation.org
Subject: + nfs-make-nfs-root-work-again.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:51:28 -0700
Message-ID: <200706080551.l585pSSY020423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbXFHFvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     NFS: make NFS root work again
has been added to the -mm tree.  Its filename is
     nfs-make-nfs-root-work-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: make NFS root work again
From: David Howells <dhowells@redhat.com>

Make NFS root work by creating a "/root" directory to satisfy the mount,
otherwise the path lookup for the mount fails with ENOENT.

(akpm: stalled, awaiting a description of when and in what fashion nfsroot
broke)

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~nfs-make-nfs-root-work-again init/do_mounts.c
--- a/init/do_mounts.c~nfs-make-nfs-root-work-again
+++ a/init/do_mounts.c
@@ -281,7 +281,10 @@ static void __init get_fs_names(char *pa
 
 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err;
+
+	sys_mkdir("/root", 0755);
+	err = sys_mount(name, "/root", fs, flags, data);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-report-correct-errno-in-message.patch
ramfs-nommu-missed-posix-uid-gid-inode-attribute-checking.patch
frv-build-fix.patch
nfs-make-nfs-root-work-again.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
document-page_mkwrite-locking.patch
nommu-stub-expand_stack-for-nommu-case.patch
afs-implement-file-locking.patch
afs-drop-explicit-extern.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
