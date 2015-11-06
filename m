From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:07:11 -0800
Message-ID: <563d086f.tFD4Un+XOyN1KtYQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbbKFUHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.klimov@linaro.org, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: remove unneeded initialization of object to NULL
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch

