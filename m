Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECB0C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiFFU1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiFFU1d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7A056760
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6091D6155C
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42E2C385A9;
        Mon,  6 Jun 2022 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654547183;
        bh=dyBCxDZmirgaKgougssJsPQHsp/Z4SWaYxQFZhUnEVU=;
        h=Date:To:From:Subject:From;
        b=vEeH5EySI8mUodRdXyoxfWJOTwYVe7ggEu2QGaFmS1CZUn2PNB3Xy8dBrOME6Vguo
         LXtT3EfX6ArztDEFYeLKx5r+R1khJIX0rLgweJmubHsEVEyz2e7nCYmuwb80D1kZog
         VCy+Gllcq10bdQnea+pqDw5AzlALCqlHrnhDQoKw=
Date:   Mon, 06 Jun 2022 13:26:22 -0700
To:     mm-commits@vger.kernel.org, toke@redhat.com, paulmck@kernel.org,
        lkp@intel.com, arnd@arndb.de, luc.vanoostenryck@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-fix-sparse-warnings-with-cmpxchg-xchg.patch added to mm-nonmm-unstable branch
Message-Id: <20220606202623.A42E2C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix sparse warnings with cmpxchg() & xchg()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-fix-sparse-warnings-with-cmpxchg-xchg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-fix-sparse-warnings-with-cmpxchg-xchg.patch

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
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: ia64: fix sparse warnings with cmpxchg() & xchg()
Date: Sun, 5 Jun 2022 18:07:38 +0200

On IA64, new sparse's warnings where issued after fixing some __rcu
annotations in kernel/bpf/.

These new warnings are false positives and appear on IA64 because on this
architecture, the macros for cmpxchg() and xchg() make casts that ignore
sparse annotations.

This patch contains the minimal patch to fix this issue: adding a missing
cast and some missing '__force'.

Link: https://lore.kernel.org/r/20220601120013.bq5a3ynbkc3hngm5@mail
Link: https://lkml.kernel.org/r/20220605160738.79736-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/uapi/asm/cmpxchg.h |   28 ++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/arch/ia64/include/uapi/asm/cmpxchg.h~ia64-fix-sparse-warnings-with-cmpxchg-xchg
+++ a/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -33,24 +33,24 @@ extern void ia64_xchg_called_with_bad_po
 									\
 	switch (size) {							\
 	case 1:								\
-		__xchg_result = ia64_xchg1((__u8 *)ptr, x);		\
+		__xchg_result = ia64_xchg1((__u8 __force *)ptr, x);	\
 		break;							\
 									\
 	case 2:								\
-		__xchg_result = ia64_xchg2((__u16 *)ptr, x);		\
+		__xchg_result = ia64_xchg2((__u16 __force *)ptr, x);	\
 		break;							\
 									\
 	case 4:								\
-		__xchg_result = ia64_xchg4((__u32 *)ptr, x);		\
+		__xchg_result = ia64_xchg4((__u32 __force *)ptr, x);	\
 		break;							\
 									\
 	case 8:								\
-		__xchg_result = ia64_xchg8((__u64 *)ptr, x);		\
+		__xchg_result = ia64_xchg8((__u64 __force *)ptr, x);	\
 		break;							\
 	default:							\
 		ia64_xchg_called_with_bad_pointer();			\
 	}								\
-	__xchg_result;							\
+	(__typeof__ (*(ptr)) __force) __xchg_result;			\
 })
 
 #ifndef __KERNEL__
@@ -76,42 +76,42 @@ extern long ia64_cmpxchg_called_with_bad
 									\
 	switch (size) {							\
 	case 1:								\
-		_o_ = (__u8) (long) (old);				\
+		_o_ = (__u8) (long __force) (old);			\
 		break;							\
 	case 2:								\
-		_o_ = (__u16) (long) (old);				\
+		_o_ = (__u16) (long __force) (old);			\
 		break;							\
 	case 4:								\
-		_o_ = (__u32) (long) (old);				\
+		_o_ = (__u32) (long __force) (old);			\
 		break;							\
 	case 8:								\
-		_o_ = (__u64) (long) (old);				\
+		_o_ = (__u64) (long __force) (old);			\
 		break;							\
 	default:							\
 		break;							\
 	}								\
 	switch (size) {							\
 	case 1:								\
-		_r_ = ia64_cmpxchg1_##sem((__u8 *) ptr, new, _o_);	\
+		_r_ = ia64_cmpxchg1_##sem((__u8 __force *) ptr, new, _o_);	\
 		break;							\
 									\
 	case 2:								\
-		_r_ = ia64_cmpxchg2_##sem((__u16 *) ptr, new, _o_);	\
+		_r_ = ia64_cmpxchg2_##sem((__u16 __force *) ptr, new, _o_);	\
 		break;							\
 									\
 	case 4:								\
-		_r_ = ia64_cmpxchg4_##sem((__u32 *) ptr, new, _o_);	\
+		_r_ = ia64_cmpxchg4_##sem((__u32 __force *) ptr, new, _o_);	\
 		break;							\
 									\
 	case 8:								\
-		_r_ = ia64_cmpxchg8_##sem((__u64 *) ptr, new, _o_);	\
+		_r_ = ia64_cmpxchg8_##sem((__u64 __force *) ptr, new, _o_);	\
 		break;							\
 									\
 	default:							\
 		_r_ = ia64_cmpxchg_called_with_bad_pointer();		\
 		break;							\
 	}								\
-	(__typeof__(old)) _r_;						\
+	(__typeof__(old) __force) _r_;					\
 })
 
 #define cmpxchg_acq(ptr, o, n)	\
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are

ia64-fix-sparse-warnings-with-cmpxchg-xchg.patch

