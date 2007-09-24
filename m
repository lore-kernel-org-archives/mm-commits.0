From: akpm@linux-foundation.org
Subject: + git-block-ps3disk-fix.patch added to -mm tree
Date: Mon, 24 Sep 2007 12:48:47 -0700
Message-ID: <200709241948.l8OJmmw1014578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbXIXTyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 15:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, jens.axboe@oracle.com


The patch titled
     git-block: ps3disk fix
has been added to the -mm tree.  Its filename is
     git-block-ps3disk-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
git-net-fix-macec.patch
git-block-ps3disk-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patc=
h
use-extended-crashkernel-command-line-on-ia64-fix.patch
on_each_cpu-debugging.patch
