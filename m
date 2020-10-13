Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209F6C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 18:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB9320E65
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 18:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602613234;
	bh=d4RLZBT1YqCJ9JFtkwGM86jQH2jYS6Q7HTlowTPgmvw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Jq9Qlkq32IqLY/gE8b6HZRSoEgMApSfwOQwU75ECTVtyEqJr5diRcLvN/gBoVM+tM
	 51MQhWJ/N+iI8OsFRNeEA85NkkxvrroLqq9h/7hXrTJZ6fQQha7oHCBRHFfQJo/am/
	 mrNz7RAimLXIr8/ObjQlZWRmyUh3kHNl7mJFk/tg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgJMSUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 14:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgJMSUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 14:20:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C940208D5;
        Tue, 13 Oct 2020 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602613232;
        bh=d4RLZBT1YqCJ9JFtkwGM86jQH2jYS6Q7HTlowTPgmvw=;
        h=Date:From:To:Subject:From;
        b=zQtIX40zwjl4072qXHVchL1PUwdz6/8kZg5TR1lNxrvTr6AlJG0YiFYsUQ79kc02p
         3Mjkrzc1wDDVcek9NORAXR6l5XfEkonyv1oegAExYRLMhoz2p+YeJGWlhVuZymfQgW
         Vo1ecBtf9vu6lZ0A0usamo4yzWV/LoBPesMKeIyc=
Date:   Tue, 13 Oct 2020 11:20:31 -0700
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, alinde@google.com, andreyknvl@google.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net, dvyukov@google.com,
        elver@google.com, glider@google.com, hch@lst.de, hpa@zytor.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, viro@zeniv.linux.org.uk
Subject:  [wrecked]
 x86-add-failure-injection-to-get-put-clear_user.patch removed from -mm tree
Message-ID: <20201013182031.poYlHG6fX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: add failure injection to get/put/clear_user
has been removed from the -mm tree.  Its filename was
     x86-add-failure-injection-to-get-put-clear_user.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Albert van der Linde <alinde@google.com>
Subject: x86: add failure injection to get/put/clear_user

To test fault-tolerance of user memory acceses in x86, add support for
fault injection.

Make both put_user() and get_user() fail with -EFAULT, and clear_user()
fail by not clearing any bytes.

Link: http://lkml.kernel.org/r/20200831171733.955393-4-alinde@google.com
Signed-off-by: Albert van der Linde <alinde@google.com>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |   68 +++++++++++++++++--------------
 arch/x86/lib/usercopy_64.c     |    3 +
 2 files changed, 42 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/uaccess.h~x86-add-failure-injection-to-get-put-clear_user
+++ a/arch/x86/include/asm/uaccess.h
@@ -5,6 +5,7 @@
  * User space memory access functions
  */
 #include <linux/compiler.h>
+#include <linux/fault-inject-usercopy.h>
 #include <linux/kasan-checks.h>
 #include <linux/string.h>
 #include <asm/asm.h>
@@ -175,11 +176,16 @@ extern int __get_user_bad(void);
 	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
-	asm volatile("call __get_user_%P4"				\
-		     : "=a" (__ret_gu), "=r" (__val_gu),		\
+	if (should_fail_usercopy()) {					\
+		(x) = 0;						\
+		__ret_gu = -EFAULT;					\
+	} else {							\
+		asm volatile("call __get_user_%P4"			\
+			: "=a" (__ret_gu), "=r" (__val_gu),		\
 			ASM_CALL_CONSTRAINT				\
-		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
-	(x) = (__force __typeof__(*(ptr))) __val_gu;			\
+			: "0" (ptr), "i" (sizeof(*(ptr))));		\
+		(x) = (__force __typeof__(*(ptr))) __val_gu;		\
+	}								\
 	__builtin_expect(__ret_gu, 0);					\
 })
 
@@ -236,31 +242,35 @@ extern void __put_user_8(void);
  *
  * Return: zero on success, or -EFAULT on error.
  */
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr)) __pu_val;				\
-	__chk_user_ptr(ptr);					\
-	might_fault();						\
-	__pu_val = x;						\
-	switch (sizeof(*(ptr))) {				\
-	case 1:							\
-		__put_user_x(1, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 2:							\
-		__put_user_x(2, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 4:							\
-		__put_user_x(4, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 8:							\
-		__put_user_x8(__pu_val, ptr, __ret_pu);		\
-		break;						\
-	default:						\
-		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	}							\
-	__builtin_expect(__ret_pu, 0);				\
+#define put_user(x, ptr)						\
+({									\
+	int __ret_pu;							\
+	__typeof__(*(ptr)) __pu_val;					\
+	__chk_user_ptr(ptr);						\
+	might_fault();							\
+	__pu_val = x;							\
+	if (should_fail_usercopy()) {					\
+		__ret_pu = -EFAULT;					\
+	} else {							\
+		switch (sizeof(*(ptr))) {				\
+		case 1:							\
+			__put_user_x(1, __pu_val, ptr, __ret_pu);	\
+			break;						\
+		case 2:							\
+			__put_user_x(2, __pu_val, ptr, __ret_pu);	\
+			break;						\
+		case 4:							\
+			__put_user_x(4, __pu_val, ptr, __ret_pu);	\
+			break;						\
+		case 8:							\
+			__put_user_x8(__pu_val, ptr, __ret_pu);		\
+			break;						\
+		default:						\
+			__put_user_x(X, __pu_val, ptr, __ret_pu);	\
+			break;						\
+		}							\
+	}								\
+	__builtin_expect(__ret_pu, 0);					\
 })
 
 #define __put_user_size(x, ptr, size, label)				\
--- a/arch/x86/lib/usercopy_64.c~x86-add-failure-injection-to-get-put-clear_user
+++ a/arch/x86/lib/usercopy_64.c
@@ -7,6 +7,7 @@
  * Copyright 2002 Andi Kleen <ak@suse.de>
  */
 #include <linux/export.h>
+#include <linux/fault-inject-usercopy.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 
@@ -50,6 +51,8 @@ EXPORT_SYMBOL(__clear_user);
 
 unsigned long clear_user(void __user *to, unsigned long n)
 {
+	if (should_fail_usercopy())
+		return n;
 	if (access_ok(to, n))
 		return __clear_user(to, n);
 	return n;
_

Patches currently in -mm which might be from alinde@google.com are

lib-include-linux-add-usercopy-failure-capability.patch
lib-uaccess-add-failure-injection-to-usercopy-functions.patch

