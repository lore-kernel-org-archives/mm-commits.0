From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 21/67] drivers/block/null_blk_main.c: fix
 uninitialized var warnings
Date: Mon, 03 Feb 2020 17:34:52 -0800
Message-ID: <20200204013452.zc3h7QOdS%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:56 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, linux-mm@kvack.org, mm-commits@vger.kernel.org, shli@fb.com, torvalds@linux-foundation.org

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
