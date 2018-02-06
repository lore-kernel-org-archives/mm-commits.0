From: akpm@linux-foundation.org
Subject: [patch 079/114] lib/ubsan.c: s/missaligned/misaligned/
Date: Tue, 06 Feb 2018 15:40:38 -0800
Message-ID: <20180206234038.o4WlHoDCB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/ubsan.c: s/missaligned/misaligned/

A vist from the spelling fairy.

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned
+++ a/lib/ubsan.c
@@ -281,7 +281,7 @@ static void handle_null_ptr_deref(struct
 	ubsan_epilogue(&flags);
 }
 
-static void handle_missaligned_access(struct type_mismatch_data *data,
+static void handle_misaligned_access(struct type_mismatch_data *data,
 				unsigned long ptr)
 {
 	unsigned long flags;
@@ -322,7 +322,7 @@ void __ubsan_handle_type_mismatch(struct
 	if (!ptr)
 		handle_null_ptr_deref(data);
 	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
-		handle_missaligned_access(data, ptr);
+		handle_misaligned_access(data, ptr);
 	else
 		handle_object_size_mismatch(data, ptr);
 }
_
