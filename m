From: akpm@linux-foundation.org
Subject: + test_user_copy-check-__copy_tofrom_user_inatomic.patch added to -mm tree
Date: Wed, 05 Aug 2015 12:59:08 -0700
Message-ID: <55c26b0c.+otRjqy8eYTTaCAl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbHET7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check __copy_{to,from}_user_inatomic()
has been added to the -mm tree.  Its filename is
     test_user_copy-check-__copy_tofrom_user_inatomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_user_copy-check-__copy_tofrom_user_inatomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_user_copy-check-__copy_tofrom_user_inatomic.patch

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
Cc: Kees Cook <keescook@chromium.org>
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

test_user_copy-check-legit-kernel-accesses.patch
test_user_copy-check-unchecked-accessors.patch
test_user_copy-check-__clear_user-clear_user.patch
test_user_copy-check-__copy_in_user-copy_in_user.patch
test_user_copy-check-__copy_tofrom_user_inatomic.patch
test_user_copy-check-user-string-accessors.patch
test_user_copy-check-user-checksum-functions.patch
linux-next.patch

