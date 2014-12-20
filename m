From: akpm@linux-foundation.org
Subject: + drivers-char-mem-simplify-devkmem-configuration.patch added to
 -mm tree
Date: Fri, 19 Dec 2014 16:24:41 -0800
Message-ID: <5494c1c9.paBKR/Q09EwnTRtG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLTAYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:24:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.ward114@googlemail.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/mem.c: simplify DEVKMEM configuration
has been added to the -mm tree.  Its filename is
     drivers-char-mem-simplify-devkmem-configuration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-mem-simplify-devkmem-configuration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-mem-simplify-devkmem-configuration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Ward <robert.ward114@googlemail.com>
Subject: drivers/char/mem.c: simplify DEVKMEM configuration

Simplify the use of CONFIG_DEVKMEM by making the kmem_fops
so that it is __maybe_unused.

This enabled the multiple #ifdef's used for this structure
to be removed and brings it in line with the use of CONFIG_DEVMEM

This change should introduce no functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-mem-simplify-devkmem-configuration drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-mem-simplify-devkmem-configuration
+++ a/drivers/char/mem.c
@@ -341,7 +341,6 @@ static int mmap_mem(struct file *file, s
 	return 0;
 }
 
-#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long pfn;
@@ -362,9 +361,7 @@ static int mmap_kmem(struct file *file,
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
-#endif
 
-#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -544,7 +541,6 @@ static ssize_t write_kmem(struct file *f
 	*ppos = p;
 	return virtr + wrote ? : err;
 }
-#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file *file, char __user *buf,
@@ -724,8 +720,7 @@ static const struct file_operations __ma
 	.get_unmapped_area = get_unmapped_area_mem,
 };
 
-#ifdef CONFIG_DEVKMEM
-static const struct file_operations kmem_fops = {
+static const struct file_operations __maybe_unused kmem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_kmem,
 	.write		= write_kmem,
@@ -733,7 +728,6 @@ static const struct file_operations kmem
 	.open		= open_kmem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
-#endif
 
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
_

Patches currently in -mm which might be from robert.ward114@googlemail.com are

origin.patch
drivers-char-mem-make-dev-mem-an-optional-device.patch
drivers-char-mem-simplify-devkmem-configuration.patch
drivers-char-mem-simplify-devport-configuration.patch

