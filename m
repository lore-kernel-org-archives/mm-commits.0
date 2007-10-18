From: akpm@linux-foundation.org
Subject: - drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:53 -0700
Message-ID: <200710180654.l9I6srQc030554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761302AbXJRHkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/consolemap.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/consolemap.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/consolemap.c | 22678 -> 22650 (-28 bytes)
 drivers/char/consolemap.o | 90113 -> 90029 (-84 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/consolemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/consolemap.c~drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/char/consolemap.c
@@ -494,12 +494,11 @@ int con_clear_unimap(struct vc_data *vc,
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	if (p && p->readonly) return -EIO;
 	if (!p || --p->refcount) {
-		q = kmalloc(sizeof(*p), GFP_KERNEL);
+		q = kzalloc(sizeof(*p), GFP_KERNEL);
 		if (!q) {
 			if (p) p->refcount++;
 			return -ENOMEM;
 		}
-		memset(q, 0, sizeof(*q));
 		q->refcount=1;
 		*vc->vc_uni_pagedir_loc = (unsigned long)q;
 	} else {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-cifs.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
