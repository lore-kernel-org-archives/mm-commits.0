From: akpm@linux-foundation.org
Subject: - drop-the-exporting-of-empty-linux-byteorder-generich.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:26 -0700
Message-ID: <200805010933.m419XQXX031142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758103AbYEAJdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     Drop the exporting of empty <linux/byteorder/generic.h>
has been removed from the -mm tree.  Its filename was
     drop-the-exporting-of-empty-linux-byteorder-generich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Drop the exporting of empty <linux/byteorder/generic.h>
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Fix up the contents of <linux/byteorder/> so that it doesn't export a
content-free generic.h to user space.  This involves:

* Removing the __KERNEL__ tests from generic.h and dropping it from
  Kbuild.
* Wrapping the inclusions of generic.h in both big_endian.h and
  little_endian.h in __KERNEL__ tests.
* Shifting big_endian.h and little_endian.h from header-y to
  unifdef-y in Kbuild.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/Kbuild          |    6 ++----
 include/linux/byteorder/big_endian.h    |    2 ++
 include/linux/byteorder/generic.h       |    8 --------
 include/linux/byteorder/little_endian.h |    2 ++
 4 files changed, 6 insertions(+), 12 deletions(-)

diff -puN include/linux/byteorder/Kbuild~drop-the-exporting-of-empty-linux-byteorder-generich include/linux/byteorder/Kbuild
--- a/include/linux/byteorder/Kbuild~drop-the-exporting-of-empty-linux-byteorder-generich
+++ a/include/linux/byteorder/Kbuild
@@ -1,5 +1,3 @@
-header-y += big_endian.h
-header-y += little_endian.h
-
-unifdef-y += generic.h
+unifdef-y += big_endian.h
+unifdef-y += little_endian.h
 unifdef-y += swab.h
diff -puN include/linux/byteorder/big_endian.h~drop-the-exporting-of-empty-linux-byteorder-generich include/linux/byteorder/big_endian.h
--- a/include/linux/byteorder/big_endian.h~drop-the-exporting-of-empty-linux-byteorder-generich
+++ a/include/linux/byteorder/big_endian.h
@@ -101,6 +101,8 @@ static inline __u16 __be16_to_cpup(const
 #define __cpu_to_be16s(x) do {} while (0)
 #define __be16_to_cpus(x) do {} while (0)
 
+#ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
+#endif
 
 #endif /* _LINUX_BYTEORDER_BIG_ENDIAN_H */
diff -puN include/linux/byteorder/generic.h~drop-the-exporting-of-empty-linux-byteorder-generich include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~drop-the-exporting-of-empty-linux-byteorder-generich
+++ a/include/linux/byteorder/generic.h
@@ -82,12 +82,6 @@
  *
  */
 
-
-#if defined(__KERNEL__)
-/*
- * inside the kernel, we can use nicknames;
- * outside of it, we must avoid POSIX namespace pollution...
- */
 #define cpu_to_le64 __cpu_to_le64
 #define le64_to_cpu __le64_to_cpu
 #define cpu_to_le32 __cpu_to_le32
@@ -176,6 +170,4 @@ static inline void be64_add_cpu(__be64 *
 	*var = cpu_to_be64(be64_to_cpu(*var) + val);
 }
 
-#endif /* KERNEL */
