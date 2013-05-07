From: akpm@linux-foundation.org
Subject: [merged] relay-use-macro-page_align-instead-of-fix_size.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:50 -0700
Message-ID: <20130507175050.7D92A5A4525@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:33045 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:51 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so86437yho.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, axboe@kernel.dk, edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: use macro PAGE_ALIGN instead of FIX_SIZE
has been removed from the -mm tree.  Its filename was
     relay-use-macro-page_align-instead-of-fix_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: relay: use macro PAGE_ALIGN instead of FIX_SIZE

Macro FIX_SIZE is same as PAGE_ALIGN at present, so use PAGE_ALIGN
instead.

Thanks Andrew found this.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/relay.c~relay-use-macro-page_align-instead-of-fix_size kernel/relay.c
--- a/kernel/relay.c~relay-use-macro-page_align-instead-of-fix_size
+++ a/kernel/relay.c
@@ -550,9 +550,6 @@ static int __cpuinit relay_hotcpu_callba
 	return NOTIFY_OK;
 }
 
-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
