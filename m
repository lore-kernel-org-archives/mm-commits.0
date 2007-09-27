From: akpm@linux-foundation.org
Subject: - git-block-ps3disk-fix.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:44:05 -0700
Message-ID: <200709270144.l8R1i5G3014016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXI0BvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block: ps3disk fix
has been removed from the -mm tree.  Its filename was
     git-block-ps3disk-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: git-block: ps3disk fix
=46rom: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The build fails with following error

CC drivers/block/ps3disk.o
drivers/block/ps3disk.c: In function =E2=80=98ps3disk_scatter_gather=E2=
=80=99:
drivers/block/ps3disk.c:115: error: =E2=80=98bio=E2=80=99 undeclared (f=
irst use in this
function)
drivers/block/ps3disk.c:115: error: (Each undeclared identifier is
reported only once
drivers/block/ps3disk.c:115: error: for each function it appears in.)
drivers/block/ps3disk.c:115: error: =E2=80=98j=E2=80=99 undeclared (fir=
st use in this
function)
drivers/block/ps3disk.c:116: error: implicit declaration of function
=E2=80=98bio_kunmap_bvec=E2=80=99
make[2]: *** [drivers/block/ps3disk.o] Error 1
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

The function bio_kunmap_bvec is missing.I tried checking the git-block.=
patch
as well as the linux/kernel/git/axboe/linux-2.6-block.git and did not
find this function.

Previously this function was replaced by __bio_kunmap_atomic();
This patch does not solves the implicit "declaration of function
=E2=80=98bio_kunmap_bvec=E2=80=99"

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ps3disk.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/ps3disk.c~git-block-ps3disk-fix drivers/block/p=
s3disk.c
--- a/drivers/block/ps3disk.c~git-block-ps3disk-fix
+++ a/drivers/block/ps3disk.c
@@ -112,7 +112,7 @@ static void ps3disk_scatter_gather(struc
 		else
 			memcpy(buf, dev->bounce_buf+offset, size);
 		offset +=3D size;
-		flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
+		flush_kernel_dcache_page(bio_iovec_idx(iter.bio, iter.i)->bv_page);
 		bio_kunmap_bvec(bvec, flags);
 		i++;
 	}
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.co=
m are

git-net.patch
git-nfsd.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patc=
h
use-extended-crashkernel-command-line-on-ia64-fix.patch
