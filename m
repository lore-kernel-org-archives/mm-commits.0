From: akpm@linux-foundation.org
Subject: + lib-vsprintf-add-%pt-format-specifier.patch added to -mm tree
Date: Fri, 10 Jan 2014 16:01:02 -0800
Message-ID: <52d089be.yzRxsNCWU9eaDOzM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaAKABD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 19:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, pavel@ucw.cz, keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp

Subject: + lib-vsprintf-add-%pt-format-specifier.patch added to -mm tree
To: penguin-kernel@i-love.sakura.ne.jp,keescook@chromium.org,pavel@ucw.cz,penguin-kernel@I-love.SAKURA.ne.jp
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 16:01:02 -0800


The patch titled
     From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
has been added to the -mm tree.  Its filename is
     lib-vsprintf-add-%pt-format-specifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-add-%pt-format-specifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-add-%pt-format-specifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: lib/vsprintf: add %pT format specifier

Since task_struct->comm can be modified by other threads while the current
thread is reading it, it is recommended to use get_task_comm() for reading
it.

However, since get_task_comm() holds task_struct->alloc_lock spinlock,
some users cannot use get_task_comm().  Also, a lot of users are directly
reading from task_struct->comm even if they can use get_task_comm().  Such
users might obtain inconsistent result.

This patch introduces %pT format specifier for printing task_struct->comm.
Currently %pT does not provide consistency.  I'm planning to change to
use RCU in the future.  By using RCU, the comm name read from
task_struct->comm will be guaranteed to be consistent.  But before
modifying set_task_comm() to use RCU, we need to kill direct ->comm users
who do not use get_task_comm().

An example for converting direct ->comm users is shown below.  Since many
debug printings use p == current, you can pass NULL instead of p if p ==
current.

  pr_info("comm=%s\n", p->comm);       => pr_info("comm=%pT\n", p);
  pr_info("comm=%s\n", current->comm); => pr_info("comm=%pT\n", NULL);

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    6 ++++++
 lib/vsprintf.c                   |   20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-add-%pt-format-specifier Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-add-%pt-format-specifier
+++ a/Documentation/printk-formats.txt
@@ -184,6 +184,12 @@ dentry names:
 	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
 	n last components.  %pD does the same thing for struct file.
 
+task_struct comm name:
+
+        %pT
+
+        For printing task_struct->comm.
+
 struct va_format:
 
 	%pV
diff -puN lib/vsprintf.c~lib-vsprintf-add-%pt-format-specifier lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pt-format-specifier
+++ a/lib/vsprintf.c
@@ -1179,6 +1179,21 @@ char *address_val(char *buf, char *end,
 	return number(buf, end, num, spec);
 }
 
+static noinline_for_stack
+char *comm_name(char *buf, char *end, struct task_struct *tsk,
+		struct printf_spec spec, const char *fmt)
+{
+	char name[TASK_COMM_LEN];
+
+	/* Caller can pass NULL instead of current. */
+	if (!tsk)
+		tsk = current;
+	/* Not using get_task_comm() in case I'm in IRQ context. */
+	memcpy(name, tsk->comm, TASK_COMM_LEN);
+	name[sizeof(name) - 1] = '\0';
+	return string(buf, end, name, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1246,6 +1261,7 @@ int kptr_restrict __read_mostly;
  *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'T' task_struct->comm
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1257,7 +1273,7 @@ char *pointer(const char *fmt, char *buf
 {
 	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && *fmt != 'T') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1385,6 +1401,8 @@ char *pointer(const char *fmt, char *buf
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'T':
+		return comm_name(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

lib-vsprintf-add-%pt-format-specifier.patch
init-fix-possible-format-string-bug.patch

