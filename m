From: akpm@linux-foundation.org
Subject: + test_user_copy-check-unchecked-accessors.patch added to -mm
 tree
Date: Wed, 05 Aug 2015 12:59:02 -0700
Message-ID: <55c26b06.DjILFEPPFvHH7w7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbHET7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check unchecked accessors
has been added to the -mm tree.  Its filename is
     test_user_copy-check-unchecked-accessors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_user_copy-check-unchecked-accessors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_user_copy-check-unchecked-accessors.patch

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
Subject: lib/test_user_copy.c: check unchecked accessors

Currently the test_user_copy module only tests the user accessors which
already check the address with access_ok().  Corresponding unchecked
accessors exist however which may be used after access_ok() is checked. 
Since the addresses the test uses are known to be valid kernel addresses,
test these unchecked accessors too, as well as access_ok() itself.

For legitimate user accesses we test the corresponding unchecked macros. 
They should all work just as well as the checking versions.

Similarly, for legitimate kernel accesses the unchecked macros are
expected to succeed, and access kernel rather than user memory.

For invalid user accesses we only test the corresponding unchecked macros
in configurations where the behaviour is both known and important to
verify the implementation.  Currently this is only enabled for MIPS with
Enhanced Virtual Addressing (EVA) enabled, where user accesses MUST use
the EVA loads/stores, which can only access valid user mode memory anyway.

New tests:
- legitimate access_ok VERIFY_READ
- legitimate access_ok VERIFY_WRITE
- legitimate __copy_from_user
- legitimate __copy_to_user
- legitimate __get_user
- legitimate __put_user
- illegal all-kernel __copy_from_user
- illegal reversed __copy_from_user
- illegal all-kernel __copy_to_user
- illegal reversed __copy_to_user
- illegal __get_user
- illegal __put_user
- legitimate kernel access_ok VERIFY_READ
- legitimate kernel access_ok VERIFY_WRITE
- legitimate all-kernel __copy_from_user
- legitimate all-kernel __copy_to_user
- legitimate kernel __get_user
- legitimate kernel __put_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-unchecked-accessors lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-unchecked-accessors
+++ a/lib/test_user_copy.c
@@ -69,6 +69,19 @@ static int __init test_user_copy_init(vo
 	ret |= test(put_user(value, (unsigned long __user *)usermem),
 		    "legitimate put_user failed");
 
+	ret |= test(!access_ok(VERIFY_READ, usermem, PAGE_SIZE * 2),
+		    "legitimate access_ok VERIFY_READ failed");
+	ret |= test(!access_ok(VERIFY_WRITE, usermem, PAGE_SIZE * 2),
+		    "legitimate access_ok VERIFY_WRITE failed");
+	ret |= test(__copy_from_user(kmem, usermem, PAGE_SIZE),
+		    "legitimate __copy_from_user failed");
+	ret |= test(__copy_to_user(usermem, kmem, PAGE_SIZE),
+		    "legitimate __copy_to_user failed");
+	ret |= test(__get_user(value, (unsigned long __user *)usermem),
+		    "legitimate __get_user failed");
+	ret |= test(__put_user(value, (unsigned long __user *)usermem),
+		    "legitimate __put_user failed");
+
 	/* Invalid usage: none of these should succeed. */
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
 				    PAGE_SIZE),
@@ -88,6 +101,36 @@ static int __init test_user_copy_init(vo
 		    "illegal put_user passed");
 
 	/*
+	 * If unchecked user accesses (__*) on this architecture cannot access
+	 * kernel mode (i.e. access_ok() is redundant), and usually faults when
+	 * attempted, check this behaviour.
+	 *
+	 * These tests are enabled for:
+	 * - MIPS with Enhanced Virtual Addressing (EVA): user accesses use EVA
+	 *   instructions which can only access user mode accessible memory. It
+	 *   is assumed to be unlikely that user address space mappings will
+	 *   intersect the kernel buffer address.
+	 */
+#if defined(CONFIG_MIPS) && defined(CONFIG_EVA)
+	ret |= test(!__copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				      PAGE_SIZE),
+		    "illegal all-kernel __copy_from_user passed");
+	ret |= test(!__copy_from_user(bad_usermem, (char __user *)kmem,
+				      PAGE_SIZE),
+		    "illegal reversed __copy_from_user passed");
+	ret |= test(!__copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				    PAGE_SIZE),
+		    "illegal all-kernel __copy_to_user passed");
+	ret |= test(!__copy_to_user((char __user *)kmem, bad_usermem,
+				    PAGE_SIZE),
+		    "illegal reversed __copy_to_user passed");
+	ret |= test(!__get_user(value, (unsigned long __user *)kmem),
+		    "illegal __get_user passed");
+	ret |= test(!__put_user(value, (unsigned long __user *)kmem),
+		    "illegal __put_user passed");
+#endif
+
+	/*
 	 * Test access to kernel memory by adjusting address limit.
 	 * This is used by the kernel to invoke system calls with kernel
 	 * pointers.
@@ -106,6 +149,22 @@ static int __init test_user_copy_init(vo
 	ret |= test(put_user(value, (unsigned long __user *)kmem),
 		    "legitimate kernel put_user failed");
 
+	ret |= test(!access_ok(VERIFY_READ, (char __user *)kmem, PAGE_SIZE * 2),
+		    "legitimate kernel access_ok VERIFY_READ failed");
+	ret |= test(!access_ok(VERIFY_WRITE, (char __user *)kmem,
+			       PAGE_SIZE * 2),
+		    "legitimate kernel access_ok VERIFY_WRITE failed");
+	ret |= test(__copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				     PAGE_SIZE),
+		    "legitimate all-kernel __copy_from_user failed");
+	ret |= test(__copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				   PAGE_SIZE),
+		    "legitimate all-kernel __copy_to_user failed");
+	ret |= test(__get_user(value, (unsigned long __user *)kmem),
+		    "legitimate kernel __get_user failed");
+	ret |= test(__put_user(value, (unsigned long __user *)kmem),
+		    "legitimate kernel __put_user failed");
+
 	/* Restore previous address limit. */
 	set_fs(fs);
 
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

