From: akpm@linux-foundation.org
Subject: + vt-bitlock-fix.patch added to -mm tree
Date: Tue, 20 Nov 2007 00:12:17 -0800
Message-ID: <200711200812.lAK8CHdV026597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbXKTIM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 03:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, adaplas@pol.net


The patch titled
     vt: bitlock fix
has been added to the -mm tree.  Its filename is
     vt-bitlock-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch
