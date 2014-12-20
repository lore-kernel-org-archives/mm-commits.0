From: akpm@linux-foundation.org
Subject: + drivers-char-mem-simplify-devport-configuration.patch added to
 -mm tree
Date: Fri, 19 Dec 2014 16:24:43 -0800
Message-ID: <5494c1cb.HJ3l4dmMheJLG7G3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaLTAYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:24:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.ward114@googlemail.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/mem.c: simplify DEVPORT configuration
has been added to the -mm tree.  Its filename is
     drivers-char-mem-simplify-devport-configuration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-mem-simplify-devport-configuration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-mem-simplify-devport-configuration.patch

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
Subject: drivers/char/mem.c: simplify DEVPORT configuration

Simplify the use of CONFIG_DEVPORT by making the port_fops
so that it includes __maybe_unused.

This enabled the multiple #ifdef's used for this structure
to be removed and brings it in line with the use of CONFIG_DEVMEM

This change should introduce no functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-mem-simplify-devport-configuration drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-mem-simplify-devport-configuration
+++ a/drivers/char/mem.c
@@ -542,7 +542,6 @@ static ssize_t write_kmem(struct file *f
 	return virtr + wrote ? : err;
 }
 
-#ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -583,7 +582,6 @@ static ssize_t write_port(struct file *f
 	*ppos = i;
 	return tmp-buf;
 }
-#endif
 
 static ssize_t read_null(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
@@ -738,14 +736,12 @@ static const struct file_operations null
 	.splice_write	= splice_write_null,
 };
 
-#ifdef CONFIG_DEVPORT
-static const struct file_operations port_fops = {
+static const struct file_operations __maybe_unused port_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_port,
 	.write		= write_port,
 	.open		= open_port,
 };
-#endif
 
 static const struct file_operations zero_fops = {
 	.llseek		= zero_lseek,
_

Patches currently in -mm which might be from robert.ward114@googlemail.com are

origin.patch
drivers-char-mem-make-dev-mem-an-optional-device.patch
drivers-char-mem-simplify-devkmem-configuration.patch
drivers-char-mem-simplify-devport-configuration.patch

