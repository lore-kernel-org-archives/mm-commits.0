From: akpm@linux-foundation.org
Subject: + revert-fs-seq_file-fallback-to-vmalloc-allocation.patch added
 to -mm tree
Date: Wed, 09 Jul 2014 13:37:14 -0700
Message-ID: <53bda7fa.y1ROmxWWrSJ0rD4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:33333 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGIUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jul 2014 16:37:15 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1759408pab.5
        for <mm-commits@vger.kernel.org>; Wed, 09 Jul 2014 13:37:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, rientjes@google.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "fs/seq_file: fallback to vmalloc allocation"
has been added to the -mm tree.  Its filename is
     revert-fs-seq_file-fallback-to-vmalloc-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-fs-seq_file-fallback-to-vmalloc-allocation.patch

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
Subject: revert "fs/seq_file: fallback to vmalloc allocation"

Revert

: commit 058504edd02667eef8fac9be27ab3ea74332e9b4
: Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
: AuthorDate: Wed Jul 2 15:22:37 2014 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Jul 3 09:21:54 2014 -0700
: 
:     fs/seq_file: fallback to vmalloc allocation

because it causes mysterious use-after-free bugs in Sasha's testing.

I don't believe 058504edd02667 is actually buggy - more likely it is
somehow exposing a bug which lies elsewhere.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN fs/seq_file.c~revert-fs-seq_file-fallback-to-vmalloc-allocation fs/seq_file.c
--- a/fs/seq_file.c~revert-fs-seq_file-fallback-to-vmalloc-allocation
+++ a/fs/seq_file.c
@@ -8,10 +8,8 @@
 #include <linux/fs.h>
 #include <linux/export.h>
 #include <linux/seq_file.h>
-#include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
-#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -32,16 +30,6 @@ static void seq_set_overflow(struct seq_
 	m->count = m->size;
 }
 
-static void *seq_buf_alloc(unsigned long size)
-{
-	void *buf;
-
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
-	if (!buf && size > PAGE_SIZE)
-		buf = vmalloc(size);
-	return buf;
-}
-
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -108,7 +96,7 @@ static int traverse(struct seq_file *m,
 		return 0;
 	}
 	if (!m->buf) {
-		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
+		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
 		if (!m->buf)
 			return -ENOMEM;
 	}
@@ -147,9 +135,9 @@ static int traverse(struct seq_file *m,
 
 Eoverflow:
 	m->op->stop(m, p);
-	kvfree(m->buf);
+	kfree(m->buf);
 	m->count = 0;
-	m->buf = seq_buf_alloc(m->size <<= 1);
+	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
 
@@ -204,7 +192,7 @@ ssize_t seq_read(struct file *file, char
 
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
-		m->buf = seq_buf_alloc(m->size = PAGE_SIZE);
+		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
 		if (!m->buf)
 			goto Enomem;
 	}
@@ -244,9 +232,9 @@ ssize_t seq_read(struct file *file, char
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kvfree(m->buf);
+		kfree(m->buf);
 		m->count = 0;
-		m->buf = seq_buf_alloc(m->size <<= 1);
+		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 		if (!m->buf)
 			goto Enomem;
 		m->version = 0;
@@ -362,7 +350,7 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	kvfree(m->buf);
+	kfree(m->buf);
 	kfree(m);
 	return 0;
 }
@@ -617,13 +605,13 @@ EXPORT_SYMBOL(single_open);
 int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
 		void *data, size_t size)
 {
-	char *buf = seq_buf_alloc(size);
+	char *buf = kmalloc(size, GFP_KERNEL);
 	int ret;
 	if (!buf)
 		return -ENOMEM;
 	ret = single_open(file, show, data);
 	if (ret) {
-		kvfree(buf);
+		kfree(buf);
 		return ret;
 	}
 	((struct seq_file *)file->private_data)->buf = buf;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

