Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E2EC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352738AbiA2VlL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46126 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353209AbiA2VlJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E1460C41
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E5FC340E5;
        Sat, 29 Jan 2022 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492468;
        bh=f5jLvhnm9yNe/zMKjo8gyaqBIg5K7lhZuhAKD/Z+CqU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EKzEAR4BDItLruU6+w879CFKg8wHf66LWENbcVLzLq5yEUi4266RlpskOSok8xG+9
         mzquP6zszaGqqBmS1MNRsQFI87duaadZRTVI2BCNpQRuW+nsrv0T3zoUWSmHIVHDm8
         NN3gny8daNBKO1oDNBGVWvJXLS391ND4xMZUpjsU=
Date:   Sat, 29 Jan 2022 13:41:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de, hch@lst.de,
        linux-mm@kvack.org, maorg@nvidia.com, mm-commits@vger.kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 06/12] tools/testing/scatterlist: add missing
 defines
Message-ID: <20220129214107.iAiu2I6CA%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Maor Gottlieb <maorg@nvidia.com>
Subject: tools/testing/scatterlist: add missing defines

The cited commits replaced preemptible with pagefault_disabled and
flush_kernel_dcache_page with flush_dcache_page respectively, hence need
to update the corresponding defines in the test.

scatterlist.c: In function =E2=80=98sg_miter_stop=E2=80=99:
scatterlist.c:919:4: warning: implicit declaration of function =E2=80=98flu=
sh_dcache_page=E2=80=99 [-Wimplicit-function-declaration]
    flush_dcache_page(miter->page);
    ^~~~~~~~~~~~~~~~~
In file included from ./linux/scatterlist.h:8:0,
                 from scatterlist.c:9:
scatterlist.c:922:18: warning: implicit declaration of function =E2=80=98pa=
gefault_disabled=E2=80=99 [-Wimplicit-function-declaration]
    WARN_ON_ONCE(!pagefault_disabled());
                  ^
./linux/mm.h:23:25: note: in definition of macro =E2=80=98WARN_ON_ONCE=E2=
=80=99
  int __ret_warn_on =3D !!(condition);                      \
                         ^~~~~~~~~

Link: https://lkml.kernel.org/r/20220118082105.1737320-1-maorg@nvidia.com
Fixes: 723aca208516 ("mm/scatterlist: replace the !preemptible warning in s=
g_miter_stop()")
Fixes: 0e84f5dbf8d6 ("scatterlist: replace flush_kernel_dcache_page with fl=
ush_dcache_page")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/scatterlist/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/scatterlist/linux/mm.h~tools-testing-scatterlist-add-mi=
ssing-defines
+++ a/tools/testing/scatterlist/linux/mm.h
@@ -74,7 +74,7 @@ static inline unsigned long page_to_phys
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
 	      x, y)
=20
-#define preemptible() (1)
+#define pagefault_disabled() (0)
=20
 static inline void *kmap(struct page *page)
 {
@@ -127,6 +127,7 @@ kmalloc_array(unsigned int n, unsigned i
 #define kmemleak_free(a)
=20
 #define PageSlab(p) (0)
+#define flush_dcache_page(p)
=20
 #define MAX_ERRNO	4095
=20
_
