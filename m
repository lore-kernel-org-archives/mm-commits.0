From: akpm@linux-foundation.org
Subject: + lru_cache-use-correct-type-in-sizeof-for-allocation.patch added to -mm tree
Date: Thu, 07 Apr 2011 14:20:00 -0700
Message-ID: <201104072120.p37LK2qD000575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1DGVUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 17:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imirkin@alum.mit.edu, lars@linbit.com


The patch titled
     lru_cache: use correct type in sizeof for allocation
has been added to the -mm tree.  Its filename is
     lru_cache-use-correct-type-in-sizeof-for-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lru_cache: use correct type in sizeof for allocation
From: Ilia Mirkin <imirkin@alum.mit.edu>

This has no actual effect, since sizeof(struct hlist_head) ==
sizeof(struct hlist_head *), but it's still the wrong type to use.

The semantic match that finds this problem:
// <smpl>
@@
type T;
identifier x;
@@
T *x;
...
* x = kzalloc(... * sizeof(T*) * ..., ...);
// </smpl>

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Acked-by: Lars Ellenberg <lars@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation lib/lru_cache.c
--- a/lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation
+++ a/lib/lru_cache.c
@@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *
 	if (e_count > LC_MAX_ACTIVE)
 		return NULL;
 
-	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
+	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);
 	if (!slot)
 		goto out_fail;
 	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
_

Patches currently in -mm which might be from imirkin@alum.mit.edu are

linux-next.patch
lru_cache-use-correct-type-in-sizeof-for-allocation.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch

