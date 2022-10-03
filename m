Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89409C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJCVOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJCVNN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B268452E5E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E9F06118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E371C433C1;
        Mon,  3 Oct 2022 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831287;
        bh=pTKQkpENK5X+FDk8LNkJ7TR0FkcKLfRQTFfKIley8HE=;
        h=Date:To:From:Subject:From;
        b=Kyf5jD3kSDow4Q6+VJvbiYKF+SbR5cDXzKOSzmyt2q/0G+RuKFiYxQpTxIoFc8jDc
         4tXZAVEH9IbpHJX0pqyWX4h5LKakwmi70CgHTpIHoG8dn/HrnPPEVoQuFMmIvZZFvJ
         Lpcau+IXj5j94OIQmAMr3yVdUBZnLZ9u0Xq1Iwdg=
Date:   Mon, 03 Oct 2022 14:08:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] instrumentedh-allow-instrumenting-both-sides-of-copy_from_user.patch removed from -mm tree
Message-Id: <20221003210807.9E371C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: instrumented.h: allow instrumenting both sides of copy_from_user()
has been removed from the -mm tree.  Its filename was
     instrumentedh-allow-instrumenting-both-sides-of-copy_from_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: instrumented.h: allow instrumenting both sides of copy_from_user()
Date: Thu, 15 Sep 2022 17:03:37 +0200

Introduce instrument_copy_from_user_before() and
instrument_copy_from_user_after() hooks to be invoked before and after the
call to copy_from_user().

KASAN and KCSAN will be only using instrument_copy_from_user_before(), but
for KMSAN we'll need to insert code after copy_from_user().

Link: https://lkml.kernel.org/r/20220915150417.722975-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/lib/uaccess.c      |    3 ++-
 include/linux/instrumented.h |   21 +++++++++++++++++++--
 include/linux/uaccess.h      |   19 ++++++++++++++-----
 lib/iov_iter.c               |    9 ++++++---
 lib/usercopy.c               |    3 ++-
 5 files changed, 43 insertions(+), 12 deletions(-)

--- a/arch/s390/lib/uaccess.c~instrumentedh-allow-instrumenting-both-sides-of-copy_from_user
+++ a/arch/s390/lib/uaccess.c
@@ -81,8 +81,9 @@ unsigned long _copy_from_user_key(void *
 
 	might_fault();
 	if (!should_fail_usercopy()) {
-		instrument_copy_from_user(to, from, n);
+		instrument_copy_from_user_before(to, from, n);
 		res = raw_copy_from_user_key(to, from, n, key);
+		instrument_copy_from_user_after(to, from, n, res);
 	}
 	if (unlikely(res))
 		memset(to + (n - res), 0, res);
--- a/include/linux/instrumented.h~instrumentedh-allow-instrumenting-both-sides-of-copy_from_user
+++ a/include/linux/instrumented.h
@@ -120,7 +120,7 @@ instrument_copy_to_user(void __user *to,
 }
 
 /**
- * instrument_copy_from_user - instrument writes of copy_from_user
+ * instrument_copy_from_user_before - add instrumentation before copy_from_user
  *
  * Instrument writes to kernel memory, that are due to copy_from_user (and
  * variants). The instrumentation should be inserted before the accesses.
@@ -130,10 +130,27 @@ instrument_copy_to_user(void __user *to,
  * @n number of bytes to copy
  */
 static __always_inline void
-instrument_copy_from_user(const void *to, const void __user *from, unsigned long n)
+instrument_copy_from_user_before(const void *to, const void __user *from, unsigned long n)
 {
 	kasan_check_write(to, n);
 	kcsan_check_write(to, n);
 }
 
+/**
+ * instrument_copy_from_user_after - add instrumentation after copy_from_user
+ *
+ * Instrument writes to kernel memory, that are due to copy_from_user (and
+ * variants). The instrumentation should be inserted after the accesses.
+ *
+ * @to destination address
+ * @from source address
+ * @n number of bytes to copy
+ * @left number of bytes not copied (as returned by copy_from_user)
+ */
+static __always_inline void
+instrument_copy_from_user_after(const void *to, const void __user *from,
+				unsigned long n, unsigned long left)
+{
+}
+
 #endif /* _LINUX_INSTRUMENTED_H */
--- a/include/linux/uaccess.h~instrumentedh-allow-instrumenting-both-sides-of-copy_from_user
+++ a/include/linux/uaccess.h
@@ -58,20 +58,28 @@
 static __always_inline __must_check unsigned long
 __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 {
-	instrument_copy_from_user(to, from, n);
+	unsigned long res;
+
+	instrument_copy_from_user_before(to, from, n);
 	check_object_size(to, n, false);
-	return raw_copy_from_user(to, from, n);
+	res = raw_copy_from_user(to, from, n);
+	instrument_copy_from_user_after(to, from, n, res);
+	return res;
 }
 
 static __always_inline __must_check unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
+	unsigned long res;
+
 	might_fault();
+	instrument_copy_from_user_before(to, from, n);
 	if (should_fail_usercopy())
 		return n;
-	instrument_copy_from_user(to, from, n);
 	check_object_size(to, n, false);
-	return raw_copy_from_user(to, from, n);
+	res = raw_copy_from_user(to, from, n);
+	instrument_copy_from_user_after(to, from, n, res);
+	return res;
 }
 
 /**
@@ -115,8 +123,9 @@ _copy_from_user(void *to, const void __u
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
-		instrument_copy_from_user(to, from, n);
+		instrument_copy_from_user_before(to, from, n);
 		res = raw_copy_from_user(to, from, n);
+		instrument_copy_from_user_after(to, from, n, res);
 	}
 	if (unlikely(res))
 		memset(to + (n - res), 0, res);
--- a/lib/iov_iter.c~instrumentedh-allow-instrumenting-both-sides-of-copy_from_user
+++ a/lib/iov_iter.c
@@ -174,13 +174,16 @@ static int copyout(void __user *to, cons
 
 static int copyin(void *to, const void __user *from, size_t n)
 {
+	size_t res = n;
+
 	if (should_fail_usercopy())
 		return n;
 	if (access_ok(from, n)) {
-		instrument_copy_from_user(to, from, n);
-		n = raw_copy_from_user(to, from, n);
+		instrument_copy_from_user_before(to, from, n);
+		res = raw_copy_from_user(to, from, n);
+		instrument_copy_from_user_after(to, from, n, res);
 	}
-	return n;
+	return res;
 }
 
 static inline struct pipe_buffer *pipe_buf(const struct pipe_inode_info *pipe,
--- a/lib/usercopy.c~instrumentedh-allow-instrumenting-both-sides-of-copy_from_user
+++ a/lib/usercopy.c
@@ -12,8 +12,9 @@ unsigned long _copy_from_user(void *to,
 	unsigned long res = n;
 	might_fault();
 	if (!should_fail_usercopy() && likely(access_ok(from, n))) {
-		instrument_copy_from_user(to, from, n);
+		instrument_copy_from_user_before(to, from, n);
 		res = raw_copy_from_user(to, from, n);
+		instrument_copy_from_user_after(to, from, n, res);
 	}
 	if (unlikely(res))
 		memset(to + (n - res), 0, res);
_

Patches currently in -mm which might be from glider@google.com are


