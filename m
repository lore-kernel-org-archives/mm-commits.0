Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6513DC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiILE5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiILE44 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FAD286C3
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E6760EF7
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2395C433D6;
        Mon, 12 Sep 2022 04:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958603;
        bh=sI32LaUligPVDGLiu+bIKkJ+agXYZDcXjp7l+IYNL64=;
        h=Date:To:From:Subject:From;
        b=KKCwD2IOIbzEGI+FD6soFuzc5YQ90AQNBdQmmwgBGW0uKT0EN+b48Jc8cqkvyDwka
         an9ZiT5lpGxtnnnabA7JOsM7tvWD3rAuyzqy5r3ijtjklDFoLd8V6z3xT9QHLpZDaf
         9p/aWnUZknRzCuFr+30BCxk5vRQ7kFeAfr32B+m0=
Date:   Sun, 11 Sep 2022 21:56:43 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch removed from -mm tree
Message-Id: <20220912045643.D2395C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bitops: use try_cmpxchg in set_mask_bits and bit_clear_unless
has been removed from the -mm tree.  Its filename was
     bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: bitops: use try_cmpxchg in set_mask_bits and bit_clear_unless
Date: Mon, 22 Aug 2022 16:38:51 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
set_mask_bits and bit_clear_unless.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails, enabling further code simplifications.

Link: https://lkml.kernel.org/r/20220822143851.3290-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/bitops.h~bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless
+++ a/include/linux/bitops.h
@@ -328,10 +328,10 @@ static __always_inline void __assign_bit
 	const typeof(*(ptr)) mask__ = (mask), bits__ = (bits);	\
 	typeof(*(ptr)) old__, new__;				\
 								\
+	old__ = READ_ONCE(*(ptr));				\
 	do {							\
-		old__ = READ_ONCE(*(ptr));			\
 		new__ = (old__ & ~mask__) | bits__;		\
-	} while (cmpxchg(ptr, old__, new__) != old__);		\
+	} while (!try_cmpxchg(ptr, &old__, new__));		\
 								\
 	old__;							\
 })
@@ -343,11 +343,12 @@ static __always_inline void __assign_bit
 	const typeof(*(ptr)) clear__ = (clear), test__ = (test);\
 	typeof(*(ptr)) old__, new__;				\
 								\
+	old__ = READ_ONCE(*(ptr));				\
 	do {							\
-		old__ = READ_ONCE(*(ptr));			\
+		if (old__ & test__)				\
+			break;					\
 		new__ = old__ & ~clear__;			\
-	} while (!(old__ & test__) &&				\
-		 cmpxchg(ptr, old__, new__) != old__);		\
+	} while (!try_cmpxchg(ptr, &old__, new__));		\
 								\
 	!(old__ & test__);					\
 })
_

Patches currently in -mm which might be from ubizjak@gmail.com are


