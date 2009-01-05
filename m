From: akpm@linux-foundation.org
Subject: - fs-namespacec-drop-code-after-return.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:13 -0800
Message-ID: <200901050641.n056fDEZ005273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbZAEGl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, hch@lst.de, richard.genoud@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/namespace.c: drop code after return
has been removed from the -mm tree.  Its filename was
     fs-namespacec-drop-code-after-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/namespace.c: drop code after return
From: Julia Lawall <julia@diku.dk>

The extra semicolon serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~fs-namespacec-drop-code-after-return fs/namespace.c
--- a/fs/namespace.c~fs-namespacec-drop-code-after-return
+++ a/fs/namespace.c
@@ -1990,7 +1990,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	if (!new_ns->root) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return ERR_PTR(-ENOMEM);;
+		return ERR_PTR(-ENOMEM);
 	}
 	spin_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch
drivers-scsi-move-a-dereference-below-a-null-test.patch
drivers-message-fusion-move-a-dereference-below-a-null-test.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
drivers-rtc-correct-an-error-test.patch

