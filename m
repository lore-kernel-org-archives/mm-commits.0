From: akpm@linux-foundation.org
Subject: - uml-remove-now-unused-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:35 -0800
Message-ID: <200802052235.m15MZGXi012599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762498AbYBEWll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magotari@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove now unused code
has been removed from the -mm tree.  Its filename was
     uml-remove-now-unused-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove now unused code
From: Karol Swietlicki <magotari@gmail.com>

This patch finishes what the previous one started.  The code was not used
after my first patch, and now can be removed with ease.

[ jdike - also deleted the #if 0 lcall stuff ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/bugs.c |  137 --------------------------------------
 1 file changed, 137 deletions(-)

diff -puN arch/um/sys-i386/bugs.c~uml-remove-now-unused-code arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-remove-now-unused-code
+++ a/arch/um/sys-i386/bugs.c
@@ -12,8 +12,6 @@
 #include "user.h"
 #include "sysdep/archsetjmp.h"
 
-#define MAXTOKEN 64
-
 /* Set during early boot */
 int host_has_cmov = 1;
 static jmp_buf cmov_test_return;
@@ -46,139 +44,8 @@ static void test_for_host_cmov(void)
 	sigaction(SIGILL, &old, &new);
 }
 
-static char token(int fd, char *buf, int len, char stop)
-{
-	int n;
-	char *ptr, *end, c;
-
-	ptr = buf;
-	end = &buf[len];
-	do {
-		n = os_read_file(fd, ptr, sizeof(*ptr));
-		c = *ptr++;
-		if (n != sizeof(*ptr)) {
-			if (n == 0)
-				return 0;
-			printk(UM_KERN_ERR "Reading /proc/cpuinfo failed, "
-			       "err = %d\n", -n);
-			if (n < 0)
-				return n;
-			else return -EIO;
-		}
-	} while ((c != '\n') && (c != stop) && (ptr < end));
-
-	if (ptr == end) {
-		printk(UM_KERN_ERR "Failed to find '%c' in /proc/cpuinfo\n",
-		       stop);
-		return -1;
-	}
-	*(ptr - 1) = '\0';
-	return c;
-}
-
-static int find_cpuinfo_line(int fd, char *key, char *scratch, int len)
-{
-	int n;
-	char c;
-
-	scratch[len - 1] = '\0';
-	while (1) {
-		c = token(fd, scratch, len - 1, ':');
-		if (c <= 0)
-			return 0;
-		else if (c != ':') {
-			printk(UM_KERN_ERR "Failed to find ':' in "
-			       "/proc/cpuinfo\n");
-			return 0;
-		}
-
-		if (!strncmp(scratch, key, strlen(key)))
-			return 1;
-
-		do {
-			n = os_read_file(fd, &c, sizeof(c));
-			if (n != sizeof(c)) {
-				printk(UM_KERN_ERR "Failed to find newline in "
-				       "/proc/cpuinfo, err = %d\n", -n);
-				return 0;
-			}
-		} while (c != '\n');
-	}
-	return 0;
-}
-
-static int check_cpu_flag(char *feature, int *have_it)
-{
-	char buf[MAXTOKEN], c;
-	int fd, len = ARRAY_SIZE(buf);
-
-	printk(UM_KERN_INFO "Checking for host processor %s support...",
-	       feature);
-	fd = os_open_file("/proc/cpuinfo", of_read(OPENFLAGS()), 0);
-	if (fd < 0) {
-		printk(UM_KERN_ERR "Couldn't open /proc/cpuinfo, err = %d\n",
-		       -fd);
-		return 0;
-	}
-
-	*have_it = 0;
-	if (!find_cpuinfo_line(fd, "flags", buf, ARRAY_SIZE(buf)))
-		goto out;
-
-	c = token(fd, buf, len - 1, ' ');
-	if (c < 0)
-		goto out;
-	else if (c != ' ') {
-		printk(UM_KERN_ERR "Failed to find ' ' in /proc/cpuinfo\n");
-		goto out;
-	}
-
-	while (1) {
-		c = token(fd, buf, len - 1, ' ');
-		if (c < 0)
-			goto out;
-		else if (c == '\n')
-			break;
-
-		if (!strcmp(buf, feature)) {
-			*have_it = 1;
-			goto out;
-		}
-	}
- out:
-	if (*have_it == 0)
-		printk("No\n");
-	else if (*have_it == 1)
-		printk("Yes\n");
-	os_close_file(fd);
-	return 1;
-}
-
-#if 0 /*
-       * This doesn't work in tt mode, plus it's causing compilation problems
-       * for some people.
-       */
-static void disable_lcall(void)
-{
-	struct modify_ldt_ldt_s ldt;
-	int err;
-
-	bzero(&ldt, sizeof(ldt));
-	ldt.entry_number = 7;
-	ldt.base_addr = 0;
-	ldt.limit = 0;
-	err = modify_ldt(1, &ldt, sizeof(ldt));
-	if (err)
-		printk(UM_KERN_ERR "Failed to disable lcall7 - errno = %d\n",
-		       errno);
-}
-#endif
-
 void arch_init_thread(void)
 {
-#if 0
-	disable_lcall();
-#endif
 }
 
 void arch_check_bugs(void)
@@ -209,10 +76,6 @@ int arch_handle_signal(int sig, struct u
 	else if (host_has_cmov == 1)
 		panic("SIGILL caused by cmov, which this processor claims to "
 		      "implement");
-	else if (host_has_cmov == -1)
-		panic("SIGILL caused by cmov, couldn't tell if this processor "
-		      "implements it, boot a filesystem compiled for older "
-		      "processors");
 	else panic("Bad value for host_has_cmov (%d)", host_has_cmov);
 	return 0;
 }
_

Patches currently in -mm which might be from magotari@gmail.com are

origin.patch
