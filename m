Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B96BC61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjCCWt2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbjCCWt1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2F1125A0
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A73161952
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B6C433EF;
        Fri,  3 Mar 2023 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882752;
        bh=ilG/QToQAgxI7RXNEhgByX7AaUOI3jvHV9Cn0NGNhDU=;
        h=Date:To:From:Subject:From;
        b=r9Xo9VAc9o2WmeVLfisnGxMv2HDmG7rW5AFU4c8OY42PS3KkbZL0jg8C1+quIJcUR
         oiNn2gGaLy/QcVRI9pppJH8aw0GNavBsvQRkVaTsFyR+vlP/um8rYfv5i5o3fv7AJA
         As+fqV5nT/ucnptygPRbST6li5n8R4PEf0fUVyOA=
Date:   Fri, 03 Mar 2023 14:32:31 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch added to mm-unstable branch
Message-Id: <20230303223231.EC3B6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: this_cpu_cmpxchg: x86: switch this_cpu_cmpxchg to locked, add _local function
has been added to the -mm mm-unstable branch.  Its filename is
     this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch

This patch will later appear in the mm-unstable branch at
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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: this_cpu_cmpxchg: x86: switch this_cpu_cmpxchg to locked, add _local function
Date: Fri, 03 Mar 2023 16:58:46 -0300

Goal is to have vmstat_shepherd to transfer from per-CPU counters to
global counters remotely.  For this, an atomic this_cpu_cmpxchg is
necessary.

Following the kernel convention for cmpxchg/cmpxchg_local, change x86's
this_cpu_cmpxchg_ helpers to be atomic.  and add this_cpu_cmpxchg_local_
helpers which are not atomic.

Link: https://lkml.kernel.org/r/20230303195908.877083312@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/include/asm/percpu.h~this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function
+++ a/arch/x86/include/asm/percpu.h
@@ -197,11 +197,11 @@ do {									\
  * cmpxchg has no such implied lock semantics as a result it is much
  * more efficient for cpu local operations.
  */
-#define percpu_cmpxchg_op(size, qual, _var, _oval, _nval)		\
+#define percpu_cmpxchg_op(size, qual, _var, _oval, _nval, lockp)	\
 ({									\
 	__pcpu_type_##size pco_old__ = __pcpu_cast_##size(_oval);	\
 	__pcpu_type_##size pco_new__ = __pcpu_cast_##size(_nval);	\
-	asm qual (__pcpu_op2_##size("cmpxchg", "%[nval]",		\
+	asm qual (__pcpu_op2_##size(lockp "cmpxchg", "%[nval]",		\
 				    __percpu_arg([var]))		\
 		  : [oval] "+a" (pco_old__),				\
 		    [var] "+m" (_var)					\
@@ -279,16 +279,20 @@ do {									\
 #define raw_cpu_add_return_1(pcp, val)		percpu_add_return_op(1, , pcp, val)
 #define raw_cpu_add_return_2(pcp, val)		percpu_add_return_op(2, , pcp, val)
 #define raw_cpu_add_return_4(pcp, val)		percpu_add_return_op(4, , pcp, val)
-#define raw_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(1, , pcp, oval, nval)
-#define raw_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(2, , pcp, oval, nval)
-#define raw_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(4, , pcp, oval, nval)
+#define raw_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(1, , pcp, oval, nval, "")
+#define raw_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(2, , pcp, oval, nval, "")
+#define raw_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(4, , pcp, oval, nval, "")
 
 #define this_cpu_add_return_1(pcp, val)		percpu_add_return_op(1, volatile, pcp, val)
 #define this_cpu_add_return_2(pcp, val)		percpu_add_return_op(2, volatile, pcp, val)
 #define this_cpu_add_return_4(pcp, val)		percpu_add_return_op(4, volatile, pcp, val)
-#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(1, volatile, pcp, oval, nval)
-#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(2, volatile, pcp, oval, nval)
-#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(4, volatile, pcp, oval, nval)
+#define this_cpu_cmpxchg_local_1(pcp, oval, nval)	percpu_cmpxchg_op(1, volatile, pcp, oval, nval, "")
+#define this_cpu_cmpxchg_local_2(pcp, oval, nval)	percpu_cmpxchg_op(2, volatile, pcp, oval, nval, "")
+#define this_cpu_cmpxchg_local_4(pcp, oval, nval)	percpu_cmpxchg_op(4, volatile, pcp, oval, nval, "")
+
+#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(1, volatile, pcp, oval, nval, LOCK_PREFIX)
+#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(2, volatile, pcp, oval, nval, LOCK_PREFIX)
+#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(4, volatile, pcp, oval, nval, LOCK_PREFIX)
 
 #ifdef CONFIG_X86_CMPXCHG64
 #define percpu_cmpxchg8b_double(pcp1, pcp2, o1, o2, n1, n2)		\
@@ -319,16 +323,17 @@ do {									\
 #define raw_cpu_or_8(pcp, val)			percpu_to_op(8, , "or", (pcp), val)
 #define raw_cpu_add_return_8(pcp, val)		percpu_add_return_op(8, , pcp, val)
 #define raw_cpu_xchg_8(pcp, nval)		raw_percpu_xchg_op(pcp, nval)
-#define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(8, , pcp, oval, nval)
+#define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(8, , pcp, oval, nval, "")
 
-#define this_cpu_read_8(pcp)			percpu_from_op(8, volatile, "mov", pcp)
-#define this_cpu_write_8(pcp, val)		percpu_to_op(8, volatile, "mov", (pcp), val)
-#define this_cpu_add_8(pcp, val)		percpu_add_op(8, volatile, (pcp), val)
-#define this_cpu_and_8(pcp, val)		percpu_to_op(8, volatile, "and", (pcp), val)
-#define this_cpu_or_8(pcp, val)			percpu_to_op(8, volatile, "or", (pcp), val)
-#define this_cpu_add_return_8(pcp, val)		percpu_add_return_op(8, volatile, pcp, val)
-#define this_cpu_xchg_8(pcp, nval)		percpu_xchg_op(8, volatile, pcp, nval)
-#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(8, volatile, pcp, oval, nval)
+#define this_cpu_read_8(pcp)				percpu_from_op(8, volatile, "mov", pcp)
+#define this_cpu_write_8(pcp, val)			percpu_to_op(8, volatile, "mov", (pcp), val)
+#define this_cpu_add_8(pcp, val)			percpu_add_op(8, volatile, (pcp), val)
+#define this_cpu_and_8(pcp, val)			percpu_to_op(8, volatile, "and", (pcp), val)
+#define this_cpu_or_8(pcp, val)				percpu_to_op(8, volatile, "or", (pcp), val)
+#define this_cpu_add_return_8(pcp, val)			percpu_add_return_op(8, volatile, pcp, val)
+#define this_cpu_xchg_8(pcp, nval)			percpu_xchg_op(8, volatile, pcp, nval)
+#define this_cpu_cmpxchg_local_8(pcp, oval, nval)	percpu_cmpxchg_op(8, volatile, pcp, oval, nval, "")
+#define this_cpu_cmpxchg_8(pcp, oval, nval)		percpu_cmpxchg_op(8, volatile, pcp, oval, nval, LOCK_PREFIX)
 
 /*
  * Pretty complex macro to generate cmpxchg16 instruction.  The instruction
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

