From: akpm@linux-foundation.org
Subject: [patch 4/4] mm/slub.c: fix random_seq offset destruction
Date: Wed, 08 Feb 2017 14:30:59 -0800
Message-ID: <589b9c23.fZ9kkQx7erWrcNEk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdBHWbF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sean@erifax.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, thgarnie@google.com, userwithuid@gmail.com

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
