From: akpm@linux-foundation.org
Subject: - uml-fix-inconsistence-due-to-tty_operation-change.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:28 -0700
Message-ID: <200805092146.m49LkSXW027113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEIV4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, alan@redhat.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix inconsistence due to tty_operation change
has been removed from the -mm tree.  Its filename was
     uml-fix-inconsistence-due-to-tty_operation-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix inconsistence due to tty_operation change
From: WANG Cong <xiyou.wangcong@gmail.com>

'put_char' of 'struct tty_operations' has changed from 'void' into 'int'. 
This can also shut up comipler warnings.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    4 ++--
 arch/um/include/line.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/line.c~uml-fix-inconsistence-due-to-tty_operation-change arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-inconsistence-due-to-tty_operation-change
+++ a/arch/um/drivers/line.c
@@ -191,9 +191,9 @@ void line_flush_chars(struct tty_struct 
 	line_flush_buffer(tty);
 }
 
-void line_put_char(struct tty_struct *tty, unsigned char ch)
+int line_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	line_write(tty, &ch, sizeof(ch));
+	return line_write(tty, &ch, sizeof(ch));
 }
 
 int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
diff -puN arch/um/include/line.h~uml-fix-inconsistence-due-to-tty_operation-change arch/um/include/line.h
--- a/arch/um/include/line.h~uml-fix-inconsistence-due-to-tty_operation-change
+++ a/arch/um/include/line.h
@@ -71,7 +71,7 @@ extern int line_setup(struct line *lines
 		      char *init, char **error_out);
 extern int line_write(struct tty_struct *tty, const unsigned char *buf,
 		      int len);
-extern void line_put_char(struct tty_struct *tty, unsigned char ch);
+extern int line_put_char(struct tty_struct *tty, unsigned char ch);
 extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
 extern int line_chars_in_buffer(struct tty_struct *tty);
 extern void line_flush_buffer(struct tty_struct *tty);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
uml-use-div_round_up.patch
uml-use-page_size-in-linker-scripts.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
fs-binfmt_elfc-fix-a-wrong-free.patch
cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
fs-execc-export-free_arg_pages.patch
fs-execc-fix-resource-leaks-and-wrong-gotos.patch
fs-compatc-fix-resource-leaks-and-wrong-gotos.patch
fs-binfmt_scriptc-fix-resource-leaks.patch
fs-binfmt_em86c-fix-resource-leaks.patch
fs-binfmt_miscc-fix-resource-leaks.patch
fs-execc-fix-wrong-return-value-of-prepare_binprm.patch
fs-binfmt_elfc-fix-wrong-return-values.patch

