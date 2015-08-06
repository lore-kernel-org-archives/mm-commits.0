From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_user_copy-check-user-checksum-functions.patch removed from -mm tree
Date: Thu, 06 Aug 2015 12:33:18 -0700
Message-ID: <55c3b67e.373mnUXNLikPRFJr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbbHFTdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2015 15:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check user checksum functions
has been removed from the -mm tree.  Its filename was
     test_user_copy-check-user-checksum-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: lib/test_user_copy.c: check user checksum functions

Add basic success/failure checking of the combined user copy and checksum
functions which copy data between user and kernel space while also
checksumming that data.  Some architectures have optimised versions of
these which combine both operations into a single pass.

The following cases are checked:
- csum_partial_copy_from_user() with legitimate user to kernel
  addresses, illegal all-kernel and reversed addresses (for
  implementations where this is safe to test, as this function does not
  perform an access_ok() check), and legitimate all-kernel addresses.
- csum_and_copy_from_user() with legitimate user to kernel addresses,
  illegal all-kernel and reversed addresses, and legitimate all-kernel
  addresses.
- csum_partial_copy_from_user() with legitimate kernel to user
  addresses, illegal all-kernel and reversed addresses, and legitimate
  all-kernel addresses.

New tests:
- legitimate csum_and_copy_from_user
- legitimate csum_and_copy_to_user
- legitimate csum_partial_copy_from_user
- illegal all-kernel csum_and_copy_from_user
- illegal reversed csum_and_copy_from_user
- illegal all-kernel csum_and_copy_to_user
- illegal reversed csum_and_copy_to_user
- illegal all-kernel csum_partial_copy_from_user
- illegal reversed csum_partial_copy_from_user
- legitimate kernel csum_and_copy_from_user
- legitimate kernel csum_and_copy_to_user
- legitimate kernel csum_partial_copy_from_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-user-checksum-functions lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-user-checksum-functions
+++ a/lib/test_user_copy.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
+#include <net/checksum.h>
 
 #define test(condition, msg)		\
 ({					\
@@ -41,6 +42,7 @@ static int __init test_user_copy_init(vo
 	char *bad_usermem;
 	unsigned long user_addr;
 	unsigned long value = 0x5A;
+	int err;
 	mm_segment_t fs = get_fs();
 
 	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
@@ -78,6 +80,12 @@ static int __init test_user_copy_init(vo
 		    "legitimate strnlen_user failed");
 	ret |= test(strlen_user(usermem) == 0,
 		    "legitimate strlen_user failed");
+	err = 0;
+	csum_and_copy_from_user(usermem, kmem, PAGE_SIZE, 0, &err);
+	ret |= test(err, "legitimate csum_and_copy_from_user failed");
+	err = 0;
+	csum_and_copy_to_user(kmem, usermem, PAGE_SIZE, 0, &err);
+	ret |= test(err, "legitimate csum_and_copy_to_user failed");
 
 	ret |= test(!access_ok(VERIFY_READ, usermem, PAGE_SIZE * 2),
 		    "legitimate access_ok VERIFY_READ failed");
@@ -99,6 +107,9 @@ static int __init test_user_copy_init(vo
 		    "legitimate __put_user failed");
 	ret |= test(__clear_user(usermem, PAGE_SIZE) != 0,
 		    "legitimate __clear_user passed");
+	err = 0;
+	csum_partial_copy_from_user(usermem, kmem, PAGE_SIZE, 0, &err);
+	ret |= test(err, "legitimate csum_partial_copy_from_user failed");
 
 	/* Invalid usage: none of these should succeed. */
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
@@ -138,6 +149,22 @@ static int __init test_user_copy_init(vo
 		    "illegal strnlen_user passed");
 	ret |= test(strlen_user((char __user *)kmem) != 0,
 		    "illegal strlen_user passed");
+	err = 0;
+	csum_and_copy_from_user((char __user *)(kmem + PAGE_SIZE), kmem,
+				PAGE_SIZE, 0, &err);
+	ret |= test(!err, "illegal all-kernel csum_and_copy_from_user passed");
+	err = 0;
+	csum_and_copy_from_user((char __user *)kmem, bad_usermem,
+				PAGE_SIZE, 0, &err);
+	ret |= test(!err, "illegal reversed csum_and_copy_from_user passed");
+	err = 0;
+	csum_and_copy_to_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+			      PAGE_SIZE, 0, &err);
+	ret |= test(!err, "illegal all-kernel csum_and_copy_to_user passed");
+	err = 0;
+	csum_and_copy_to_user(bad_usermem, (char __user *)kmem, PAGE_SIZE, 0,
+			      &err);
+	ret |= test(!err, "illegal reversed csum_and_copy_to_user passed");
 
 	/*
 	 * If unchecked user accesses (__*) on this architecture cannot access
@@ -192,6 +219,16 @@ static int __init test_user_copy_init(vo
 		    "illegal __put_user passed");
 	ret |= test(__clear_user((char __user *)kmem, PAGE_SIZE) != PAGE_SIZE,
 		    "illegal kernel __clear_user passed");
+	err = 0;
+	csum_partial_copy_from_user((char __user *)(kmem + PAGE_SIZE), kmem,
+				    PAGE_SIZE, 0, &err);
+	ret |= test(!err,
+		    "illegal all-kernel csum_partial_copy_from_user passed");
+	err = 0;
+	csum_partial_copy_from_user((char __user *)kmem, bad_usermem, PAGE_SIZE,
+				    0, &err);
+	ret |= test(!err,
+		    "illegal reversed csum_partial_copy_from_user passed");
 #endif
 
 	/*
@@ -224,6 +261,14 @@ static int __init test_user_copy_init(vo
 		    "legitimate kernel strnlen_user failed");
 	ret |= test(strlen_user((char __user *)kmem) == 0,
 		    "legitimate kernel strlen_user failed");
+	err = 0;
+	csum_and_copy_from_user((char __user *)(kmem + PAGE_SIZE), kmem,
+				PAGE_SIZE, 0, &err);
+	ret |= test(err, "legitimate kernel csum_and_copy_from_user failed");
+	err = 0;
+	csum_and_copy_to_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+			      PAGE_SIZE, 0, &err);
+	ret |= test(err, "legitimate kernel csum_and_copy_to_user failed");
 
 	ret |= test(!access_ok(VERIFY_READ, (char __user *)kmem, PAGE_SIZE * 2),
 		    "legitimate kernel access_ok VERIFY_READ failed");
@@ -253,6 +298,11 @@ static int __init test_user_copy_init(vo
 		    "legitimate kernel __put_user failed");
 	ret |= test(__clear_user((char __user *)kmem, PAGE_SIZE) != 0,
 		    "legitimate kernel __clear_user failed");
+	err = 0;
+	csum_partial_copy_from_user((char __user *)(kmem + PAGE_SIZE), kmem,
+				    PAGE_SIZE, 0, &err);
+	ret |= test(err,
+		    "legitimate kernel csum_partial_copy_from_user failed");
 
 	/* Restore previous address limit. */
 	set_fs(fs);
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

linux-next.patch

