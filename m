From: akpm@linux-foundation.org
Subject: - remove-bdput-from-do_open-in-fs-block_devc-fix.patch removed from -mm tree
Date: Wed, 22 Aug 2007 13:24:49 -0700
Message-ID: <200708222024.l7MKOnKS002430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763171AbXHVUZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 16:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, rafalbilski@interia.pl, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     remove-bdput-from-do_open-in-fs-block_devc-fix
has been removed from the -mm tree.  Its filename was
     remove-bdput-from-do_open-in-fs-block_devc-fix.patch

This patch was dropped because it was folded into remove-bdput-from-do_=
open-in-fs-block_devc.patch

------------------------------------------------------
Subject: remove-bdput-from-do_open-in-fs-block_devc-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

=46ix up blkdev_open() error-path refcounting.

Cc: Rafa=B3 Bilski <rafalbilski@interia.pl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc-fix=
 fs/block_dev.c
--- a/fs/block_dev.c~remove-bdput-from-do_open-in-fs-block_devc-fix
+++ a/fs/block_dev.c
@@ -1246,8 +1246,10 @@ static int blkdev_open(struct inode * in
 		return -ENOMEM;
=20
 	res =3D do_open(bdev, filp, 0);
-	if (res)
+	if (res) {
+		bdput(bdev);
 		return res;
+	}
=20
 	if (!(filp->f_flags & O_EXCL) )
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.pa=
tch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
selectionh-add-tty_struct-forward-declaration.patch
newport_con-warning-fix.patch
remove-bdput-from-do_open-in-fs-block_devc.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
