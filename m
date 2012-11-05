From: akpm@linux-foundation.org
Subject: + mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:15:39 -0800
Message-ID: <20121105201540.0FD6720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60937 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2KEUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:15:42 -0500
Received: by mail-bk0-f74.google.com with SMTP id q16so396637bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:15:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takamori.yamaguchi@jp.sony.com, aaditya.kumar@ap.sony.com, stable@vger.kernel.org


The patch titled
     Subject: mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()
has been added to the -mm tree.  Its filename is
     mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Subject: mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()

In kswapd(), set current->reclaim_state to NULL before returning, as
current->reclaim_state holds reference to variable on kswapd()'s stack.

In rare cases, while returning from kswapd() during memory off lining,
__free_slab() can access dangling pointer of current->reclaim_state.

Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd
+++ a/mm/vmscan.c
@@ -3034,6 +3034,8 @@ static int kswapd(void *p)
 						&balanced_classzone_idx);
 		}
 	}
+
+	current->reclaim_state = NULL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from takamori.yamaguchi@jp.sony.com are

mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch

