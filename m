From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-rename-log_align-to-printk_log_align.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:04:21 -0700
Message-ID: <20121023200421.AA405100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43719 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2JWUEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:04:22 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so334625yen.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:04:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: rename LOG_ALIGN to PRINTK_LOG_ALIGN
has been removed from the -mm tree.  Its filename was
     printk-rename-log_align-to-printk_log_align.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename LOG_ALIGN to PRINTK_LOG_ALIGN

Make the #define more specific to the printk subsystem.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-log_align-to-printk_log_align kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-log_align-to-printk_log_align
+++ a/kernel/printk/printk.c
@@ -239,12 +239,12 @@ u32 printk_log_clear_idx;
 
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define LOG_ALIGN 4
+#define PRINTK_LOG_ALIGN 4
 #else
-#define LOG_ALIGN __alignof__(struct printk_log)
+#define PRINTK_LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
+char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
 char *printk_log_buf = __printk_log_buf;
 u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
@@ -306,7 +306,7 @@ void printk_log_store(int facility, int 
 
 	/* number of '\0' padding bytes to next message */
 	size = sizeof(struct printk_log) + text_len + dict_len;
-	pad_len = (-size) & (LOG_ALIGN - 1);
+	pad_len = (-size) & (PRINTK_LOG_ALIGN - 1);
 	size += pad_len;
 
 	while (printk_log_first_seq < printk_log_next_seq) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

