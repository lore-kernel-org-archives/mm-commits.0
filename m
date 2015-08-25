From: akpm@linux-foundation.org
Subject: + cred-remove-unnecessary-kdebug-atomic-reads.patch added to -mm
 tree
Date: Tue, 25 Aug 2015 13:39:34 -0700
Message-ID: <55dcd286.9QEdsxBLVuzkTBeE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbbHYUjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cred.c: remove unnecessary kdebug atomic reads
has been added to the -mm tree.  Its filename is
     cred-remove-unnecessary-kdebug-atomic-reads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cred-remove-unnecessary-kdebug-atomic-reads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cred-remove-unnecessary-kdebug-atomic-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel/cred.c: remove unnecessary kdebug atomic reads

Commit e0e817392b9a ("CRED: Add some configurable debugging [try #6]")
added the kdebug mechanism to this file back in 2009.

The kdebug macro calls no_printk which always evaluates arguments.

Most of the kdebug uses have an unnecessary call of
	atomic_read(&cred->usage)

Make the kdebug macro do nothing by defining it with
	do { if (0) no_printk(...); } while (0)
when not enabled.

$ size kernel/cred.o* (defconfig x86-64)
   text	   data	    bss	    dec	    hex	filename
   2748	    336	      8	   3092	    c14	kernel/cred.o.new
   2788	    336	      8	   3132	    c3c	kernel/cred.o.old

Miscellanea:
o Neaten the #define kdebug macros while there

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN kernel/cred.c~cred-remove-unnecessary-kdebug-atomic-reads kernel/cred.c
--- a/kernel/cred.c~cred-remove-unnecessary-kdebug-atomic-reads
+++ a/kernel/cred.c
@@ -20,11 +20,16 @@
 #include <linux/cn_proc.h>
 
 #if 0
-#define kdebug(FMT, ...) \
-	printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
+#define kdebug(FMT, ...)						\
+	printk("[%-5.5s%5u] " FMT "\n",					\
+	       current->comm, current->pid, ##__VA_ARGS__)
 #else
-#define kdebug(FMT, ...) \
-	no_printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
+#define kdebug(FMT, ...)						\
+do {									\
+	if (0)								\
+		no_printk("[%-5.5s%5u] " FMT "\n",			\
+			  current->comm, current->pid, ##__VA_ARGS__);	\
+} while (0)
 #endif
 
 static struct kmem_cache *cred_jar;
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
cred-remove-unnecessary-kdebug-atomic-reads.patch
maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch
checkpatch-emit-an-error-on-formats-with-0x%decimal.patch
checkpatch-avoid-some-commit-message-long-line-warnings.patch
checkpatch-add-__pmem-to-sparse-annotations.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

