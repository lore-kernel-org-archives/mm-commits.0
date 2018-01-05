From: akpm@linux-foundation.org
Subject: [folded-merged]
 ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch removed from -mm tree
Date: Thu, 04 Jan 2018 16:12:30 -0800
Message-ID: <5a4ec2ee./t9Zf595ScHWVGVD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEAMc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:12:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingtianhong@huawei.com, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2
has been removed from the -mm tree.  Its filename was
     ubsan-dont-handle-misaligned-address-when-support-unaligned-access-v2.patch

This patch was dropped because it was folded into ubsan-dont-handle-misaligned-address-when-support-unaligned-access.patch

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

