From: akpm@linux-foundation.org
Subject: [merged]
 printk-prevent-userland-from-spoofing-kernel-messages.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:46:02 -0800
Message-ID: <5640f7fa.qIiDd8pK4qX4mmDN%akpm__46929.5055176646$1447098393$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbKITqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:46:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, elder@linaro.org, gregkh@linuxfoundation.org, joe@perches.com, kay@vrfy.org, pmladek@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: prevent userland from spoofing kernel messages
has been removed from the -mm tree.  Its filename was
     printk-prevent-userland-from-spoofing-kernel-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: printk: prevent userland from spoofing kernel messages

The following statement of ABI/testing/dev-kmsg is not quite right:

   It is not possible to inject messages from userspace with the
   facility number LOG_KERN (0), to make sure that the origin of the
   messages can always be reliably determined.

Userland actually can inject messages with a facility of 0 by abusing the
fact that the facility is stored in a u8 data type.  By using a facility
which is a multiple of 256 the assignment of msg->facility in log_store()
implicitly truncates it to 0, i.e.  LOG_KERN, allowing users of /dev/kmsg
to spoof kernel messages as shown below:

The following call...
   # printf '<%d>Kernel panic - not syncing: beer empty\n' 0 >/dev/kmsg
...leads to the following log entry (dmesg -x | tail -n 1):
   user  :emerg : [   66.137758] Kernel panic - not syncing: beer empty

However, this call...
   # printf '<%d>Kernel panic - not syncing: beer empty\n' 0x800 >/dev/kmsg
...leads to the slightly different log entry (note the kernel facility):
   kern  :emerg : [   74.177343] Kernel panic - not syncing: beer empty

Fix that by limiting the user provided facility to 8 bit right from the
beginning and catch the truncation early.

Fixes: 7ff9554bb578 ("printk: convert byte-buffer to variable-length...")
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Alex Elder <elder@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN kernel/printk/printk.c~printk-prevent-userland-from-spoofing-kernel-messages kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-prevent-userland-from-spoofing-kernel-messages
+++ a/kernel/printk/printk.c
@@ -269,6 +269,9 @@ static u32 clear_idx;
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		(1024 - PREFIX_MAX)
 
+#define LOG_LEVEL(v)		((v) & 0x07)
+#define LOG_FACILITY(v)		((v) >> 3 & 0xff)
+
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
@@ -612,7 +615,6 @@ struct devkmsg_user {
 static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	char *buf, *line;
-	int i;
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
 	size_t len = iov_iter_count(from);
@@ -642,12 +644,13 @@ static ssize_t devkmsg_write(struct kioc
 	line = buf;
 	if (line[0] == '<') {
 		char *endp = NULL;
+		unsigned int u;
 
-		i = simple_strtoul(line+1, &endp, 10);
+		u = simple_strtoul(line + 1, &endp, 10);
 		if (endp && endp[0] == '>') {
-			level = i & 7;
-			if (i >> 3)
-				facility = i >> 3;
+			level = LOG_LEVEL(u);
+			if (LOG_FACILITY(u) != 0)
+				facility = LOG_FACILITY(u);
 			endp++;
 			len -= endp - line;
 			line = endp;
_

Patches currently in -mm which might be from minipli@googlemail.com are


