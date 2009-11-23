From: akpm@linux-foundation.org
Subject: + mm-includecheck-fix-slqb.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:58:43 -0800
Message-ID: <200911232358.nANNwhbk001841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757221AbZKWX70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:59:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, npiggin@suse.de, penberg@cs.helsinki.fi


The patch titled
     mm: includecheck fix slqb
has been added to the -mm tree.  Its filename is
     mm-includecheck-fix-slqb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: includecheck fix slqb
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warnings:

  include/linux/slqb_def.h: linux/kobject.h is included more than once.
  mm/slqb.c: linux/seq_file.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slqb_def.h |    1 -
 mm/slqb.c                |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/slqb_def.h~mm-includecheck-fix-slqb include/linux/slqb_def.h
--- a/include/linux/slqb_def.h~mm-includecheck-fix-slqb
+++ a/include/linux/slqb_def.h
@@ -13,7 +13,6 @@
 #include <linux/rcu_types.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
 
 #define SLAB_NUMA		0x00000001UL    /* shortcut */
 
diff -puN mm/slqb.c~mm-includecheck-fix-slqb mm/slqb.c
--- a/mm/slqb.c~mm-includecheck-fix-slqb
+++ a/mm/slqb.c
@@ -3302,7 +3302,6 @@ static void gather_stats(struct kmem_cac
  */
 #ifdef CONFIG_SLABINFO
 #include <linux/proc_fs.h>
-#include <linux/seq_file.h>
 ssize_t slabinfo_write(struct file *file, const char __user * buffer,
 		       size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
mm-includecheck-fix-slqb.patch

