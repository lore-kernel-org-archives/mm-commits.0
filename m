From: akpm@linux-foundation.org
Subject: [patch 02/13] lib/atomic64_test.c: add a test that
 atomic64_inc_not_zero() returns an int
Date: Fri, 14 Jul 2017 14:49:41 -0700
Message-ID: <59693c75.63ABeNMc0HxizS/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdGNVtn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mpe@ellerman.id.au, dougmill@linux.vnet.ibm.com

From: Michael Ellerman <mpe@ellerman.id.au>
Subject: lib/atomic64_test.c: add a test that atomic64_inc_not_zero() returns an int

atomic64_inc_not_zero() returns a "truth value" which in C is
traditionally an int.  That means callers are likely to expect the result
will fit in an int.

If an implementation returns a "true" value which does not fit in an int,
then there's a possibility that callers will truncate it when they store
it in an int.  In fact this happened in practice, see commit 966d2b04e070
("percpu-refcount: fix reference leak during percpu-atomic transition").

So add a test that the result fits in an int, even when the input doesn't.
This catches the case where an implementation just passes the non-zero
input value out as the result.

Link: http://lkml.kernel.org/r/1499775133-1231-1-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Douglas Miller <dougmill@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN lib/atomic64_test.c~lib-atomic64-test-add-a-test-that-atomic64_inc_not_zero-returns-an-int lib/atomic64_test.c
--- a/lib/atomic64_test.c~lib-atomic64-test-add-a-test-that-atomic64_inc_not_zero-returns-an-int
+++ a/lib/atomic64_test.c
@@ -153,8 +153,10 @@ static __init void test_atomic64(void)
 	long long v0 = 0xaaa31337c001d00dLL;
 	long long v1 = 0xdeadbeefdeafcafeLL;
 	long long v2 = 0xfaceabadf00df001LL;
+	long long v3 = 0x8000000000000000LL;
 	long long onestwos = 0x1111111122222222LL;
 	long long one = 1LL;
+	int r_int;
 
 	atomic64_t v = ATOMIC64_INIT(v0);
 	long long r = v0;
@@ -240,6 +242,11 @@ static __init void test_atomic64(void)
 	BUG_ON(!atomic64_inc_not_zero(&v));
 	r += one;
 	BUG_ON(v.counter != r);
+
+	/* Confirm the return value fits in an int, even if the value doesn't */
+	INIT(v3);
+	r_int = atomic64_inc_not_zero(&v);
+	BUG_ON(!r_int);
 }
 
 static __init int test_atomics_init(void)
_
