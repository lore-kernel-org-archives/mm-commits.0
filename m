From: akpm@linux-foundation.org
Subject: + relay-use-macro-page_align-instead-of-fix_size.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:28:59 -0700
Message-ID: <20130321192859.749615A421E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40450 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3CUT3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:29:01 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so5538qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:29:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, axboe@kernel.dk, edumazet@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: relay: use macro PAGE_ALIGN instead of FIX_SIZE
has been added to the -mm tree.  Its filename is
     relay-use-macro-page_align-instead-of-fix_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
