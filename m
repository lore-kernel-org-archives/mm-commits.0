From: akpm@linux-foundation.org
Subject: +
 ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch added
 to -mm tree
Date: Fri, 27 Mar 2015 15:10:09 -0700
Message-ID: <5515d541.zMp4XG6SEZH4K+Zs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbbC0WKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 18:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: logging: remove static buffer, use vsprintf extension %pV
has been added to the -mm tree.  Its filename is
     ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%25pv.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%25pv.patch

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
Subject: ocfs2: logging: remove static buffer, use vsprintf extension %pV

Use the vsprintf %pV extension to avoid using a static buffer and remove
the now unnecessary buffer.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv
+++ a/fs/ocfs2/super.c
@@ -2564,22 +2564,22 @@ static void ocfs2_handle_error(struct su
 	ocfs2_set_ro_flag(osb, 0);
 }
 
-static char error_buf[1024];
-
-void __ocfs2_error(struct super_block *sb,
-		   const char *function,
-		   const char *fmt, ...)
+void __ocfs2_error(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 
 	/* Not using mlog here because we want to show the actual
 	 * function the error came from. */
-	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
+	printk(KERN_CRIT "OCFS2: ERROR (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
+	va_end(args);
 
 	ocfs2_handle_error(sb);
 }
@@ -2587,18 +2587,21 @@ void __ocfs2_error(struct super_block *s
 /* Handle critical errors. This is intentionally more drastic than
  * ocfs2_handle_error, so we only use for things like journal errors,
  * etc. */
-void __ocfs2_abort(struct super_block* sb,
-		   const char *function,
+void __ocfs2_abort(struct super_block *sb, const char *function,
 		   const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
-	va_end(args);
 
-	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %s\n",
-	       sb->s_id, function, error_buf);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "OCFS2: abort (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
+	va_end(args);
 
 	/* We don't have the cluster support yet to go straight to
 	 * hard readonly in here. Until then, we want to keep
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
adfs-returning-correct-return-values.patch
linux-next.patch

