From: akpm@linux-foundation.org
Subject: + fs-binfmt_aoutc-use-printk_ratelimit.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:22:58 -0700
Message-ID: <200803180422.m2I4Mwfr013945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYCREXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, geert@linux-m68k.org


The patch titled
     fs/binfmt_aout.c: use printk_ratelimit()
has been added to the -mm tree.  Its filename is
     fs-binfmt_aoutc-use-printk_ratelimit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_aout.c: use printk_ratelimit()
From: S.Caglar Onur <caglar@pardus.org.tr>

Use printk_ratelimit() instead of jiffies based arithmetic, suggested by Geert
Uytterhoeven

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/binfmt_aout.c~fs-binfmt_aoutc-use-printk_ratelimit fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~fs-binfmt_aoutc-use-printk_ratelimit
+++ a/fs/binfmt_aout.c
@@ -372,21 +372,17 @@ static int load_aout_binary(struct linux
 			 
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
-		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
+		    (N_MAGIC(ex) != NMAGIC) && printk_ratelimit())
 		{
 			printk(KERN_NOTICE "executable not page aligned\n");
-			error_time2 = jiffies;
 		}
 
-		if ((fd_offset & ~PAGE_MASK) != 0 &&
-		    (jiffies-error_time) > 5*HZ)
+		if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
 		{
 			printk(KERN_WARNING 
 			       "fd_offset is not page aligned. Please convert program: %s\n",
 			       bprm->file->f_path.dentry->d_name.name);
-			error_time = jiffies;
 		}
 
 		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
@@ -495,15 +491,13 @@ static int load_aout_library(struct file
 	start_addr =  ex.a_entry & 0xfffff000;
 
 	if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
-		static unsigned long error_time;
 		loff_t pos = N_TXTOFF(ex);
 
-		if ((jiffies-error_time) > 5*HZ)
+		if (printk_ratelimit())
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
 			       file->f_path.dentry->d_name.name);
-			error_time = jiffies;
 		}
 		down_write(&current->mm->mmap_sem);
 		do_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

