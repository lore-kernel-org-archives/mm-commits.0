From: akpm@linux-foundation.org
Subject: [merged] preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:04 -0700
Message-ID: <200904061938.n36Jc4YA013203__41094.888925045$1239047122$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726AbZDFTne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@redhat.com, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, ralf@linux-mips.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     preadv/pwritev: switch compat readv/preadv/writev/pwritev from fget to fget_light
has been removed from the -mm tree.  Its filename was
     preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: switch compat readv/preadv/writev/pwritev from fget to fget_light
From: Gerd Hoffmann <kraxel@redhat.com>

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/compat.c~preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light fs/compat.c
--- a/fs/compat.c~preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light
+++ a/fs/compat.c
@@ -1222,13 +1222,14 @@ compat_sys_readv(unsigned long fd, const
 		 unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1238,15 +1239,16 @@ compat_sys_preadv(unsigned long fd, cons
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1277,13 +1279,14 @@ compat_sys_writev(unsigned long fd, cons
 		  unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1293,15 +1296,16 @@ compat_sys_pwritev(unsigned long fd, con
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
_

Patches currently in -mm which might be from kraxel@redhat.com are

origin.patch
linux-next.patch

