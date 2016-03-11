From: akpm@linux-foundation.org
Subject: + printk-add-clear_idx-symbol-to-vmcoreinfo.patch added to -mm
 tree
Date: Fri, 11 Mar 2016 13:17:01 -0800
Message-ID: <56e335cd.hNFDVBhCWY4vj42L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbcCKVRC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2016 16:17:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colona@arista.com, kay@vrfy.org, nhorman@tuxdriver.com, zzy8200@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add clear_idx symbol to vmcoreinfo
has been added to the -mm tree.  Its filename is
     printk-add-clear_idx-symbol-to-vmcoreinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-clear_idx-symbol-to-vmcoreinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-clear_idx-symbol-to-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ivan Delalande <colona@arista.com>
Subject: printk: add clear_idx symbol to vmcoreinfo

This allows us to extract from the vmcore only the messages emitted since
the last time the ring buffer was cleared.  We just have to make sure its
value is always up-to-date, when old messages are discarded to free space
in log_make_free_space() for example.

Signed-off-by: Zeyu Zhao <zzy8200@gmail.com>
Signed-off-by: Ivan Delalande <colona@arista.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/printk/printk.c~printk-add-clear_idx-symbol-to-vmcoreinfo kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-clear_idx-symbol-to-vmcoreinfo
+++ a/kernel/printk/printk.c
@@ -368,16 +368,20 @@ static int logbuf_has_space(u32 msg_size
 
 static int log_make_free_space(u32 msg_size)
 {
-	while (log_first_seq < log_next_seq) {
-		if (logbuf_has_space(msg_size, false))
-			return 0;
+	while (log_first_seq < log_next_seq &&
+	       !logbuf_has_space(msg_size, false)) {
 		/* drop old messages until we have enough contiguous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
 
+	if (clear_seq < log_first_seq) {
+		clear_seq = log_first_seq;
+		clear_idx = log_first_idx;
+	}
+
 	/* sequence numbers are equal, so the log buffer is empty */
-	if (logbuf_has_space(msg_size, true))
+	if (logbuf_has_space(msg_size, log_first_seq == log_next_seq))
 		return 0;
 
 	return -ENOMEM;
@@ -855,6 +859,7 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_buf);
 	VMCOREINFO_SYMBOL(log_buf_len);
 	VMCOREINFO_SYMBOL(log_first_idx);
+	VMCOREINFO_SYMBOL(clear_idx);
 	VMCOREINFO_SYMBOL(log_next_idx);
 	/*
 	 * Export struct printk_log size and field offsets. User space tools can
@@ -1217,12 +1222,6 @@ static int syslog_print_all(char __user
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_first_seq) {
-			/* messages are gone, move to first available one */
-			clear_seq = log_first_seq;
-			clear_idx = log_first_idx;
-		}
