Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793599527;
	b=Dru8k0nFnV6Q1WRKc/nDaU1MdDQtIAxlCxhulFuJtAgS5xaVr67eYdo18EwgVXDZaaA9
	 h7GaFKKtvK0DZMHG/v8a/Zz9LDfsazq6QAg7Vpnr568mYoNwu/PzbOCRIPU5fH7CTiI6x
	 fBqJ0ca7Nxa8YE6xwf6rchb2mbBu517Fvuz1QMn80XOJFCg2vOR+WQ21YcvDFa7ljtatt
	 soWjkZI1D6THYHtQZQDBNeyh3fxWjGZmxJfaXeaHDRXZZzhyAR53w9FOknsLkl6c1hfQR
	 wM3H49RsgwplQ1Wi7Hd5rqUV1t8/padWV5A2VwRiXF7IdRUI3QDIQWjhk/ou2Awl5AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793599527;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/DN0PPCkv7CjtvFRWVaN2QaxjHjJkzLOCyEcAic/ztI=;
	b=QLG+IbQcUH+s5IZ1TZEWvNRh3KIJb+mPWkqaTrLU6SGEeCcs97HsxiqYi+WVnXz8L2k8
	 vXm5ZJ7DC2/0n/C8xJqtg50/TVQf/ytnFV/OSoDgcuODwP87LzRWVsk/a2YxC+R6vhTf0
	 coPWMydDKk/bsoim/gOzIjo2yk9G1e2c4R0yaHzWQPSx0GGEFzhlEmxHpgMGiq4OO9wDW
	 nRso2Oka2PnC6H24HAJpd395b58EwkGUClAEEV8zVTPUQvK+vg9rFvrvjA5f0//pRgziH
	 ymUAY6DnLvz9lzNeIDzvJFz1zGNej3zwm0bECgH65Na09YWV5FRvoX8Vm74+lNTsHzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=woWRVPnk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A58606A327
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 06:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=woWRVPnk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C631F00A02;
	Mon,  2 Nov 2026 06:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793599527;
	bh=/DN0PPCkv7CjtvFRWVaN2QaxjHjJkzLOCyEcAic/ztI=;
	h=Date:To:From:Subject;
	b=woWRVPnk/hcE8gBGjhax4RciIjirj1AQiZE2gGI3KzK5V29H6SEp9CQuDrhTldBlB
	 MyLDwEXsJWXdvXQ0BxFRejWc1z+UbApBsHbhFxEC8pe/b0JpCcRxxAkG2cxzdBHBHD
	 tSSoek2ZgqKX3Gi7Y/xj2TCi3Al5QVdFYdK+yIvI=
Date: Sun, 01 Nov 2026 22:05:26 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,richardycc@google.com,
	minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,josef@toxicpanda.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch added to mm-nonmm-unstable branch
Message-Id: <20261102060527.23C631F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: lz4/lz4hc: accept dictionaries of more than 64 KiB
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: zram: lz4/lz4hc: accept dictionaries of more than 64 KiB
Date: Fri, 30 Oct 2026 13:16:50 +0900

LZ4_loadDict() and LZ4_loadDictHC() only use the last 64KiB of a
dictionary and return how much they used, which the zram backends take for
an error.  Expect that instead.

Link: https://lore.kernel.org/f2ac22a731e507e90217a5e9cf29c987ec24e2b0.1793333729.git.senozhatsky@chromium.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 drivers/block/zram/backend_lz4.c   |    4 +++-
 drivers/block/zram/backend_lz4hc.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/backend_lz4.c~zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib
+++ a/drivers/block/zram/backend_lz4.c
@@ -4,6 +4,7 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
+#include <linux/sizes.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4.h"
@@ -39,7 +40,8 @@ static int lz4_setup_params(struct zcomp
 		return -ENOMEM;
 
 	ret = LZ4_loadDict(dict_stream, params->dict, params->dict_sz);
-	if (ret != params->dict_sz) {
+	/* Only the last 64 KiB of a dictionary are of use */
+	if (ret != min_t(size_t, params->dict_sz, SZ_64K)) {
 		vfree(dict_stream);
 		return -EINVAL;
 	}
--- a/drivers/block/zram/backend_lz4hc.c~zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -4,6 +4,7 @@
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
+#include <linux/sizes.h>
 #include <linux/vmalloc.h>
 
 #include "backend_lz4hc.h"
@@ -46,7 +47,8 @@ static int lz4hc_setup_params(struct zco
 
 	LZ4_resetStreamHC(dict_stream, params->level);
 	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
-	if (ret != params->dict_sz) {
+	/* Only the last 64 KiB of a dictionary are of use */
+	if (ret != min_t(size_t, params->dict_sz, SZ_64K)) {
 		vfree(dict_stream);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from josef@toxicpanda.com are

zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

