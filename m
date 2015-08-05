From: akpm@linux-foundation.org
Subject: + test_user_copy-check-__copy_in_user-copy_in_user.patch added to -mm tree
Date: Wed, 05 Aug 2015 12:59:06 -0700
Message-ID: <55c26b0a.37Xr9GOsnC1vzJRX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbHET7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check __copy_in_user()/copy_in_user()
has been added to the -mm tree.  Its filename is
     test_user_copy-check-__copy_in_user-copy_in_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_user_copy-check-__copy_in_user-copy_in_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_user_copy-check-__copy_in_user-copy_in_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: lib/test_user_copy.c: check __copy_in_user()/copy_in_user()

Add basic success/failure checking of copy_in_user() which copies data
from userspace to userspace (or kernel to kernel), and its unchecking
cousin __copy_in_user() which assumes that access_ok() has already been
used as appropriate.

The following cases are checked:
- __copy_in_user/copy_in_user from user to user should succeed.
- __copy_in_user/copy_in_user involving 1 or 2 kernel pointers should
  not succeed.
- __copy_in_user/copy_in_user from kernel to kernel should succeed when
  user address limit is set for kernel accesses.

New tests:
- legitimate copy_in_user
- legitimate __copy_in_user
- illegal all-kernel copy_in_user
- illegal copy_in_user to kernel
- illegal copy_in_user from kernel
- illegal all-kernel __copy_in_user
- illegal __copy_in_user to kernel
- illegal __copy_in_user from kernel
- legitimate all-kernel copy_in_user
- legitimate all-kernel __copy_in_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-__copy_in_user-copy_in_user lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-__copy_in_user-copy_in_user
+++ a/lib/test_user_copy.c
@@ -64,6 +64,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate copy_from_user failed");
 	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
 		    "legitimate copy_to_user failed");
+	ret |= test(copy_in_user(usermem, usermem + PAGE_SIZE, PAGE_SIZE),
+		    "legitimate copy_in_user failed");
 	ret |= test(get_user(value, (unsigned long __user *)usermem),
 		    "legitimate get_user failed");
 	ret |= test(put_user(value, (unsigned long __user *)usermem),
@@ -79,6 +81,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate __copy_from_user failed");
 	ret |= test(__copy_to_user(usermem, kmem, PAGE_SIZE),
 		    "legitimate __copy_to_user failed");
+	ret |= test(__copy_in_user(usermem, usermem + PAGE_SIZE, PAGE_SIZE),
+		    "legitimate __copy_in_user failed");
 	ret |= test(__get_user(value, (unsigned long __user *)usermem),
 		    "legitimate __get_user failed");
 	ret |= test(__put_user(value, (unsigned long __user *)usermem),
@@ -99,6 +103,15 @@ static int __init test_user_copy_init(vo
 	ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
+	ret |= test(!copy_in_user((char __user *)kmem,
+				  (char __user *)(kmem + PAGE_SIZE), PAGE_SIZE),
+		    "illegal all-kernel copy_in_user passed");
+	ret |= test(!copy_in_user((char __user *)kmem, usermem,
+				  PAGE_SIZE),
+		    "illegal copy_in_user to kernel passed");
+	ret |= test(!copy_in_user(usermem, (char __user *)kmem,
+				  PAGE_SIZE),
+		    "illegal copy_in_user from kernel passed");
 	ret |= test(!get_user(value, (unsigned long __user *)kmem),
 		    "illegal get_user passed");
 	ret |= test(!put_user(value, (unsigned long __user *)kmem),
@@ -130,6 +143,16 @@ static int __init test_user_copy_init(vo
 	ret |= test(!__copy_to_user((char __user *)kmem, bad_usermem,
 				    PAGE_SIZE),
 		    "illegal reversed __copy_to_user passed");
+	ret |= test(!__copy_in_user((char __user *)kmem,
+				    (char __user *)(kmem + PAGE_SIZE),
+				    PAGE_SIZE),
+		    "illegal all-kernel __copy_in_user passed");
+	ret |= test(!__copy_in_user((char __user *)kmem, usermem,
+				    PAGE_SIZE),
+		    "illegal __copy_in_user to kernel passed");
+	ret |= test(!__copy_in_user(usermem, (char __user *)kmem,
+				    PAGE_SIZE),
+		    "illegal __copy_in_user from kernel passed");
 	ret |= test(!__get_user(value, (unsigned long __user *)kmem),
 		    "illegal __get_user passed");
 	ret |= test(!__put_user(value, (unsigned long __user *)kmem),
@@ -152,6 +175,9 @@ static int __init test_user_copy_init(vo
 	ret |= test(copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				 PAGE_SIZE),
 		    "legitimate all-kernel copy_to_user failed");
+	ret |= test(copy_in_user((char __user *)kmem,
+				 (char __user *)(kmem + PAGE_SIZE), PAGE_SIZE),
+		    "legitimate all-kernel copy_in_user failed");
 	ret |= test(get_user(value, (unsigned long __user *)kmem),
 		    "legitimate kernel get_user failed");
 	ret |= test(put_user(value, (unsigned long __user *)kmem),
@@ -170,6 +196,10 @@ static int __init test_user_copy_init(vo
 	ret |= test(__copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				   PAGE_SIZE),
 		    "legitimate all-kernel __copy_to_user failed");
+	ret |= test(__copy_in_user((char __user *)kmem,
+				   (char __user *)(kmem + PAGE_SIZE),
+				   PAGE_SIZE),
+		    "legitimate all-kernel __copy_in_user failed");
 	ret |= test(__get_user(value, (unsigned long __user *)kmem),
 		    "legitimate kernel __get_user failed");
 	ret |= test(__put_user(value, (unsigned long __user *)kmem),
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

test_user_copy-check-legit-kernel-accesses.patch
test_user_copy-check-unchecked-accessors.patch
test_user_copy-check-__clear_user-clear_user.patch
test_user_copy-check-__copy_in_user-copy_in_user.patch
test_user_copy-check-__copy_tofrom_user_inatomic.patch
test_user_copy-check-user-string-accessors.patch
test_user_copy-check-user-checksum-functions.patch
linux-next.patch

