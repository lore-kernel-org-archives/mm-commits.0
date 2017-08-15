From: akpm@linux-foundation.org
Subject: +
 mm-slubc-add-a-naive-detection-of-double-free-or-corruption.patch added to
 -mm tree
Date: Tue, 15 Aug 2017 15:53:57 -0700
Message-ID: <59937b85.gJy0zDXWw8QdtiEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdHOWx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 18:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.popov@linux.com, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, luto@kernel.org, mingo@kernel.org, nicolas.pitre@linaro.org, paulmck@linux.vnet.ibm.com, penberg@kernel.org, riel@redhat.com, rientjes@google.com, tj@kernel.org, tycho@docker.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: add a naive detection of double free or corruption
has been added to the -mm tree.  Its filename is
     mm-slubc-add-a-naive-detection-of-double-free-or-corruption.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-add-a-naive-detection-of-double-free-or-corruption.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-add-a-naive-detection-of-double-free-or-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Popov <alex.popov@linux.com>
Subject: mm/slub.c: add a naive detection of double free or corruption

Add an assertion similar to "fasttop" check in GNU C Library allocator as
a part of SLAB_FREELIST_HARDENED feature.  An object added to a singly
linked freelist should not point to itself.  That helps to detect some
double free errors (e.g.  CVE-2017-2636) without slub_debug and KASAN.

Link: http://lkml.kernel.org/r/1502468246-1262-1-git-send-email-alex.popov@linux.com
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul E McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tycho Andersen <tycho@docker.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/slub.c~mm-slubc-add-a-naive-detection-of-double-free-or-corruption mm/slub.c
--- a/mm/slub.c~mm-slubc-add-a-naive-detection-of-double-free-or-corruption
+++ a/mm/slub.c
@@ -290,6 +290,10 @@ static inline void set_freepointer(struc
 {
 	unsigned long freeptr_addr = (unsigned long)object + s->offset;
 
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	BUG_ON(object == fp); /* naive detection of double free or corruption */
+#endif
+
 	*(void **)freeptr_addr = freelist_ptr(s, fp, freeptr_addr);
 }
 
_

Patches currently in -mm which might be from alex.popov@linux.com are

mm-slubc-add-a-naive-detection-of-double-free-or-corruption.patch

