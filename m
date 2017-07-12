From: akpm@linux-foundation.org
Subject: [patch 10/96] sysctl: kdoc'ify sysctl_writes_strict
Date: Wed, 12 Jul 2017 14:33:30 -0700
Message-ID: <20170712213330.eh8K9L1nC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdGLVdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: sysctl: kdoc'ify sysctl_writes_strict

Document the different sysctl_writes_strict modes in code.

Link: http://lkml.kernel.org/r/20170519033554.18592-3-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~sysctl-kdocify-sysctl_writes_strict kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-kdocify-sysctl_writes_strict
+++ a/kernel/sysctl.c
@@ -174,11 +174,32 @@ extern int no_unaligned_warning;
 
 #ifdef CONFIG_PROC_SYSCTL
 
-#define SYSCTL_WRITES_LEGACY	-1
-#define SYSCTL_WRITES_WARN	 0
-#define SYSCTL_WRITES_STRICT	 1
+/**
+ * enum sysctl_writes_mode - supported sysctl write modes
+ *
+ * @SYSCTL_WRITES_LEGACY: each write syscall must fully contain the sysctl value
+ * 	to be written, and multiple writes on the same sysctl file descriptor
+ * 	will rewrite the sysctl value, regardless of file position. No warning
+ * 	is issued when the initial position is not 0.
+ * @SYSCTL_WRITES_WARN: same as above but warn when the initial file position is
+ * 	not 0.
+ * @SYSCTL_WRITES_STRICT: writes to numeric sysctl entries must always be at
+ * 	file position 0 and the value must be fully contained in the buffer
+ * 	sent to the write syscall. If dealing with strings respect the file
+ * 	position, but restrict this to the max length of the buffer, anything
+ * 	passed the max lenght will be ignored. Multiple writes will append
+ * 	to the buffer.
+ *
+ * These write modes control how current file position affects the behavior of
+ * updating sysctl values through the proc interface on each write.
+ */
+enum sysctl_writes_mode {
+	SYSCTL_WRITES_LEGACY		= -1,
+	SYSCTL_WRITES_WARN		= 0,
+	SYSCTL_WRITES_STRICT		= 1,
+};
 
-static int sysctl_writes_strict = SYSCTL_WRITES_STRICT;
+static enum sysctl_writes_mode sysctl_writes_strict = SYSCTL_WRITES_STRICT;
 
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
_
