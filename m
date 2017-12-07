From: akpm@linux-foundation.org
Subject: +
 ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch added to -mm tree
Date: Wed, 06 Dec 2017 17:27:25 -0800
Message-ID: <5a2898fd.56vTz9uR1YU+YNbS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdLGB10 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 20:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingtianhong@huawei.com, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2
has been added to the -mm tree.  Its filename is
     ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ding Tianhong <dingtianhong@huawei.com>
Subject: ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2

add braces around if block

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2 lib/ubsan.c
--- a/lib/ubsan.c~ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2
+++ a/lib/ubsan.c
@@ -321,10 +321,10 @@ void __ubsan_handle_type_mismatch(struct
 
 	if (!ptr)
 		handle_null_ptr_deref(data);
-	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
+	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment)) {
 		if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 			handle_missaligned_access(data, ptr);
-	else
+	} else
 		handle_object_size_mismatch(data, ptr);
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
_

Patches currently in -mm which might be from dingtianhong@huawei.com are

ubsan-dont-handle-misaligned-address-when-support-unaligned-access.patch
ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch

