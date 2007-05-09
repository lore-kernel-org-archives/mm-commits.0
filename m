From: akpm@linux-foundation.org
Subject: - fix-access_ok-checks.patch removed from -mm tree
Date: Wed, 09 May 2007 03:05:01 -0700
Message-ID: <200705091005.l49A5124020809@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbXEIKHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, bcrl@linux.intel.com, bharata@in.ibm.com, hch@infradead.org, jean-pierre.dion@bull.net, oleg@tv-sign.ru, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: fix access_ok() checks
has been removed from the -mm tree.  Its filename was
     fix-access_ok-checks.patch

This patch was dropped because it is obsolete

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

origin.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
