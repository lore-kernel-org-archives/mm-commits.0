From: akpm@linux-foundation.org
Subject: + radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:18:08 -0800
Message-ID: <200802280318.m1S3I8ph012998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbYB1DSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, airlied@linux.ie


The patch titled
     drm: radeon: fix integer as NULL pointer warnings in radeon_mem.c
has been added to the -mm tree.  Its filename is
     radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch

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
Subject: drm: radeon: fix integer as NULL pointer warnings in radeon_mem.c
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/char/drm/radeon_mem.c:91:23: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:116:28: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:124:28: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:177:26: warning: Using plain integer as NULL pointer
drivers/char/drm/radeon_mem.c:177:53: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/radeon_mem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/drm/radeon_mem.c~radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc drivers/char/drm/radeon_mem.c
--- a/drivers/char/drm/radeon_mem.c~radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc
+++ a/drivers/char/drm/radeon_mem.c
@@ -88,7 +88,7 @@ static struct mem_block *alloc_block(str
 
 	list_for_each(p, heap) {
 		int start = (p->start + mask) & ~mask;
-		if (p->file_priv == 0 && start + size <= p->start + p->size)
+		if (p->file_priv == NULL && start + size <= p->start + p->size)
 			return split_block(p, start, size, file_priv);
 	}
 
@@ -113,7 +113,7 @@ static void free_block(struct mem_block 
 	/* Assumes a single contiguous range.  Needs a special file_priv in
 	 * 'heap' to stop it being subsumed.
 	 */
-	if (p->next->file_priv == 0) {
+	if (p->next->file_priv == NULL) {
 		struct mem_block *q = p->next;
 		p->size += q->size;
 		p->next = q->next;
@@ -121,7 +121,7 @@ static void free_block(struct mem_block 
 		drm_free(q, sizeof(*q), DRM_MEM_BUFS);
 	}
 
-	if (p->prev->file_priv == 0) {
+	if (p->prev->file_priv == NULL) {
 		struct mem_block *q = p->prev;
 		q->size += p->size;
 		q->next = p->next;
@@ -174,7 +174,7 @@ void radeon_mem_release(struct drm_file 
 	 * 'heap' to stop it being subsumed.
 	 */
 	list_for_each(p, heap) {
-		while (p->file_priv == 0 && p->next->file_priv == 0) {
+		while (p->file_priv == NULL && p->next->file_priv == NULL) {
 			struct mem_block *q = p->next;
 			p->size += q->size;
 			p->next = q->next;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs.patch
video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs-checkpatch-fixes.patch
git-x86.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
