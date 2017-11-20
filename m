From: akpm@linux-foundation.org
Subject: + proc-fix-proc-map_files-lookup.patch added to -mm tree
Date: Mon, 20 Nov 2017 14:18:14 -0800
Message-ID: <5a1354a6.Y8o4nkhut/CL+t4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKTWSQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 17:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix /proc/*/map_files lookup
has been added to the -mm tree.  Its filename is
     proc-fix-proc-map_files-lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-proc-map_files-lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-proc-map_files-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20171120212706.GA14325@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
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
@@ -1907,8 +1909,33 @@ end_instantiate:
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

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
seq_file-delete-small-value-optimization.patch

