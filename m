From: akpm@linux-foundation.org
Subject: + fs-befs-linuxvfsc-remove-unnecessary-casting.patch added to -mm tree
Date: Fri, 02 Jan 2015 15:47:48 -0800
Message-ID: <54a72e24.QobZ/FJ1+rAI1Ox3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: remove unnecessary casting
has been added to the -mm tree.  Its filename is
     fs-befs-linuxvfsc-remove-unnecessary-casting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-linuxvfsc-remove-unnecessary-casting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-linuxvfsc-remove-unnecessary-casting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: remove unnecessary casting

Fix the following coccinelle warning:

fs/befs/linuxvfs.c:278:14-36: WARNING: casting value returned by memory
allocation function to (struct befs_inode_info *) is useless.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-remove-unnecessary-casting
+++ a/fs/befs/linuxvfs.c
@@ -274,9 +274,8 @@ more:
 static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
-        struct befs_inode_info *bi;
-        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
-							GFP_KERNEL);
+	struct befs_inode_info *bi = kmem_cache_alloc(befs_inode_cachep,
+						      GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-ufs-superc-remove-unnecessary-casting.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
linux-next.patch

