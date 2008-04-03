From: akpm@linux-foundation.org
Subject: + drop-the-exporting-of-empty-linux-byteorder-generich.patch added to -mm tree
Date: Thu, 03 Apr 2008 14:12:05 -0700
Message-ID: <200804032112.m33LC6Pc022788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823AbYDCVQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 17:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     Drop the exporting of empty <linux/byteorder/generic.h>
has been added to the -mm tree.  Its filename is
     drop-the-exporting-of-empty-linux-byteorder-generich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
diff -puN include/linux/byteorder/little_endian.h~drop-the-exporting-of-empty-linux-byteorder-generich include/linux/byteorder/little_endian.h
--- a/include/linux/byteorder/little_endian.h~drop-the-exporting-of-empty-linux-byteorder-generich
+++ a/include/linux/byteorder/little_endian.h
@@ -101,6 +101,8 @@ static inline __u16 __be16_to_cpup(const
 #define __cpu_to_be16s(x) __swab16s((x))
 #define __be16_to_cpus(x) __swab16s((x))
 
+#ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
+#endif
 
 #endif /* _LINUX_BYTEORDER_LITTLE_ENDIAN_H */
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

