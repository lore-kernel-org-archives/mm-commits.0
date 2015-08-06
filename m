From: akpm@linux-foundation.org
Subject: [to-be-updated]
 test_user_copy-check-__clear_user-clear_user.patch removed from -mm tree
Date: Thu, 06 Aug 2015 12:33:06 -0700
Message-ID: <55c3b672.5fedckZhs86f9L3F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbHFTdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2015 15:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check __clear_user()/clear_user()
has been removed from the -mm tree.  Its filename was
     test_user_copy-check-__clear_user-clear_user.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: lib/test_user_copy.c: check __clear_user()/clear_user()

Add basic success/failure checking of __clear_user() and clear_user(),
which zero an area of user or kernel memory and return the number of bytes
left to clear.

This catches a couple of bugs in the MIPS Enhanced Virtual Memory (EVA)
implementation (which have already been fixed): test_user_copy: legitimate
kernel clear_user failed test_user_copy: legitimate kernel __clear_user
failed

Due to neither function checking the user address limit, and both
resorting to user access unconditionally.

New tests:
- legitimate clear_user
- legitimate __clear_user
- illegal kernel clear_user
- illegal kernel __clear_user
- legitimate kernel clear_user
- legitimate kernel __clear_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-__clear_user-clear_user lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-__clear_user-clear_user
+++ a/lib/test_user_copy.c
@@ -68,6 +68,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate get_user failed");
 	ret |= test(put_user(value, (unsigned long __user *)usermem),
 		    "legitimate put_user failed");
+	ret |= test(clear_user(usermem, PAGE_SIZE) != 0,
+		    "legitimate clear_user passed");
 
 	ret |= test(!access_ok(VERIFY_READ, usermem, PAGE_SIZE * 2),
 		    "legitimate access_ok VERIFY_READ failed");
@@ -81,6 +83,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate __get_user failed");
 	ret |= test(__put_user(value, (unsigned long __user *)usermem),
 		    "legitimate __put_user failed");
+	ret |= test(__clear_user(usermem, PAGE_SIZE) != 0,
+		    "legitimate __clear_user passed");
 
 	/* Invalid usage: none of these should succeed. */
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
@@ -99,6 +103,8 @@ static int __init test_user_copy_init(vo
 		    "illegal get_user passed");
 	ret |= test(!put_user(value, (unsigned long __user *)kmem),
 		    "illegal put_user passed");
+	ret |= test(clear_user((char __user *)kmem, PAGE_SIZE) != PAGE_SIZE,
+		    "illegal kernel clear_user passed");
 
 	/*
 	 * If unchecked user accesses (__*) on this architecture cannot access
@@ -128,6 +134,8 @@ static int __init test_user_copy_init(vo
 		    "illegal __get_user passed");
 	ret |= test(!__put_user(value, (unsigned long __user *)kmem),
 		    "illegal __put_user passed");
+	ret |= test(__clear_user((char __user *)kmem, PAGE_SIZE) != PAGE_SIZE,
+		    "illegal kernel __clear_user passed");
 #endif
 
 	/*
@@ -148,6 +156,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate kernel get_user failed");
 	ret |= test(put_user(value, (unsigned long __user *)kmem),
 		    "legitimate kernel put_user failed");
+	ret |= test(clear_user((char __user *)kmem, PAGE_SIZE) != 0,
+		    "legitimate kernel clear_user failed");
 
 	ret |= test(!access_ok(VERIFY_READ, (char __user *)kmem, PAGE_SIZE * 2),
 		    "legitimate kernel access_ok VERIFY_READ failed");
@@ -164,6 +174,8 @@ static int __init test_user_copy_init(vo
 		    "legitimate kernel __get_user failed");
 	ret |= test(__put_user(value, (unsigned long __user *)kmem),
 		    "legitimate kernel __put_user failed");
+	ret |= test(__clear_user((char __user *)kmem, PAGE_SIZE) != 0,
+		    "legitimate kernel __clear_user failed");
 
 	/* Restore previous address limit. */
 	set_fs(fs);
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

test_user_copy-check-__copy_in_user-copy_in_user.patch
test_user_copy-check-__copy_tofrom_user_inatomic.patch
test_user_copy-check-user-string-accessors.patch
test_user_copy-check-user-checksum-functions.patch
linux-next.patch

