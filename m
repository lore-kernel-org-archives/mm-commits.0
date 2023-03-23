Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EE6C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 19:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCWTl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWTl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 15:41:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E2D22018
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 12:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFD04CE2323
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 19:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5691C433EF;
        Thu, 23 Mar 2023 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679600480;
        bh=jvT399OLr5i1kSg1qeSfOFR6vwCjxQh9EUOi9qJOIcI=;
        h=Date:To:From:Subject:From;
        b=2UkrVcXc4gi8rXP5LxbQd8+vk3FyUfHGv5TA1j9LCGjv1WiDhlnP2qKWD43//SP49
         ab6cHopUc2nUvc2zsJMfxspZI7dqx5rhdHpaWBztYx3AOPBZsaYf7YcZalBEVddHxB
         04VsevL8/53I2tJKbJR6tuJOG0EABDJzMCqPy2d0=
Date:   Thu, 23 Mar 2023 12:41:20 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, mingo@kernel.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        arnd@arndb.de, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] instrumentedh-fix-all-kernel-doc-format-warnings.patch removed from -mm tree
Message-Id: <20230323194120.D5691C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: instrumented.h: fix all kernel-doc format warnings
has been removed from the -mm tree.  Its filename was
     instrumentedh-fix-all-kernel-doc-format-warnings.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: instrumented.h: fix all kernel-doc format warnings
Date: Mon, 20 Mar 2023 17:59:13 -0700

Fix 26 kernel-doc notation warnings by converting the function
documentation to kernel-doc format.

Warning example:

instrumented.h:155: warning: Function parameter or member 'to' not described in 'instrument_copy_from_user_after'
instrumented.h:155: warning: Function parameter or member 'from' not described in 'instrument_copy_from_user_after'
instrumented.h:155: warning: Function parameter or member 'n' not described in 'instrument_copy_from_user_after'
instrumented.h:155: warning: Function parameter or member 'left' not described in 'instrument_copy_from_user_after'

Link: https://lkml.kernel.org/r/20230321005914.50783-1-paulmck@kernel.org
Fixes: 36e4d4dd4fc4 ("include/linux: Add instrumented.h infrastructure")
Fixes: 00047c2e6d7c ("instrumented.h: Introduce read-write instrumentation hooks")
Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of copy_from_user()")
Fixes: 888f84a6da4d ("x86: asm: instrument usercopy in get_user() and put_user()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/instrumented.h~instrumentedh-fix-all-kernel-doc-format-warnings
+++ a/include/linux/instrumented.h
@@ -15,12 +15,11 @@
 
 /**
  * instrument_read - instrument regular read access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument a regular read access. The instrumentation should be inserted
  * before the actual read happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_read(const volatile void *v, size_t size)
 {
@@ -30,12 +29,11 @@ static __always_inline void instrument_r
 
 /**
  * instrument_write - instrument regular write access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument a regular write access. The instrumentation should be inserted
  * before the actual write happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_write(const volatile void *v, size_t size)
 {
@@ -45,12 +43,11 @@ static __always_inline void instrument_w
 
 /**
  * instrument_read_write - instrument regular read-write access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument a regular write access. The instrumentation should be inserted
  * before the actual write happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_read_write(const volatile void *v, size_t size)
 {
@@ -60,12 +57,11 @@ static __always_inline void instrument_r
 
 /**
  * instrument_atomic_read - instrument atomic read access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument an atomic read access. The instrumentation should be inserted
  * before the actual read happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_atomic_read(const volatile void *v, size_t size)
 {
@@ -75,12 +71,11 @@ static __always_inline void instrument_a
 
 /**
  * instrument_atomic_write - instrument atomic write access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument an atomic write access. The instrumentation should be inserted
  * before the actual write happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_atomic_write(const volatile void *v, size_t size)
 {
@@ -90,12 +85,11 @@ static __always_inline void instrument_a
 
 /**
  * instrument_atomic_read_write - instrument atomic read-write access
+ * @v: address of access
+ * @size: size of access
  *
  * Instrument an atomic read-write access. The instrumentation should be
  * inserted before the actual write happens.
- *
- * @ptr address of access
- * @size size of access
  */
 static __always_inline void instrument_atomic_read_write(const volatile void *v, size_t size)
 {
@@ -105,13 +99,12 @@ static __always_inline void instrument_a
 
 /**
  * instrument_copy_to_user - instrument reads of copy_to_user
+ * @to: destination address
+ * @from: source address
+ * @n: number of bytes to copy
  *
  * Instrument reads from kernel memory, that are due to copy_to_user (and
  * variants). The instrumentation must be inserted before the accesses.
- *
- * @to destination address
- * @from source address
- * @n number of bytes to copy
  */
 static __always_inline void
 instrument_copy_to_user(void __user *to, const void *from, unsigned long n)
@@ -123,13 +116,12 @@ instrument_copy_to_user(void __user *to,
 
 /**
  * instrument_copy_from_user_before - add instrumentation before copy_from_user
+ * @to: destination address
+ * @from: source address
+ * @n: number of bytes to copy
  *
  * Instrument writes to kernel memory, that are due to copy_from_user (and
  * variants). The instrumentation should be inserted before the accesses.
- *
- * @to destination address
- * @from source address
- * @n number of bytes to copy
  */
 static __always_inline void
 instrument_copy_from_user_before(const void *to, const void __user *from, unsigned long n)
@@ -140,14 +132,13 @@ instrument_copy_from_user_before(const v
 
 /**
  * instrument_copy_from_user_after - add instrumentation after copy_from_user
+ * @to: destination address
+ * @from: source address
+ * @n: number of bytes to copy
+ * @left: number of bytes not copied (as returned by copy_from_user)
  *
  * Instrument writes to kernel memory, that are due to copy_from_user (and
  * variants). The instrumentation should be inserted after the accesses.
- *
- * @to destination address
- * @from source address
- * @n number of bytes to copy
- * @left number of bytes not copied (as returned by copy_from_user)
  */
 static __always_inline void
 instrument_copy_from_user_after(const void *to, const void __user *from,
@@ -158,12 +149,11 @@ instrument_copy_from_user_after(const vo
 
 /**
  * instrument_get_user() - add instrumentation to get_user()-like macros
+ * @to: destination variable, may not be address-taken
  *
  * get_user() and friends are fragile, so it may depend on the implementation
  * whether the instrumentation happens before or after the data is copied from
  * the userspace.
- *
- * @to destination variable, may not be address-taken
  */
 #define instrument_get_user(to)				\
 ({							\
@@ -175,14 +165,13 @@ instrument_copy_from_user_after(const vo
 
 /**
  * instrument_put_user() - add instrumentation to put_user()-like macros
+ * @from: source address
+ * @ptr: userspace pointer to copy to
+ * @size: number of bytes to copy
  *
  * put_user() and friends are fragile, so it may depend on the implementation
  * whether the instrumentation happens before or after the data is copied from
  * the userspace.
- *
- * @from source address
- * @ptr userspace pointer to copy to
- * @size number of bytes to copy
  */
 #define instrument_put_user(from, ptr, size)			\
 ({								\
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-mm-contig-fix-section-mismatch-warning-error.patch
ia64-salinfo-placate-defined-but-not-used-warning.patch

