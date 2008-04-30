From: akpm@linux-foundation.org
Subject: - kernel-fix-integer-as-null-pointer-sparse-warnings.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:03 -0700
Message-ID: <200804300552.m3U5q3ru030277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759335AbYD3Fwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     kernel: fix integer as NULL pointer sparse warnings
has been removed from the -mm tree.  Its filename was
     kernel-fix-integer-as-null-pointer-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: fix integer as NULL pointer sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

kernel/cpuset.c:1268:52: warning: Using plain integer as NULL pointer
kernel/pid_namespace.c:95:24: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Reviewed-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c        |    3 ++-
 kernel/pid_namespace.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~kernel-fix-integer-as-null-pointer-sparse-warnings kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-fix-integer-as-null-pointer-sparse-warnings
+++ a/kernel/cpuset.c
@@ -1256,7 +1256,8 @@ static ssize_t cpuset_common_file_write(
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
diff -puN kernel/pid_namespace.c~kernel-fix-integer-as-null-pointer-sparse-warnings kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~kernel-fix-integer-as-null-pointer-sparse-warnings
+++ a/kernel/pid_namespace.c
@@ -92,7 +92,7 @@ static struct pid_namespace *create_pid_
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
 	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
+		ns->pidmap[i].page = NULL;
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

