From: akpm@linux-foundation.org
Subject: + printk-rename-log_align-to-printk_log_align.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:17:02 -0700
Message-ID: <20121018231703.C963B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:56332 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2JRXRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:17:06 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so553850lah.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:17:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: rename LOG_ALIGN to PRINTK_LOG_ALIGN
has been added to the -mm tree.  Its filename is
     printk-rename-log_align-to-printk_log_align.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printk-move-to-separate-directory-for-easier-modification.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
printk-rename-log_buf-and-__log_buf_len.patch
printk-rename-log_first-and-log_next-variables.patch
printk-rename-log_foo-variables-and-functions.patch
printk-rename-enum-log_flags-to-printk_log_flags.patch
printk-rename-log_wait-to-printk_log_wait.patch
printk-rename-logbuf_lock-to-printk_logbuf_lock.patch
printk-rename-clear_seq-and-clear_idx-variables.patch
printk-remove-static-from-printk_-variables.patch
printk-rename-log_align-to-printk_log_align.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

