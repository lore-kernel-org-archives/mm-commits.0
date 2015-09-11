From: akpm@linux-foundation.org
Subject: [merged] cred-remove-unnecessary-kdebug-atomic-reads.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:44 -0700
Message-ID: <55f31960.XAppHM1dNqfNUo5+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbIKSLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cred.c: remove unnecessary kdebug atomic reads
has been removed from the -mm tree.  Its filename was
     cred-remove-unnecessary-kdebug-atomic-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

