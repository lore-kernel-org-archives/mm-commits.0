From: akpm@linux-foundation.org
Subject: [patch 017/114] proc: fix /proc/*/map_files lookup
Date: Tue, 06 Feb 2018 15:36:59 -0800
Message-ID: <20180206233659.xIWAbuOxi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbeBFXhA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, avagin@virtuozzo.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xemul@openvz.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix /proc/*/map_files lookup

Current code does:

	if (sscanf(dentry->d_name.name, "%lx-%lx", start, end) != 2)

However sscanf() is broken garbage.

It silently accepts whitespace between format specifiers
(did you know that?).

It silently accepts valid strings which result in integer overflow.

Do not use sscanf() for any even remotely reliable parsing code.

	OK
	# readlink '/proc/1/map_files/55a23af39000-55a23b05b000'
	/lib/systemd/systemd

	broken
	# readlink '/proc/1/map_files/               55a23af39000-55a23b05b000'
	/lib/systemd/systemd

	broken
	# readlink '/proc/1/map_files/55a23af39000-55a23b05b000    '
	/lib/systemd/systemd

	very broken
	# readlink '/proc/1/map_files/1000000000000000055a23af39000-55a23b05b000'
	/lib/systemd/systemd

Andrei said:

: This patch breaks criu.  It was a bug in criu.  And this bug is on a minor
: path, which works when memfd_create() isn't available.  It is a reason why
: I ask to not backport this patch to stable kernels.
: 
: In CRIU this bug can be triggered, only if this patch will be backported
: to a kernel which version is lower than v3.16.

Link: http://lkml.kernel.org/r/20171120212706.GA14325@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrei Vagin <avagin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-proc-map_files-lookup fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-proc-map_files-lookup
+++ a/fs/proc/base.c
@@ -100,6 +100,8 @@
 #include "internal.h"
 #include "fd.h"
 
+#include "../../lib/kstrtox.h"
+
 /* NOTE:
  *	Implementing inode permission operations in /proc is almost
  *	certainly an error.  Permission checks need to happen during
@@ -1906,8 +1908,33 @@ end_instantiate:
 static int dname_to_vma_addr(struct dentry *dentry,
 			     unsigned long *start, unsigned long *end)
 {
-	if (sscanf(dentry->d_name.name, "%lx-%lx", start, end) != 2)
+	const char *str = dentry->d_name.name;
+	unsigned long long sval, eval;
+	unsigned int len;
+
+	len = _parse_integer(str, 16, &sval);
+	if (len & KSTRTOX_OVERFLOW)
+		return -EINVAL;
+	if (sval != (unsigned long)sval)
+		return -EINVAL;
+	str += len;
+
+	if (*str != '-')
 		return -EINVAL;
+	str++;
+
+	len = _parse_integer(str, 16, &eval);
+	if (len & KSTRTOX_OVERFLOW)
+		return -EINVAL;
+	if (eval != (unsigned long)eval)
+		return -EINVAL;
+	str += len;
+
+	if (*str != '\0')
+		return -EINVAL;
+
+	*start = sval;
+	*end = eval;
 
 	return 0;
 }
_
