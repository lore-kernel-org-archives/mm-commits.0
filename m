Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDB9C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3D9207DA
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598899003;
	bh=6p+MYRmmin8r3hAYAsRzfg6yWI9zxmhUO0uS3R+WwpU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iQUg3NkREckKBdVHeI/I1snc+HbhX3MrtxIUbUlx07xQJbxXjyFxnzEItPsUm4U2+
	 +Ax0xEye04EirjFu0nTJMOXAcJqKmsPlzSJLGfjZkppuXrU86X1eeugEDEUIKi966J
	 lFQcoafuJf0BBwoB4KwFzlcWQiQBUi0uNzA0OPbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgHaSgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgHaSgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:36:42 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC13A20936;
        Mon, 31 Aug 2020 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598899001;
        bh=6p+MYRmmin8r3hAYAsRzfg6yWI9zxmhUO0uS3R+WwpU=;
        h=Date:From:To:Subject:From;
        b=Q/hP+0BXxQyLukl3Ex8aIoREuY7dQGVP+Aw0P+yoXP8MSETncZ9wDNt5jv/GGn/Dh
         oseGzISvfnFSEZMHWj5tVWfnq1RfsjlxQAb+hpq4r1k41WFWw6nLNMo9lwG16o8VOe
         +Cje4wnjMSOMm2RZszVu2m8ASF8DVd1cqKfyQH+8=
Date:   Mon, 31 Aug 2020 11:36:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        hpa@zytor.com, hch@lst.de, glider@google.com, elver@google.com,
        dvyukov@google.com, corbet@lwn.net, bp@alien8.de, arnd@arndb.de,
        andreyknvl@google.com, akinobu.mita@gmail.com, alinde@google.com
Subject:  + x86-add-failure-injection-to-get-put-clear_user.patch
 added to -mm tree
Message-ID: <20200831183639.MID_Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: add failure injection to get/put/clear_user
has been added to the -mm tree.  Its filename is
     x86-add-failure-injection-to-get-put-clear_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-failure-injection-to-get-put-clear_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-failure-injection-to-get-put-clear_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
x86-add-failure-injection-to-get-put-clear_user.patch

