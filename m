From: akpm@linux-foundation.org
Subject: [merged] sysctl-allow-for-strict-write-position-handling.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:47 -0700
Message-ID: <53960c93.u8ACPIaKXIisIOSR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFITfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org

Subject: [merged] sysctl-allow-for-strict-write-position-handling.patch removed from -mm tree
To: keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:47 -0700


The patch titled
     Subject: sysctl: allow for strict write position handling
has been removed from the -mm tree.  Its filename was
     sysctl-allow-for-strict-write-position-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: allow for strict write position handling

When writing to a sysctl string, each write, regardless of VFS position,
begins writing the string from the start.  This means the contents of the
last write to the sysctl controls the string contents instead of the
first:

open("/proc/sys/kernel/modprobe", O_WRONLY)   = 1
write(1, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"..., 4096) = 4096
write(1, "/bin/true", 9)                = 9
close(1)                                = 0

$ cat /proc/sys/kernel/modprobe
/bin/true

Expected behaviour would be to have the sysctl be "AAAA..." capped at
maxlen (in this case KMOD_PATH_LEN: 256), instead of truncating to the
contents of the second write.  Similarly, multiple short writes would not
append to the sysctl.

The old behavior is unlike regular POSIX files enough that doing audits of
software that interact with sysctls can end up in unexpected or dangerous
situations.  For example, "as long as the input starts with a trusted
path" turns out to be an insufficient filter, as what must also happen is
for the input to be entirely contained in a single write syscall -- not a
common consideration, especially for high level tools.

This provides kernel.sysctl_writes_strict as a way to make this behavior
act in a less surprising manner for strings, and disallows non-zero file
position when writing numeric sysctls (similar to what is already done
when reading from non-zero file positions).  For now, the default (0) is
to warn about non-zero file position use, but retain the legacy behavior. 
Setting this to -1 disables the warning, and setting this to 1 enables the
file position respecting behavior.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: move misplaced hunk, per Randy]
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   21 +++++++++
 kernel/sysctl.c                 |   69 +++++++++++++++++++++++++++++-
 2 files changed, 88 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~sysctl-allow-for-strict-write-position-handling Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sysctl-allow-for-strict-write-position-handling
+++ a/Documentation/sysctl/kernel.txt
@@ -77,6 +77,7 @@ show up in /proc/sys/kernel:
 - shmmni
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
+- sysctl_writes_strict
 - tainted
 - threads-max
 - unknown_nmi_panic
@@ -762,6 +763,26 @@ without users and with a dead originativ
 
 ==============================================================
 
+sysctl_writes_strict:
+
+Control how file position affects the behavior of updating sysctl values
+via the /proc/sys interface:
+
+  -1 - Legacy per-write sysctl value handling, with no printk warnings.
+       Each write syscall must fully contain the sysctl value to be
+       written, and multiple writes on the same sysctl file descriptor
+       will rewrite the sysctl value, regardless of file position.
+   0 - (default) Same behavior as above, but warn about processes that
+       perform writes to a sysctl file descriptor when the file position
+       is not 0.
+   1 - Respect file position when writing sysctl strings. Multiple writes
+       will append to the sysctl value buffer. Anything past the max length
+       of the sysctl value buffer will be ignored. Writes to numeric sysctl
+       entries must always be at file position 0 and the value must be
+       fully contained in the buffer sent in the write syscall.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
diff -puN kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-for-strict-write-position-handling
+++ a/kernel/sysctl.c
@@ -173,6 +173,13 @@ extern int no_unaligned_warning;
 #endif
 
 #ifdef CONFIG_PROC_SYSCTL
+
+#define SYSCTL_WRITES_LEGACY	-1
+#define SYSCTL_WRITES_WARN	 0
+#define SYSCTL_WRITES_STRICT	 1
+
+static int sysctl_writes_strict = SYSCTL_WRITES_WARN;
+
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 static int proc_taint(struct ctl_table *table, int write,
@@ -495,6 +502,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_taint,
 	},
+	{
+		.procname	= "sysctl_writes_strict",
+		.data		= &sysctl_writes_strict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
+		.extra2		= &one,
+	},
 #endif
 #ifdef CONFIG_LATENCYTOP
 	{
@@ -1717,8 +1733,20 @@ static int _proc_do_string(char *data, i
 	}
 
 	if (write) {
-		/* Start writing from beginning of buffer. */
-		len = 0;
+		if (sysctl_writes_strict == SYSCTL_WRITES_STRICT) {
+			/* Only continue writes not past the end of buffer. */
+			len = strlen(data);
+			if (len > maxlen - 1)
+				len = maxlen - 1;
+
+			if (*ppos > len)
+				return 0;
+			len = *ppos;
+		} else {
+			/* Start writing from beginning of buffer. */
+			len = 0;
+		}
+
 		*ppos += *lenp;
 		p = buffer;
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
@@ -1758,6 +1786,14 @@ static int _proc_do_string(char *data, i
 	return 0;
 }
 
+static void warn_sysctl_write(struct ctl_table *table)
+{
+	pr_warn_once("%s wrote to %s when file position was not 0!\n"
+		"This will not be supported in the future. To silence this\n"
+		"warning, set kernel.sysctl_writes_strict = -1\n",
+ 		current->comm, table->procname);
+}
+
 /**
  * proc_dostring - read a string sysctl
  * @table: the sysctl table
@@ -1778,6 +1814,9 @@ static int _proc_do_string(char *data, i
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
+	if (write && *ppos && sysctl_writes_strict == SYSCTL_WRITES_WARN)
+		warn_sysctl_write(table);
+
 	return _proc_do_string((char *)(table->data), table->maxlen, write,
 			       (char __user *)buffer, lenp, ppos);
 }
@@ -1953,6 +1992,18 @@ static int __do_proc_dointvec(void *tbl_
 		conv = do_proc_dointvec_conv;
 
 	if (write) {
+		if (*ppos) {
+			switch (sysctl_writes_strict) {
+			case SYSCTL_WRITES_STRICT:
+				goto out;
+			case SYSCTL_WRITES_WARN:
+				warn_sysctl_write(table);
+				break;
+			default:
+				break;
+			}
+		}
+
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2010,6 +2061,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
@@ -2202,6 +2254,18 @@ static int __do_proc_doulongvec_minmax(v
 	left = *lenp;
 
 	if (write) {
+		if (*ppos) {
+			switch (sysctl_writes_strict) {
+			case SYSCTL_WRITES_STRICT:
+				goto out;
+			case SYSCTL_WRITES_WARN:
+				warn_sysctl_write(table);
+				break;
+			default:
+				break;
+			}
+		}
+
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2257,6 +2321,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

