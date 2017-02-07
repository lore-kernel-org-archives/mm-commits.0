From: akpm@linux-foundation.org
Subject: + mm-slub-fix-random_seq-offset-destruction.patch added to -mm
 tree
Date: Tue, 07 Feb 2017 13:49:41 -0800
Message-ID: <589a40f5.e937WyQVuaoDmWaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbdBGVtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 16:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean@erifax.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, thgarnie@google.com, userwithuid@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: fix random_seq offset destruction
has been added to the -mm tree.  Its filename is
     mm-slub-fix-random_seq-offset-destruction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-random_seq-offset-destruction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-random_seq-offset-destruction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sean Rees <sean@erifax.org>
Subject: mm/slub.c: fix random_seq offset destruction

210e7a43fa90 ("mm: SLUB freelist randomization") broke USB hub
initialisation as described in
https://bugzilla.kernel.org/show_bug.cgi?id=177551.

Bail out early from init_cache_random_seq if s->random_seq is already
initialised.  This prevents destroying the previously computed random_seq
offsets later in the function.

If the offsets are destroyed, then shuffle_freelist will truncate
page->freelist to just the first object (orphaning the rest).

Fixes: 210e7a43fa90 ("mm: SLUB freelist randomization")
Link: http://lkml.kernel.org/r/20170207140707.20824-1-sean@erifax.org
Signed-off-by: Sean Rees <sean@erifax.org>
Reported-by: <userwithuid@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slub.c~mm-slub-fix-random_seq-offset-destruction mm/slub.c
--- a/mm/slub.c~mm-slub-fix-random_seq-offset-destruction
+++ a/mm/slub.c
@@ -1422,6 +1422,10 @@ static int init_cache_random_seq(struct
 	int err;
 	unsigned long i, count = oo_objects(s->oo);
 
+	/* Bailout if already initialised */
+	if (s->random_seq)
+		return 0;
+
 	err = cache_random_seq_create(s, count, GFP_KERNEL);
 	if (err) {
 		pr_err("SLUB: Unable to initialize free list for %s\n",
_

Patches currently in -mm which might be from sean@erifax.org are

mm-slub-fix-random_seq-offset-destruction.patch

