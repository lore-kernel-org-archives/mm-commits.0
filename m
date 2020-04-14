From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 18:09:59 -0700
Message-ID: <20200414010959.LoTcVQvPX%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgDNBKB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 21:10:01 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterx@redhat.com, torvalds@linux-foundation.org


The patch titled
     Subject: mm, gup: return EINTR when gup is interrupted by fatal signals
has been added to the -mm tree.  Its filename is
     mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, gup: return EINTR when gup is interrupted by fatal signals

EINTR is the usual error code which other killable interfaces return. 
This is the case for the other fatal_signal_pending break out from the
same function.  Make the code consistent.

ERESTARTSYS is also quite confusing because the signal is fatal and so no
restart will happen before returning to the userspace.

Link: http://lkml.kernel.org/r/20200409071133.31734-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals
+++ a/mm/gup.c
@@ -1088,7 +1088,7 @@ retry:
 		 * potentially allocating memory.
 		 */
 		if (fatal_signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			ret = -EINTR;
 			goto out;
 		}
 		cond_resched();
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-gup-return-eintr-when-gup-is-interrupted-by-fatal-signals.patch
mm-clarify-__gfp_memalloc-usage.patch
