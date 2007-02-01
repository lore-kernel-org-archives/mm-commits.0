From: akpm@osdl.org
Subject: + fix-access_ok-checks.patch added to -mm tree
Date: Thu, 01 Feb 2007 15:04:38 -0800
Message-ID: <200702012304.l11N4c6M025697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422837AbXBAXXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 18:23:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: fix access_ok() checks
has been added to the -mm tree.  Its filename is
     fix-access_ok-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: fix access_ok() checks
=46rom: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>

sys_io_submit() and compat_sys_io_submit() check for the number of requ=
ests
(nr) being positive, but the following access_ok() call uses nr * sizeo=
f(ptr)
which can overlow to a negative number.

Just make sure that nr * sizeof(ptr) is positive in the first place.

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Bharata B Rao <bharata@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Benjamin LaHaise <bcrl@linux.intel.com>
Cc: Jean Pierre Dion <jean-pierre.dion@bull.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c    |    2 +-
 fs/compat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~fix-access_ok-checks fs/aio.c
--- a/fs/aio.c~fix-access_ok-checks
+++ a/fs/aio.c
@@ -1630,7 +1630,7 @@ asmlinkage long sys_io_submit(aio_contex
 	long ret =3D 0;
 	int i;
=20
-	if (unlikely(nr < 0))
+	if (unlikely((nr*sizeof(*iocbpp)) < 0))
 		return -EINVAL;
=20
 	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
diff -puN fs/compat.c~fix-access_ok-checks fs/compat.c
--- a/fs/compat.c~fix-access_ok-checks
+++ a/fs/compat.c
@@ -651,7 +651,7 @@ compat_sys_io_submit(aio_context_t ctx_i
 	long ret =3D 0;
 	int i;
=20
-	if (unlikely(nr < 0))
+	if (unlikely((nr * sizeof(u32)) < 0))
 		return -EINVAL;
=20
 	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
