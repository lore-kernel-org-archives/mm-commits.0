From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 06/15] mm, gup: return EINTR when gup is
 interrupted by fatal signals
Date: Mon, 20 Apr 2020 18:13:55 -0700
Message-ID: <20200421011355.0xysrApFW%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgDUBN5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:13:57 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hdanton@sina.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, peterx@redhat.com, torvalds@linux-foundation.org

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
