From: akpm@linux-foundation.org
Subject: [merged] dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines.patch removed from -mm tree
Date: Wed, 20 Apr 2011 13:54:43 -0700
Message-ID: <201104202050.p3KKoZX3026110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab1DTUur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 16:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, gregkh@suse.de, lennart@poettering.net, mm-commits@vger.kernel.org


The patch titled
     /dev/kmsg: properly support writev() to avoid interleaved printk() lines
has been removed from the -mm tree.  Its filename was
     dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

