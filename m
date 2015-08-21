From: akpm@linux-foundation.org
Subject: + test_kasan-make-kmalloc_oob_krealloc_less-more-correctly.patch
 added to -mm tree
Date: Fri, 21 Aug 2015 14:09:15 -0700
Message-ID: <55d7937b.rxqUDzL6Chjsdm52%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbHUVJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 17:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: make kmalloc_oob_krealloc_less more correctly
has been added to the -mm tree.  Its filename is
     test_kasan-make-kmalloc_oob_krealloc_less-more-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_kasan-make-kmalloc_oob_krealloc_less-more-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_kasan-make-kmalloc_oob_krealloc_less-more-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: lib/test_kasan.c: make kmalloc_oob_krealloc_less more correctly

In kmalloc_oob_krealloc_less, I think it is better to test
the size2 boundary.

If we do not call krealloc, the access of position size1 will still cause
out-of-bounds and access of position size2 does not.  After call krealloc,
the access of position size2 cause out-of-bounds.  So using size2 is more
correct.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kasan.c~test_kasan-make-kmalloc_oob_krealloc_less-more-correctly lib/test_kasan.c
--- a/lib/test_kasan.c~test_kasan-make-kmalloc_oob_krealloc_less-more-correctly
+++ a/lib/test_kasan.c
@@ -114,7 +114,7 @@ static noinline void __init kmalloc_oob_
 		kfree(ptr1);
 		return;
 	}
-	ptr2[size1] = 'x';
+	ptr2[size2] = 'x';
 	kfree(ptr2);
 }
 
_

Patches currently in -mm which might be from long.wanglong@huawei.com are

test_kasan-just-fix-a-typo.patch
test_kasan-make-kmalloc_oob_krealloc_less-more-correctly.patch

