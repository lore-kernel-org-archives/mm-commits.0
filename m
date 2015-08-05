From: akpm@linux-foundation.org
Subject: + test_user_copy-check-user-string-accessors.patch added to -mm
 tree
Date: Wed, 05 Aug 2015 12:59:10 -0700
Message-ID: <55c26b0e.zXzp1lVasNLRzfZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbHET7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check user string accessors
has been added to the -mm tree.  Its filename is
     test_user_copy-check-user-string-accessors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_user_copy-check-user-string-accessors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_user_copy-check-user-string-accessors.patch

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
Subject: lib/test_user_copy.c: check user string accessors

Add basic success/failure checking of the user string functions which copy
or find the length of userland strings.

The following cases are checked:
- strncpy_from_user() with legitimate user to kernel addresses, illegal
  all-kernel and reversed addresses, and legitimate all-kernel
  addresses.
- strnlen_user()/strlen_user() with a legitimate user address, an
  illegal kernel address, and a legitimate kernel address.

This caught a bug in the MIPS Enhanced Virtual Memory (EVA)
implementation:
test_user_copy: illegal strlen_user passed

Due to strlen_user() accidentally always using normal kernel loads, and
the EVA user/kernel address ranges overlapping.

New tests:
- legitimate strncpy_from_user
- legitimate strnlen_user
- legitimate strlen_user
- illegal all-kernel strncpy_from_user
- illegal reversed strncpy_from_user
- illegal strnlen_user
- illegal strlen_user
- legitimate all-kernel strncpy_from_user
- legitimate kernel strnlen_user
- legitimate kernel strlen_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-user-string-accessors lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-user-string-accessors
+++ a/lib/test_user_copy.c
@@ -72,6 +72,12 @@ static int __init test_user_copy_init(vo
 		    "legitimate put_user failed");
 	ret |= test(clear_user(usermem, PAGE_SIZE) != 0,
 		    "legitimate clear_user passed");
+	ret |= test(strncpy_from_user(kmem, usermem, PAGE_SIZE) < 0,
+		    "legitimate strncpy_from_user failed");
+	ret |= test(strnlen_user(usermem, PAGE_SIZE) == 0,
+		    "legitimate strnlen_user failed");
+	ret |= test(strlen_user(usermem) == 0,
+		    "legitimate strlen_user failed");
 
 	ret |= test(!access_ok(VERIFY_READ, usermem, PAGE_SIZE * 2),
 		    "legitimate access_ok VERIFY_READ failed");
@@ -122,6 +128,16 @@ static int __init test_user_copy_init(vo
 		    "illegal put_user passed");
 	ret |= test(clear_user((char __user *)kmem, PAGE_SIZE) != PAGE_SIZE,
 		    "illegal kernel clear_user passed");
+	ret |= test(strncpy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				      PAGE_SIZE) >= 0,
+		    "illegal all-kernel strncpy_from_user passed");
+	ret |= test(strncpy_from_user(bad_usermem, (char __user *)kmem,
+				      PAGE_SIZE) >= 0,
+		    "illegal reversed strncpy_from_user passed");
+	ret |= test(strnlen_user((char __user *)kmem, PAGE_SIZE) != 0,
+		    "illegal strnlen_user passed");
+	ret |= test(strlen_user((char __user *)kmem) != 0,
+		    "illegal strlen_user passed");
 
 	/*
 	 * If unchecked user accesses (__*) on this architecture cannot access
@@ -201,6 +217,13 @@ static int __init test_user_copy_init(vo
 		    "legitimate kernel put_user failed");
 	ret |= test(clear_user((char __user *)kmem, PAGE_SIZE) != 0,
 		    "legitimate kernel clear_user failed");
+	ret |= test(strncpy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				      PAGE_SIZE) < 0,
+		    "legitimate all-kernel strncpy_from_user failed");
+	ret |= test(strnlen_user((char __user *)kmem, PAGE_SIZE) == 0,
+		    "legitimate kernel strnlen_user failed");
+	ret |= test(strlen_user((char __user *)kmem) == 0,
+		    "legitimate kernel strlen_user failed");
 
 	ret |= test(!access_ok(VERIFY_READ, (char __user *)kmem, PAGE_SIZE * 2),
 		    "legitimate kernel access_ok VERIFY_READ failed");
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

