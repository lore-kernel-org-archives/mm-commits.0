From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch added to -mm tree
Date: Fri, 11 Sep 2015 15:49:42 -0700
Message-ID: <55f35a86.zU9L4kJGc8Nl6bYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbbIKWtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.klimov@linaro.org, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: remove unneeded initialization of object to NULL
has been added to the -mm tree.  Its filename is
     mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Klimov <alexey.klimov@linaro.org>
Subject: mm/kmemleak.c: remove unneeded initialization of object to NULL

Few lines below object is reinitialized by lookup_object() so we don't
need to init it by NULL in the beginning of find_and_get_object().

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleak-remove-unneeded-initialization-of-object-to-null mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-remove-unneeded-initialization-of-object-to-null
+++ a/mm/kmemleak.c
@@ -479,7 +479,7 @@ static void put_object(struct kmemleak_o
 static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
 {
 	unsigned long flags;
-	struct kmemleak_object *object = NULL;
+	struct kmemleak_object *object;
 
 	rcu_read_lock();
 	read_lock_irqsave(&kmemleak_lock, flags);
_

Patches currently in -mm which might be from alexey.klimov@linaro.org are

mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch

