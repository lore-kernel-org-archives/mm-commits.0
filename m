From: akpm@linux-foundation.org
Subject: - fix-linux-kdh-usage-in-userspace.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:29 -0800
Message-ID: <200712010021.lB10LTxb031767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798AbXLAAVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Fix <linux/kd.h> usage in userspace
has been removed from the -mm tree.  Its filename was
     fix-linux-kdh-usage-in-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix <linux/kd.h> usage in userspace
From: David Woodhouse <dwmw2@infradead.org>

For reasons unclear to me, glibc's <sys/kd.h> deliberately defeats the
attempt we make in <linux/kd.h> to include <linux/types.h>

For now, change the one instance of __u32 to 'unsigned int' instead
because it's breaking userspace. We should probably also remove our
inclusion of <linux/types.h>, since we don't use it -- but that's not a
change to make in -rc.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kd.h~fix-linux-kdh-usage-in-userspace include/linux/kd.h
--- a/include/linux/kd.h~fix-linux-kdh-usage-in-userspace
+++ a/include/linux/kd.h
@@ -126,7 +126,7 @@ struct kbdiacrs {
 #define KDSKBDIACR      0x4B4B  /* write kernel accent table */
 
 struct kbdiacruc {
-        __u32 diacr, base, result;
+	unsigned int diacr, base, result;
 };
 struct kbdiacrsuc {
         unsigned int kb_cnt;    /* number of entries in following array */
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-mtd.patch
eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
git-battery.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
a-few-corrections-to-include-linux-kbuild.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed-fix.patch
unexport-asm-elfh.patch
unexport-asm-pageh.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
