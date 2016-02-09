From: akpm@linux-foundation.org
Subject: + mm-backing-devc-fix-error-path-in-wb_init.patch added to -mm
 tree
Date: Tue, 09 Feb 2016 12:40:52 -0800
Message-ID: <56ba4ed4.jUGUtVGXuSvWOmKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbcBIUkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 15:40:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/backing-dev.c: fix error path in wb_init()
has been added to the -mm tree.  Its filename is
     mm-backing-devc-fix-error-path-in-wb_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-backing-devc-fix-error-path-in-wb_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-backing-devc-fix-error-path-in-wb_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/backing-dev.c: fix error path in wb_init()

We need to use post-decrement to get percpu_counter_destroy() called on
&wb->stat[0].  Moreover, the pre-decremebt would cause infinite
out-of-bounds accesses if the setup code failed at i==0.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/backing-dev.c~mm-backing-devc-fix-error-path-in-wb_init mm/backing-dev.c
--- a/mm/backing-dev.c~mm-backing-devc-fix-error-path-in-wb_init
+++ a/mm/backing-dev.c
@@ -328,7 +328,7 @@ static int wb_init(struct bdi_writeback
 	return 0;
 
 out_destroy_stat:
-	while (--i)
+	while (i--)
 		percpu_counter_destroy(&wb->stat[i]);
 	fprop_local_destroy_percpu(&wb->completions);
 out_put_cong:
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-backing-devc-fix-error-path-in-wb_init.patch

