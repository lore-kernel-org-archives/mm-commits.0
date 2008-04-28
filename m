From: akpm@linux-foundation.org
Subject: - fbcon-replace-mono_col-macro-with-static-inline.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:24 -0700
Message-ID: <200804282157.m3SLvOuc018395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964937AbYD1V51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbcon: replace mono_col macro with static inline
has been removed from the -mm tree.  Its filename was
     fbcon-replace-mono_col-macro-with-static-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: replace mono_col macro with static inline
From: Harvey Harrison <harvey.harrison@gmail.com>

Use __u32 for max_len to match the declaration of length in the struct
fb_bitfield.

Suppresses sparse shadowed variable warnings from the nested max()
macros:
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_y' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here

[akpm@linux-foundation.org: fix constness]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/fbcon.h~fbcon-replace-mono_col-macro-with-static-inline drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-replace-mono_col-macro-with-static-inline
+++ a/drivers/video/console/fbcon.h
@@ -104,10 +104,14 @@ struct fbcon_ops {
 #define attr_blink(s) \
 	((s) & 0x8000)
 	
-#define mono_col(info)							\
-	(~(0xfff << (max((info)->var.green.length,			\
-			 max((info)->var.red.length,			\
-			     (info)->var.blue.length)))) & 0xff)
+
+static inline int mono_col(const struct fb_info *info)
+{
+	__u32 max_len;
+	max_len = max(info->var.green.length, info->var.red.length);
+	max_len = max(info->var.blue.length, max_len);
+	return ~(0xfff << (max_len & 0xff));
+}
 
 static inline int attr_col_ec(int shift, struct vc_data *vc,
 			      struct fb_info *info, int is_fg)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
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
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
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
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

