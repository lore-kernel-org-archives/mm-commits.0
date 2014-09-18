From: akpm@linux-foundation.org
Subject: + kernel-kallsymsc-use-__seq_open_private.patch added to -mm tree
Date: Thu, 18 Sep 2014 12:23:46 -0700
Message-ID: <541b3142.Hny5s9PjiBlD7cSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbaIRTXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, gidisrael@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyms.c: use __seq_open_private()
has been added to the -mm tree.  Its filename is
     kernel-kallsymsc-use-__seq_open_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kallsymsc-use-__seq_open_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kallsymsc-use-__seq_open_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: kernel/kallsyms.c: use __seq_open_private()

Reduce boilerplate code by using __seq_open_private() instead of seq_open()
in kallsyms_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Cc: Gideon Israel Dsouza <gidisrael@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN kernel/kallsyms.c~kernel-kallsymsc-use-__seq_open_private kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-kallsymsc-use-__seq_open_private
+++ a/kernel/kallsyms.c
@@ -565,19 +565,12 @@ static int kallsyms_open(struct inode *i
 	 * using get_symbol_offset for every symbol.
 	 */
 	struct kallsym_iter *iter;
-	int ret;
-
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	iter = __seq_open_private(file, &kallsyms_op, sizeof(*iter));
 	if (!iter)
 		return -ENOMEM;
 	reset_iter(iter, 0);
 
-	ret = seq_open(file, &kallsyms_op);
-	if (ret == 0)
-		((struct seq_file *)file->private_data)->private = iter;
-	else
-		kfree(iter);
-	return ret;
+	return 0;
 }
 
 #ifdef	CONFIG_KGDB_KDB
_

Patches currently in -mm which might be from rob.jones@codethink.co.uk are

fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch
fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch
fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch
mm-use-seq_open_private-instead-of-seq_open.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
lib-use-seq_open_private-instead-of-seq_open.patch
kernel-kallsymsc-use-__seq_open_private.patch
ipc-use-__seq_open_private-instead-of-seq_open.patch

