From: akpm@osdl.org
Subject: + fix-aioh-includes.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:05:20 -0800
Message-ID: <200701240605.l0O65K0q010034@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXAXGFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, bcrl@kvack.org, drepper@redhat.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: fix aio.h includes
has been added to the -mm tree.  Its filename is
     fix-aioh-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: aio: fix aio.h includes
=46rom: Sbastien Dugu <sebastien.dugue@bull.net>

=46ix the double inclusion of linux/uio.h in linux/aio.h

Signed-off-by: S=E9bastien Dugu=E9 <sebastien.dugue@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/aio.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/aio.h~fix-aioh-includes include/linux/aio.h
--- a/include/linux/aio.h~fix-aioh-includes
+++ a/include/linux/aio.h
@@ -7,7 +7,6 @@
 #include <linux/uio.h>
=20
 #include <asm/atomic.h>
-#include <linux/uio.h>
=20
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
_

Patches currently in -mm which might be from sebastien.dugue@bull.net a=
re

rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
add-listio-syscall-support.patch
