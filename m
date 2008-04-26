From: akpm@linux-foundation.org
Subject: - jffs2-fix-sparse-warnings-in-gcc.patch removed from -mm tree
Date: Sat, 26 Apr 2008 07:14:48 -0700
Message-ID: <200804261414.m3QEEmPF025711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbYDZOO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 10:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: fix sparse warnings in gc.c
has been removed from the -mm tree.  Its filename was
     jffs2-fix-sparse-warnings-in-gcc.patch

This patch was dropped because of plot-lossage

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: fix sparse warnings in gc.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jffs2/gc.c:1147:29: warning: symbol 'jeb' shadows an earlier one
fs/jffs2/gc.c:1084:89: originally declared here
fs/jffs2/gc.c:1197:29: warning: symbol 'jeb' shadows an earlier one
fs/jffs2/gc.c:1084:89: originally declared here

Add an sb_ prefix to the inner jeb variables as they are taken from
the super_blocks list.

It appears jffs2_garbage_collect_dnode never uses its jeb argument,
so as an alternative that could be dropped and the one caller adusted
then the inner variables would not need to be touched.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/gc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/jffs2/gc.c~jffs2-fix-sparse-warnings-in-gcc fs/jffs2/gc.c
--- a/fs/jffs2/gc.c~jffs2-fix-sparse-warnings-in-gcc
+++ a/fs/jffs2/gc.c
@@ -1144,24 +1144,24 @@ static int jffs2_garbage_collect_dnode(s
 				   If not, cover it anyway. */
 
 				struct jffs2_raw_node_ref *raw = frag->node->raw;
-				struct jffs2_eraseblock *jeb;
+				struct jffs2_eraseblock *sb_jeb;
 
-				jeb = &c->blocks[raw->flash_offset / c->sector_size];
+				sb_jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
-				if (jeb == c->gcblock) {
+				if (sb_jeb == c->gcblock) {
 					D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
 						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
 					start = frag->ofs;
 					break;
 				}
-				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
+				if (!ISDIRTY(sb_jeb->dirty_size + sb_jeb->wasted_size)) {
 					D1(printk(KERN_DEBUG "Not expanding down to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 					break;
 				}
 
 				D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 				start = frag->ofs;
 				break;
 			}
@@ -1194,24 +1194,24 @@ static int jffs2_garbage_collect_dnode(s
 				   If not, cover it anyway. */
 
 				struct jffs2_raw_node_ref *raw = frag->node->raw;
-				struct jffs2_eraseblock *jeb;
+				struct jffs2_eraseblock *sb_jeb;
 
-				jeb = &c->blocks[raw->flash_offset / c->sector_size];
+				sb_jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
-				if (jeb == c->gcblock) {
+				if (sb_jeb == c->gcblock) {
 					D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in gcblock at %08x\n",
 						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
 					end = frag->ofs + frag->size;
 					break;
 				}
-				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
+				if (!ISDIRTY(sb_jeb->dirty_size + sb_jeb->wasted_size)) {
 					D1(printk(KERN_DEBUG "Not expanding up to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 					break;
 				}
 
 				D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+						  frag->ofs, frag->ofs+frag->size, sb_jeb->offset));
 				end = frag->ofs + frag->size;
 				break;
 			}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-agpgart.patch
cifs-remove-global_extern-macro.patch
git-dvb.patch
git-kvm.patch
git-mips.patch
jffs2-fix-sparse-warnings-in-gcc.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
input-replace-remaining-__function__-occurrences.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
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

