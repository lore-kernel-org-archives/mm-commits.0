From: akpm@linux-foundation.org
Subject: [merged] sysctl-clean-up-char-buffer-arguments.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:37 -0700
Message-ID: <53960c89.Za/7cXP8W2JjPhjq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFITfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org

Subject: [merged] sysctl-clean-up-char-buffer-arguments.patch removed from -mm tree
To: keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:37 -0700


The patch titled
     Subject: sysctl: clean up char buffer arguments
has been removed from the -mm tree.  Its filename was
     sysctl-clean-up-char-buffer-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: clean up char buffer arguments

When writing to a sysctl string, each write, regardless of VFS position,
began writing the string from the start. This meant the contents of
the last write to the sysctl controlled the string contents instead of
the first.

This misbehavior was featured in an exploit against Chrome OS. While it's
not in itself a vulnerability, it's a weirdness that isn't on the mind
of most auditors: "This filter looks correct, the first line written
would not be meaningful to sysctl" doesn't apply here, since the size
of the write and the contents of the final write are what matter when
writing to sysctls.

This adds the sysctl kernel.sysctl_writes_strict to control the write
behavior. The default (0) reports when VFS position is non-0 on a write,
but retains legacy behavior, -1 disables the warning, and 1 enables the
position-respecting behavior.

The long-term plan here is to wait for userspace to be fixed in response
to the new warning and to then switch the default kernel behavior to the
new position-respecting behavior.



This patch (of 4):

The char buffer arguments are needlessly cast in weird places. Clean it up
so things are easier to read.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/sysctl.c~sysctl-clean-up-char-buffer-arguments kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-clean-up-char-buffer-arguments
+++ a/kernel/sysctl.c
@@ -1703,8 +1703,8 @@ int __init sysctl_init(void)
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static int _proc_do_string(void* data, int maxlen, int write,
-			   void __user *buffer,
+static int _proc_do_string(char *data, int maxlen, int write,
+			   char __user *buffer,
 			   size_t *lenp, loff_t *ppos)
 {
 	size_t len;
@@ -1730,7 +1730,7 @@ static int _proc_do_string(void* data, i
 			len = maxlen-1;
 		if(copy_from_user(data, buffer, len))
 			return -EFAULT;
-		((char *) data)[len] = 0;
+		data[len] = 0;
 		*ppos += *lenp;
 	} else {
 		len = strlen(data);
@@ -1748,10 +1748,10 @@ static int _proc_do_string(void* data, i
 		if (len > *lenp)
 			len = *lenp;
 		if (len)
-			if(copy_to_user(buffer, data, len))
+			if (copy_to_user(buffer, data, len))
 				return -EFAULT;
 		if (len < *lenp) {
-			if(put_user('\n', ((char __user *) buffer) + len))
+			if (put_user('\n', buffer + len))
 				return -EFAULT;
 			len++;
 		}
@@ -1781,8 +1781,8 @@ static int _proc_do_string(void* data, i
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	return _proc_do_string(table->data, table->maxlen, write,
-			       buffer, lenp, ppos);
+	return _proc_do_string((char *)(table->data), table->maxlen, write,
+			       (char __user *)buffer, lenp, ppos);
 }
 
 static size_t proc_skip_spaces(char **buf)
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

