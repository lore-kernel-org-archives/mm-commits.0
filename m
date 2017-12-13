From: akpm@linux-foundation.org
Subject: + mm-slab-do-not-hash-pointers-when-debugging-slab-v2.patch added to -mm tree
Date: Wed, 13 Dec 2017 15:47:41 -0800
Message-ID: <5a31bc1d.isYJwtrl1/7Owp0t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMXrn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 18:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, me@tobin.cc, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-do-not-hash-pointers-when-debugging-slab-v2
has been added to the -mm tree.  Its filename is
     mm-slab-do-not-hash-pointers-when-debugging-slab-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-do-not-hash-pointers-when-debugging-slab-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-do-not-hash-pointers-when-debugging-slab-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm-slab-do-not-hash-pointers-when-debugging-slab-v2

  - Add Acked-by,
  - Remove printing of pointer to last user, which refers to code.

Link: http://lkml.kernel.org/r/1513179267-2509-1-git-send-email-geert+renesas@glider.be
Fixes: ad67b74d2469d9b8 ("printk: hash addresses printed with %p")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Tobin C . Harding" <me@tobin.cc>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-do-not-hash-pointers-when-debugging-slab-v2 mm/slab.c
--- a/mm/slab.c~mm-slab-do-not-hash-pointers-when-debugging-slab-v2
+++ a/mm/slab.c
@@ -1584,11 +1584,8 @@ static void print_objinfo(struct kmem_ca
 		       *dbg_redzone2(cachep, objp));
 	}
 
-	if (cachep->flags & SLAB_STORE_USER) {
-		pr_err("Last user: [<%px>](%pSR)\n",
-		       *dbg_userword(cachep, objp),
-		       *dbg_userword(cachep, objp));
-	}
+	if (cachep->flags & SLAB_STORE_USER)
+		pr_err("Last user: (%pSR)\n", *dbg_userword(cachep, objp));
 	realobj = (char *)objp + obj_offset(cachep);
 	size = cachep->object_size;
 	for (i = 0; i < size && lines; i += 16, lines--) {
_

Patches currently in -mm which might be from geert+renesas@glider.be are

mm-slab-do-not-hash-pointers-when-debugging-slab.patch
mm-slab-do-not-hash-pointers-when-debugging-slab-v2.patch

