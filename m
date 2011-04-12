From: akpm@linux-foundation.org
Subject: + dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines.patch added to -mm tree
Date: Tue, 12 Apr 2011 16:09:25 -0700
Message-ID: <201104122309.p3CN9Pdh008382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324Ab1DLXJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 19:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, gregkh@suse.de, lennart@poettering.net


The patch titled
     /dev/kmsg: properly support writev() to avoid interleaved printk() lines
has been added to the -mm tree.  Its filename is
     dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines.patch

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
Subject: /dev/kmsg: properly support writev() to avoid interleaved printk() lines
From: Kay Sievers <kay.sievers@vrfy.org>

We should avoid calling printk() in a loop when we pass a single string to
/dev/kmsg with writev().

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff -puN drivers/char/mem.c~dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines drivers/char/mem.c
--- a/drivers/char/mem.c~dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines
+++ a/drivers/char/mem.c
@@ -806,29 +806,40 @@ static const struct file_operations oldm
 };
 #endif
 
-static ssize_t kmsg_write(struct file *file, const char __user *buf,
-			  size_t count, loff_t *ppos)
+static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
+			   unsigned long count, loff_t pos)
 {
-	char *tmp;
-	ssize_t ret;
-
-	tmp = kmalloc(count + 1, GFP_KERNEL);
-	if (tmp == NULL)
+	char *line, *p;
+	int len, i;
+	ssize_t ret = -EFAULT;
+
+	len = iov_length(iv, count);
+	line = p = kmalloc(len + 1, GFP_KERNEL);
+	if (line == NULL)
 		return -ENOMEM;
-	ret = -EFAULT;
-	if (!copy_from_user(tmp, buf, count)) {
-		tmp[count] = 0;
-		ret = printk("%s", tmp);
-		if (ret > count)
-			/* printk can add a prefix */
-			ret = count;
+
+	/*
+	 * copy all vectors into a single string, to ensure we do
+	 * not interleave our log line with other printk calls
+	 */
+	for (i = 0; i < count; i++) {
+		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
+			goto out;
+		p += iv[i].iov_len;
 	}
-	kfree(tmp);
+	p[0] = '\0';
+
+	ret = printk("%s", line);
+	/* printk can add a prefix */
+	if (ret > len)
+		ret = len;
+out:
+	kfree(line);
 	return ret;
 }
 
 static const struct file_operations kmsg_fops = {
-	.write = kmsg_write,
+	.aio_write = kmsg_writev,
 	.llseek = noop_llseek,
 };
 
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines.patch

