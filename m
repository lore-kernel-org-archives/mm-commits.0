From: akpm@linux-foundation.org
Subject: + parisc-ledc-fix-potential-stack-overflow-in-led_proc_write.patch added to -mm tree
Date: Tue, 03 Aug 2010 15:40:02 -0700
Message-ID: <201008032240.o73Me2Hr015284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab0HCWk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 18:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, ilja@netric.org, kyle@mcmartin.ca, stable@kernel.org


The patch titled
     parisc: led.c: fix potential stack overflow in led_proc_write()
has been added to the -mm tree.  Its filename is
     parisc-ledc-fix-potential-stack-overflow-in-led_proc_write.patch

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
Subject: parisc: led.c: fix potential stack overflow in led_proc_write()
From: Helge Deller <deller@gmx.de>

Avoid potential stack overflow by correctly checking count parameter.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: Ilja <ilja@netric.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/led.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/parisc/led.c~parisc-ledc-fix-potential-stack-overflow-in-led_proc_write drivers/parisc/led.c
--- a/drivers/parisc/led.c~parisc-ledc-fix-potential-stack-overflow-in-led_proc_write
+++ a/drivers/parisc/led.c
@@ -176,16 +176,18 @@ static ssize_t led_proc_write(struct fil
 	size_t count, loff_t *pos)
 {
 	void *data = PDE(file->f_path.dentry->d_inode)->data;
-	char *cur, lbuf[count + 1];
+	char *cur, lbuf[32];
 	int d;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	memset(lbuf, 0, count + 1);
+	if (count >= sizeof(lbuf))
+		count = sizeof(lbuf)-1;
 
 	if (copy_from_user(lbuf, buf, count))
 		return -EFAULT;
+	lbuf[count] = 0;
 
 	cur = lbuf;
 
_

Patches currently in -mm which might be from deller@gmx.de are

parisc-fix-wrong-page-aligned-size-calculation-in-ioremapping-code.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
parisc-ledc-fix-potential-stack-overflow-in-led_proc_write.patch
dma-mapping-parisc-set-arch_dma_minalign.patch

