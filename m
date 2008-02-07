From: akpm@linux-foundation.org
Subject: - vt-bitlock-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:49 -0800
Message-ID: <200802070022.m170MUeT006425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935036AbYBGAoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     vt: bitlock fix
has been removed from the -mm tree.  Its filename was
     vt-bitlock-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: bitlock fix
From: Nick Piggin <npiggin@suse.de>

vt is missing a memory barrier to close the critical section.  Use a real
spinlock for this.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/vt.c~vt-bitlock-fix drivers/char/vt.c
--- a/drivers/char/vt.c~vt-bitlock-fix
+++ a/drivers/char/vt.c
@@ -2400,13 +2400,15 @@ static void vt_console_print(struct cons
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	unsigned char c;
-	static unsigned long printing;
+	static DEFINE_SPINLOCK(printing_lock);
 	const ushort *start;
 	ushort cnt = 0;
 	ushort myx;
 
 	/* console busy or not yet initialized */
-	if (!printable || test_and_set_bit(0, &printing))
+	if (!printable)
+		return;
+	if (!spin_trylock(&printing_lock))
 		return;
 
 	if (kmsg_redirect && vc_cons_allocated(kmsg_redirect - 1))
@@ -2481,7 +2483,7 @@ static void vt_console_print(struct cons
 	notify_update(vc);
 
 quit:
-	clear_bit(0, &printing);
+	spin_unlock(&printing_lock);
 }
 
 static struct tty_driver *vt_console_device(struct console *c, int *index)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
