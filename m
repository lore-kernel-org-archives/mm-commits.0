From: akpm@linux-foundation.org
Subject: + kernelh-remove-deprecated-pack_hex_byte.patch added to -mm tree
Date: Tue, 24 Jun 2014 16:24:30 -0700
Message-ID: <53aa08ae.hArNLrXOb4Q90La/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaFXXYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 19:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: remove deprecated pack_hex_byte
has been added to the -mm tree.  Its filename is
     kernelh-remove-deprecated-pack_hex_byte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-remove-deprecated-pack_hex_byte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-remove-deprecated-pack_hex_byte.patch

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
Subject: kernel.h: remove deprecated pack_hex_byte

It's been nearly 3 years now since commit 55036ba76b2d ("lib: rename
pack_hex_byte() to hex_byte_pack()") so it's time to remove this
deprecated and unused static inline.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/kernel.h~kernelh-remove-deprecated-pack_hex_byte include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-remove-deprecated-pack_hex_byte
+++ a/include/linux/kernel.h
@@ -493,11 +493,6 @@ static inline char *hex_byte_pack_upper(
 	return buf;
 }
 
-static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
-{
-	return hex_byte_pack(buf, byte);
-}
-
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch

