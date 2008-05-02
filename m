From: akpm@linux-foundation.org
Subject: - fuse-use-clamp-rather-than-nested-min-max.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:28 -0700
Message-ID: <200805021943.m42JhSwA011294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932625AbYEBToO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: use clamp() rather than nested min/max
has been removed from the -mm tree.  Its filename was
     fuse-use-clamp-rather-than-nested-min-max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: use clamp() rather than nested min/max
From: Harvey Harrison <harvey.harrison@gmail.com>

clamp() exists for this use.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fuse/file.c~fuse-use-clamp-rather-than-nested-min-max fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-use-clamp-rather-than-nested-min-max
+++ a/fs/fuse/file.c
@@ -934,7 +934,7 @@ static int fuse_get_user_pages(struct fu
 
 	nbytes = min(nbytes, (unsigned) FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
 	npages = (nbytes + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	npages = min(max(npages, 1), FUSE_MAX_PAGES_PER_REQ);
+	npages = clamp(npages, 1, FUSE_MAX_PAGES_PER_REQ);
 	down_read(&current->mm->mmap_sem);
 	npages = get_user_pages(current, current->mm, user_addr, npages, write,
 				0, req->pages, NULL);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
misc-fix-integer-as-null-pointer-warnings.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
git-net.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
video-fix-integer-as-null-pointer-warnings.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

