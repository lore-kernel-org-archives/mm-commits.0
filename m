Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDD2C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 20:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiHVUq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHVUq6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 16:46:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F0747B8B
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 13:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCFCB612E9
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA67C433C1;
        Mon, 22 Aug 2022 20:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661201216;
        bh=Ro7wXcYJeTRcIq8aJWywbsKARjKURsQYOzhHZUegv24=;
        h=Date:To:From:Subject:From;
        b=mBKVa8ntD9u69bR5vg2MZ+1IIQOg4b0qB7HqC3eeJNz0IZj36SN5eSNqcIPaaDKfq
         HCpQK6I9ngtjyNj9KjOd1JkauqJ6U/Y2uO93YuZvzNt1BdrHwc5L2C+oMlLqQKbnpd
         vuXhYxFBw1QaQOdkASY6w2zSfnDseASlfHmLF2Pg=
Date:   Mon, 22 Aug 2022 13:46:55 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch added to mm-nonmm-unstable branch
Message-Id: <20220822204656.2BA67C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: use try_cmpxchg in set_mask_bits and bit_clear_unless
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -327,10 +327,10 @@ static __always_inline void __assign_bit
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
@@ -342,11 +342,12 @@ static __always_inline void __assign_bit
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

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch
aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch
iversion-use-atomic64_try_cmpxchg.patch
bitops-use-try_cmpxchg-in-set_mask_bits-and-bit_clear_unless.patch

