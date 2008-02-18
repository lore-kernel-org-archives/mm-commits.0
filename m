From: akpm@linux-foundation.org
Subject: + jffs2-fix-sparse-warnings-in-gcc.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:00:50 -0800
Message-ID: <200802181001.m1IA1mh4018964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327AbYBRKC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dwmw2@infradead.org


The patch titled
     jffs2: fix sparse warnings in gc.c
has been added to the -mm tree.  Its filename is
     jffs2-fix-sparse-warnings-in-gcc.patch

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
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
