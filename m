From: akpm@linux-foundation.org
Subject: [patch 25/27] mm/slab.c: fix SLAB freelist randomization
 duplicate entries
Date: Tue, 10 Jan 2017 16:58:24 -0800
Message-ID: <58758330.raoyiAns0BtGzQqf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33616 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759843AbdAKA6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jsperbeck@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, thgarnie@google.com

From: John Sperbeck <jsperbeck@google.com>
Subject: mm/slab.c: fix SLAB freelist randomization duplicate entries

This patch fixes a bug in the freelist randomization code. When a high
random number is used, the freelist will contain duplicate entries. It
will result in different allocations sharing the same chunk.

It will result in odd behaviours and crashes. It should be uncommon
but it depends on the machines. We saw it happening more often on some
machines (every few hours of running tests).

Fixes: c7ce4f60ac19 ("mm: SLAB freelist randomization")
Link: http://lkml.kernel.org/r/20170103181908.143178-1-thgarnie@google.com
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~fix-slab-freelist-randomization-duplicate-entries mm/slab.c
--- a/mm/slab.c~fix-slab-freelist-randomization-duplicate-entries
+++ a/mm/slab.c
@@ -2457,7 +2457,6 @@ union freelist_init_state {
 		unsigned int pos;
 		unsigned int *list;
 		unsigned int count;
-		unsigned int rand;
 	};
 	struct rnd_state rnd_state;
 };
@@ -2483,8 +2482,7 @@ static bool freelist_state_initialize(un
 	} else {
 		state->list = cachep->random_seq;
 		state->count = count;
-		state->pos = 0;
-		state->rand = rand;
+		state->pos = rand % count;
 		ret = true;
 	}
 	return ret;
@@ -2493,7 +2491,9 @@ static bool freelist_state_initialize(un
 /* Get the next entry on the list and randomize it using a random shift */
 static freelist_idx_t next_random_slot(union freelist_init_state *state)
 {
-	return (state->list[state->pos++] + state->rand) % state->count;
+	if (state->pos >= state->count)
+		state->pos = 0;
+	return state->list[state->pos++];
 }
 
 /* Swap two freelist entries */
_
