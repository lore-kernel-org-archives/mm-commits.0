From: akpm@linux-foundation.org
Subject: - printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:06:40 -0700
Message-ID: <200710162206.l9GM6e1c020024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934548AbXJPWH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, gerg@snapgear.com, lethal@linux-sh.org, rgetz@blackfin.uclinux.org, rmk@arm.linux.org.uk, tim.bird@am.sony.com, mm-commits@vger.kernel.org


The patch titled
     printk-add-interfaces-for-external-access-to-the-log-buffer fix 2
has been removed from the -mm tree.  Its filename was
     printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch

This patch was dropped because it was folded into printk-add-interfaces-for-external-access-to-the-log-buffer.patch

------------------------------------------------------
Subject: printk-add-interfaces-for-external-access-to-the-log-buffer fix 2
From: Mike Frysinger <vapier@gentoo.org>

Key off of the log buffer rather than the kernel ring buffer as the
latter is constantly cleared by userspace daemons.  Also, make sure
we index into the buffer properly as pointed out by Tim Bird.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2 kernel/printk.c
--- a/kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2
+++ a/kernel/printk.c
@@ -224,7 +224,7 @@ static inline void boot_delay_msec(void)
  */
 int log_buf_get_len(void)
 {
-	return log_end - log_start;
+	return logged_chars;
 }
 
 /*
@@ -247,10 +247,9 @@ int log_buf_copy(char *dest, int idx, in
 		if (len > max)
 			len = max;
 		ret = len;
-		while (len-- > 0) {
-			*dest = LOG_BUF(idx++);
-			++dest;
-		}
+		idx += (log_end - max);
+		while (len-- > 0)
+			dest[len] = LOG_BUF(idx + len);
 	}
 
 	if (took_lock)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
add-stack-checking-for-blackfin.patch
