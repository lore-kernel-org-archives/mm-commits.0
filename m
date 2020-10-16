Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3041C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530DE20878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602818034;
	bh=G7m72kOawUBVXOCwG89NLWL+fmSvwpIFfKx60a2h4T4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BzvF8c6Q0gjis9WvISudGdh0EzXm21RLZ/lmW3Uc/K4n5GBemNjL8hHVpuENB2jgZ
	 /jgaast6N3Kg+66bS2K0Ts2+odz/zEdGzMxUEB/4dRrqt9bt69tXomRCBudHME1JYm
	 eQqrQCkTsrJilQKY5E/qzplNd/OngDBEtjjwkLFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393966AbgJPDNy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E812078A;
        Fri, 16 Oct 2020 03:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602818031;
        bh=G7m72kOawUBVXOCwG89NLWL+fmSvwpIFfKx60a2h4T4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OcLX/ncibQPpN+ie0ge7wvn/4jhRwOlHwl79yd284hjYgLCfGZ+RQvvXsU2jq5Bd8
         6z8w5QXuaw/8NlhH8+2aUcAyGC1yceuGsX8KxIB0iW+v59jJOUhOePIdOYWlhvmOQ/
         b9cmyNyQKJrV8/0vRdBagPaDOD0fXVLCPqsT4/cs=
Date:   Thu, 15 Oct 2020 20:13:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akinobu.mita@gmail.com, akpm@linux-foundation.org,
        alinde@google.com, andreyknvl@google.com, arnd@arndb.de,
        bp@alien8.de, corbet@lwn.net, dvyukov@google.com, elver@google.com,
        glider@google.com, hch@lst.de, hpa@zytor.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 156/156] lib, uaccess: add failure injection to
 usercopy functions
Message-ID: <20201016031350.swyG26d3I%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Albert van der Linde <alinde@google.com>
Subject: lib, uaccess: add failure injection to usercopy functions

To test fault-tolerance of user memory access functions, introduce fault
injection to usercopy functions.

If a failure is expected return either -EFAULT or the total amount of
bytes that were not copied.

Link: http://lkml.kernel.org/r/20200831171733.955393-3-alinde@google.com
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

 include/linux/uaccess.h |   11 ++++++++++-
 lib/iov_iter.c          |    5 +++++
 lib/strncpy_from_user.c |    3 +++
 lib/usercopy.c          |    5 ++++-
 4 files changed, 22 insertions(+), 2 deletions(-)

--- a/include/linux/uaccess.h~lib-uaccess-add-failure-injection-to-usercopy-functions
+++ a/include/linux/uaccess.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_UACCESS_H__
 #define __LINUX_UACCESS_H__
 
+#include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/minmax.h>
 #include <linux/sched.h>
@@ -84,6 +85,8 @@ static __always_inline __must_check unsi
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_from_user(to, from, n);
 	check_object_size(to, n, false);
 	return raw_copy_from_user(to, from, n);
@@ -105,6 +108,8 @@ __copy_from_user(void *to, const void __
 static __always_inline __must_check unsigned long
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
 	return raw_copy_to_user(to, from, n);
@@ -114,6 +119,8 @@ static __always_inline __must_check unsi
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
 	return raw_copy_to_user(to, from, n);
@@ -125,7 +132,7 @@ _copy_from_user(void *to, const void __u
 {
 	unsigned long res = n;
 	might_fault();
-	if (likely(access_ok(from, n))) {
+	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
 		instrument_copy_from_user(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 	}
@@ -143,6 +150,8 @@ static inline __must_check unsigned long
 _copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
 		n = raw_copy_to_user(to, from, n);
--- a/lib/iov_iter.c~lib-uaccess-add-failure-injection-to-usercopy-functions
+++ a/lib/iov_iter.c
@@ -2,6 +2,7 @@
 #include <crypto/hash.h>
 #include <linux/export.h>
 #include <linux/bvec.h>
+#include <linux/fault-inject-usercopy.h>
 #include <linux/uio.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -140,6 +141,8 @@
 
 static int copyout(void __user *to, const void *from, size_t n)
 {
+	if (should_fail_usercopy())
+		return n;
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
 		n = raw_copy_to_user(to, from, n);
@@ -149,6 +152,8 @@ static int copyout(void __user *to, cons
 
 static int copyin(void *to, const void __user *from, size_t n)
 {
+	if (should_fail_usercopy())
+		return n;
 	if (access_ok(from, n)) {
 		instrument_copy_from_user(to, from, n);
 		n = raw_copy_from_user(to, from, n);
--- a/lib/strncpy_from_user.c~lib-uaccess-add-failure-injection-to-usercopy-functions
+++ a/lib/strncpy_from_user.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/compiler.h>
 #include <linux/export.h>
+#include <linux/fault-inject-usercopy.h>
 #include <linux/kasan-checks.h>
 #include <linux/thread_info.h>
 #include <linux/uaccess.h>
@@ -99,6 +100,8 @@ long strncpy_from_user(char *dst, const
 	unsigned long max_addr, src_addr;
 
 	might_fault();
+	if (should_fail_usercopy())
+		return -EFAULT;
 	if (unlikely(count <= 0))
 		return 0;
 
--- a/lib/usercopy.c~lib-uaccess-add-failure-injection-to-usercopy-functions
+++ a/lib/usercopy.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/bitops.h>
+#include <linux/fault-inject-usercopy.h>
 #include <linux/instrumented.h>
 #include <linux/uaccess.h>
 
@@ -10,7 +11,7 @@ unsigned long _copy_from_user(void *to,
 {
 	unsigned long res = n;
 	might_fault();
-	if (likely(access_ok(from, n))) {
+	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
 		instrument_copy_from_user(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 	}
@@ -25,6 +26,8 @@ EXPORT_SYMBOL(_copy_from_user);
 unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	if (likely(access_ok(to, n))) {
 		instrument_copy_to_user(to, from, n);
 		n = raw_copy_to_user(to, from, n);
_
