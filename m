From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:45 -0800
Message-ID: <20200204184045.6bMkgdsGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgBDSkq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, mm-commits@vger.kernel.org, shli@fb.com


The patch titled
     Subject: drivers/block/null_blk_main.c: fix uninitialized var warnings
has been removed from the -mm tree.  Its filename was
     drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/null_blk_main.c: fix uninitialized var warnings

With gcc-7.2, many instances of

drivers/block/null_blk_main.c: In function =E2=80=98nullb_device_zone_nr_co=
nv_store=E2=80=99:
drivers/block/null_blk_main.c:291:12: warning: =E2=80=98new_value=E2=80=99 =
may be used uninitialized in this function [-Wmaybe-uninitialized]
  dev->NAME =3D new_value;      \
            ^
drivers/block/null_blk_main.c:279:7: note: =E2=80=98new_value=E2=80=99 was =
declared here
  TYPE new_value;       \
       ^

Presumably notabug, so use uninitialized_var() to suppress them.

Cc: Shaohua Li <shli@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/null_blk_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/null_blk_main.c~drivers-block-null_blk_mainc-fix-uninit=
ialized-var-warnings
+++ a/drivers/block/null_blk_main.c
@@ -276,7 +276,7 @@ nullb_device_##NAME##_store(struct confi
 {									\
 	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) =3D APPLY;\
 	struct nullb_device *dev =3D to_nullb_device(item);		\
-	TYPE new_value;							\
+	TYPE uninitialized_var(new_value);				\
 	int ret;							\
 									\
 	ret =3D nullb_device_##TYPE##_attr_store(&new_value, page, count);\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
