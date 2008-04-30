From: akpm@linux-foundation.org
Subject: - adfs-work-around-bogus-sparse-warning.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:54 -0700
Message-ID: <200804300538.m3U5csXK028784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbYD3FjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     adfs: work around bogus sparse warning
has been removed from the -mm tree.  Its filename was
     adfs-work-around-bogus-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adfs: work around bogus sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/adfs/dir_f.c:126:4: warning: do-while statement is not a compound statement

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_f.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/adfs/dir_f.c~adfs-work-around-bogus-sparse-warning fs/adfs/dir_f.c
--- a/fs/adfs/dir_f.c~adfs-work-around-bogus-sparse-warning
+++ a/fs/adfs/dir_f.c
@@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir
 		ptr.ptr8 = bufoff(bh, i);
 		end.ptr8 = ptr.ptr8 + last - i;
 
-		do
+		do {
 			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
-		while (ptr.ptr8 < end.ptr8);
+		} while (ptr.ptr8 < end.ptr8);
 	}
 
 	/*
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

