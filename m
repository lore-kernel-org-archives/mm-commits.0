From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_user_copy-check-__copy_tofrom_user_inatomic.patch removed from -mm
 tree
Date: Thu, 06 Aug 2015 12:33:12 -0700
Message-ID: <55c3b678.KZcIle+xeUUQ7O6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbbHFTdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2015 15:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check __copy_{to,from}_user_inatomic()
has been removed from the -mm tree.  Its filename was
     test_user_copy-check-__copy_tofrom_user_inatomic.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: lib/test_user_copy.c: check __copy_{to,from}_user_inatomic()

Add basic success/failure checking of __copy_to_user_inatomic() and
__copy_from_user_inatomic().  For testing purposes these are similar to
their non-atomic non-checking friends, so the new tests match those for
__copy_to_user() and __copy_from_user().

New tests:
- legitimate __copy_from_user_inatomic
- legitimate __copy_to_user_inatomic
- illegal all-kernel __copy_from_user_inatomic
- illegal reversed __copy_from_user_inatomic
- illegal all-kernel __copy_to_user_inatomic
- illegal reversed __copy_to_user_inatomic
- legitimate all-kernel __copy_from_user_inatomic
- legitimate all-kernel __copy_to_user_inatomic

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-__copy_tofrom_user_inatomic lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-__copy_tofrom_user_inatomic
+++ a/lib/test_user_copy.c
@@ -79,8 +79,12 @@ static int __init test_user_copy_init(vo
 		    "legitimate access_ok VERIFY_WRITE failed");
 	ret |= test(__copy_from_user(kmem, usermem, PAGE_SIZE),
 		    "legitimate __copy_from_user failed");
+	ret |= test(__copy_from_user_inatomic(kmem, usermem, PAGE_SIZE),
+		    "legitimate __copy_from_user_inatomic failed");
 	ret |= test(__copy_to_user(usermem, kmem, PAGE_SIZE),
 		    "legitimate __copy_to_user failed");
+	ret |= test(__copy_to_user_inatomic(usermem, kmem, PAGE_SIZE),
+		    "legitimate __copy_to_user_inatomic failed");
 	ret |= test(__copy_in_user(usermem, usermem + PAGE_SIZE, PAGE_SIZE),
 		    "legitimate __copy_in_user failed");
 	ret |= test(__get_user(value, (unsigned long __user *)usermem),
@@ -137,12 +141,25 @@ static int __init test_user_copy_init(vo
 	ret |= test(!__copy_from_user(bad_usermem, (char __user *)kmem,
 				      PAGE_SIZE),
 		    "illegal reversed __copy_from_user passed");
+	ret |= test(!__copy_from_user_inatomic(kmem,
+					(char __user *)(kmem + PAGE_SIZE),
+					PAGE_SIZE),
+		    "illegal all-kernel __copy_from_user_inatomic passed");
+	ret |= test(!__copy_from_user_inatomic(bad_usermem, (char __user *)kmem,
+					       PAGE_SIZE),
+		    "illegal reversed __copy_from_user_inatomic passed");
 	ret |= test(!__copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				    PAGE_SIZE),
 		    "illegal all-kernel __copy_to_user passed");
 	ret |= test(!__copy_to_user((char __user *)kmem, bad_usermem,
 				    PAGE_SIZE),
 		    "illegal reversed __copy_to_user passed");
+	ret |= test(!__copy_to_user_inatomic((char __user *)kmem,
+					     kmem + PAGE_SIZE, PAGE_SIZE),
+		    "illegal all-kernel __copy_to_user_inatomic passed");
+	ret |= test(!__copy_to_user_inatomic((char __user *)kmem, bad_usermem,
+					     PAGE_SIZE),
+		    "illegal reversed __copy_to_user_inatomic passed");
 	ret |= test(!__copy_in_user((char __user *)kmem,
 				    (char __user *)(kmem + PAGE_SIZE),
 				    PAGE_SIZE),
@@ -193,9 +210,16 @@ static int __init test_user_copy_init(vo
 	ret |= test(__copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
 				     PAGE_SIZE),
 		    "legitimate all-kernel __copy_from_user failed");
+	ret |= test(__copy_from_user_inatomic(kmem,
+					      (char __user *)(kmem + PAGE_SIZE),
+					      PAGE_SIZE),
+		    "legitimate all-kernel __copy_from_user_inatomic failed");
 	ret |= test(__copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
 				   PAGE_SIZE),
 		    "legitimate all-kernel __copy_to_user failed");
+	ret |= test(__copy_to_user_inatomic((char __user *)kmem,
+					    kmem + PAGE_SIZE, PAGE_SIZE),
+		    "legitimate all-kernel __copy_to_user_inatomic failed");
 	ret |= test(__copy_in_user((char __user *)kmem,
 				   (char __user *)(kmem + PAGE_SIZE),
 				   PAGE_SIZE),
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

test_user_copy-check-user-string-accessors.patch
test_user_copy-check-user-checksum-functions.patch
linux-next.patch

