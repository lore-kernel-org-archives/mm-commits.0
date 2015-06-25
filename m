From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch added to -mm tree
Date: Thu, 25 Jun 2015 12:19:45 -0700
Message-ID: <558c5451.qpK0n0JtbmOIT5yM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbFYTTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 15:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nsfs: fix for seq_printf() API change
has been added to the -mm tree.  Its filename is
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: nsfs: fix for seq_printf() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nsfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nsfs.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix fs/nsfs.c
--- a/fs/nsfs.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix
+++ a/fs/nsfs.c
@@ -142,7 +142,8 @@ static int nsfs_show_path(struct seq_fil
 	struct inode *inode = d_inode(dentry);
 	const struct proc_ns_operations *ns_ops = dentry->d_fsdata;
 
-	return seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	return 0;
 }
 
 static const struct super_operations nsfs_ops = {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-activate-syscall-fix.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

