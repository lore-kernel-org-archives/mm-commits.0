From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch added to -mm tree
Date: Wed, 15 Jul 2015 14:44:33 -0700
Message-ID: <55a6d441.WLPNS3hp5/7KwdKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbGOVoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

