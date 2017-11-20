From: akpm@linux-foundation.org
Subject: [merged] proc-uninline-name_to_int.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:23:05 -0800
Message-ID: <20171120212305.xxNLRQHgV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbdKTVXG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: : uninline name_to_int()
has been removed from the -mm tree.  Its filename was
     proc-uninline-name_to_int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: : uninline name_to_int()

Save ~360 bytes.

	add/remove: 1/0 grow/shrink: 0/4 up/down: 104/-463 (-359)
	function                                     old     new   delta
	name_to_int                                    -     104    +104
	proc_pid_lookup                              217     126     -91
	proc_lookupfd_common                         212     121     -91
	proc_task_lookup                             289     194     -95
	__proc_create                                588     402    -186

Link: http://lkml.kernel.org/r/20170912194850.GA17730@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile   |    1 +
 fs/proc/internal.h |   23 +----------------------
 fs/proc/util.c     |   23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+), 22 deletions(-)

diff -puN fs/proc/internal.h~proc-uninline-name_to_int fs/proc/internal.h
--- a/fs/proc/internal.h~proc-uninline-name_to_int
+++ a/fs/proc/internal.h
@@ -103,28 +103,7 @@ static inline struct task_struct *get_pr
 void task_dump_owner(struct task_struct *task, mode_t mode,
 		     kuid_t *ruid, kgid_t *rgid);
 
-static inline unsigned name_to_int(const struct qstr *qstr)
-{
-	const char *name = qstr->name;
-	int len = qstr->len;
-	unsigned n = 0;
-
-	if (len > 1 && *name == '0')
-		goto out;
-	while (len-- > 0) {
-		unsigned c = *name++ - '0';
-		if (c > 9)
-			goto out;
-		if (n >= (~0U-9)/10)
-			goto out;
-		n *= 10;
-		n += c;
-	}
-	return n;
-out:
-	return ~0U;
-}
-
+unsigned name_to_int(const struct qstr *qstr);
 /*
  * Offset of the first process in the /proc root directory..
  */
diff -puN fs/proc/Makefile~proc-uninline-name_to_int fs/proc/Makefile
--- a/fs/proc/Makefile~proc-uninline-name_to_int
+++ a/fs/proc/Makefile
@@ -21,6 +21,7 @@ proc-y	+= loadavg.o
 proc-y	+= meminfo.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
+proc-y	+= util.o
 proc-y	+= version.o
 proc-y	+= softirqs.o
 proc-y	+= namespaces.o
diff -puN /dev/null fs/proc/util.c
--- /dev/null
+++ a/fs/proc/util.c
@@ -0,0 +1,23 @@
+#include <linux/dcache.h>
+
+unsigned name_to_int(const struct qstr *qstr)
+{
+	const char *name = qstr->name;
+	int len = qstr->len;
+	unsigned n = 0;
+
+	if (len > 1 && *name == '0')
+		goto out;
+	while (len-- > 0) {
+		unsigned c = *name++ - '0';
+		if (c > 9)
+			goto out;
+		if (n >= (~0U-9)/10)
+			goto out;
+		n *= 10;
+		n += c;
+	}
+	return n;
+out:
+	return ~0U;
+}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

