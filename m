Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFB4C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB4420EDD
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598899000;
	bh=IHh90jStWTRGOFmRtHLlHfPgBXLMhAOleGFnq3DrrkQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=quVVVLL1AAv5RZ82V87SQQZr7j/Vswc5jqItG0r7icnIJubRc/+ZMynK5YrNzpG09
	 UrOM/lGTifh8dpdOoTAi+C1QTTXrf7cmJxZjtOmKb3NIsvq3Cgo+dKjae3iev5Y6ay
	 51zcOzHY0uLmwJfl4r6cv2IJIj7vFvwCmy7Kcm58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgHaSgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgHaSgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:36:38 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF562071B;
        Mon, 31 Aug 2020 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598898997;
        bh=IHh90jStWTRGOFmRtHLlHfPgBXLMhAOleGFnq3DrrkQ=;
        h=Date:From:To:Subject:From;
        b=benYMNtl923dU0KWZSCb10yLWax+k1an5hGCmhJI9KJzPXbmXOqJ06sa7JKZmrZw+
         UpkeKHXy2EhiPNVWYUgN1MuSAVGjzyDAl4RW/gBwCrFNP6CLZ/FAYejs8hZaU9pN+c
         swhbDh2UzWL++kJyUbyjTf7OIGjoo70ifhufThgI=
Date:   Mon, 31 Aug 2020 11:36:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        hpa@zytor.com, hch@lst.de, glider@google.com, elver@google.com,
        dvyukov@google.com, corbet@lwn.net, bp@alien8.de, arnd@arndb.de,
        andreyknvl@google.com, akinobu.mita@gmail.com, alinde@google.com
Subject:  +
 lib-uaccess-add-failure-injection-to-usercopy-functions.patch added to -mm
 tree
Message-ID: <20200831183635.mC90S%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, uaccess: add failure injection to usercopy functions
has been added to the -mm tree.  Its filename is
     lib-uaccess-add-failure-injection-to-usercopy-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-uaccess-add-failure-injection-to-usercopy-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-uaccess-add-failure-injection-to-usercopy-functions.patch

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
 #include <linux/sched.h>
 #include <linux/thread_info.h>
@@ -83,6 +84,8 @@ static __always_inline __must_check unsi
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_from_user(to, from, n);
 	check_object_size(to, n, false);
 	return raw_copy_from_user(to, from, n);
@@ -104,6 +107,8 @@ __copy_from_user(void *to, const void __
 static __always_inline __must_check unsigned long
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
 	return raw_copy_to_user(to, from, n);
@@ -113,6 +118,8 @@ static __always_inline __must_check unsi
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
+	if (should_fail_usercopy())
+		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
 	return raw_copy_to_user(to, from, n);
@@ -124,7 +131,7 @@ _copy_from_user(void *to, const void __u
 {
 	unsigned long res = n;
 	might_fault();
-	if (likely(access_ok(from, n))) {
+	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
 		instrument_copy_from_user(to, from, n);
 		res = raw_copy_from_user(to, from, n);
 	}
@@ -142,6 +149,8 @@ static inline __must_check unsigned long
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
@@ -139,6 +140,8 @@
 
 static int copyout(void __user *to, const void *from, size_t n)
 {
+	if (should_fail_usercopy())
+		return n;
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
 		n = raw_copy_to_user(to, from, n);
@@ -148,6 +151,8 @@ static int copyout(void __user *to, cons
 
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

Patches currently in -mm which might be from alinde@google.com are

lib-include-linux-add-usercopy-failure-capability.patch
lib-uaccess-add-failure-injection-to-usercopy-functions.patch
x86-add-failure-injection-to-get-put-clear_user.patch

