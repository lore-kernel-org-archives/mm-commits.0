From: akpm@linux-foundation.org
Subject: + test_user_copy-check-legit-kernel-accesses.patch added to -mm
 tree
Date: Wed, 05 Aug 2015 12:59:00 -0700
Message-ID: <55c26b04.I89y2j72abyv6D13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbHET7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_user_copy.c: check legit kernel accesses
has been added to the -mm tree.  Its filename is
     test_user_copy-check-legit-kernel-accesses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_user_copy-check-legit-kernel-accesses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_user_copy-check-legit-kernel-accesses.patch

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
Subject: lib/test_user_copy.c: check legit kernel accesses

These patches extend the test_user_copy test module to handle lots more
cases of user accessors which architectures can override separately, and
in particular those which are important for checking the MIPS Enhanced
Virtual Addressing (EVA) implementations, which need to handle
overlapping user and kernel address spaces, with special instructions
for accessing user address space from kernel mode.

- Checking that kernel pointers are accepted when user address limit is
  set to KERNEL_DS, as done by the kernel when it internally invokes
  system calls with kernel pointers.
- Checking of the unchecked accessors (which don't call access_ok()).
  Some of the tests are special cased for EVA at the moment which has
  stricter hardware guarantees for bad user accesses than other
  configurations.
- Checking of other sets of user accessors, including the inatomic user
  copies, copy_in_user, clear_user, the user string accessors, and the
  user checksum functions, all of which need special handling in arch
  code with EVA.

Tested on MIPS with and without EVA, and on x86_64.



This patch (of 7):

Check that the use of the user accessors for accessing kernel memory
succeed as expected after set_fs(get_ds()) is used to increases the
address limit, as used by the kernel to directly invoke system call code
with kernel pointers.

The tests are basically the same as the tests normally expected to be
treated as invalid, but without any user addresses (no reversed copies),
and with the result inverted such that they should succeed instead.

New tests:
- legitimate all-kernel copy_from_user
- legitimate all-kernel copy_to_user
- legitimate kernel get_user
- legitimate kernel put_user

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_user_copy.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN lib/test_user_copy.c~test_user_copy-check-legit-kernel-accesses lib/test_user_copy.c
--- a/lib/test_user_copy.c~test_user_copy-check-legit-kernel-accesses
+++ a/lib/test_user_copy.c
@@ -41,6 +41,7 @@ static int __init test_user_copy_init(vo
 	char *bad_usermem;
 	unsigned long user_addr;
 	unsigned long value = 0x5A;
+	mm_segment_t fs = get_fs();
 
 	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
 	if (!kmem)
@@ -86,6 +87,28 @@ static int __init test_user_copy_init(vo
 	ret |= test(!put_user(value, (unsigned long __user *)kmem),
 		    "illegal put_user passed");
 
+	/*
+	 * Test access to kernel memory by adjusting address limit.
+	 * This is used by the kernel to invoke system calls with kernel
+	 * pointers.
+	 */
+	set_fs(get_ds());
+
+	/* Legitimate usage: none of these should fail. */
+	ret |= test(copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				   PAGE_SIZE),
+		    "legitimate all-kernel copy_from_user failed");
+	ret |= test(copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				 PAGE_SIZE),
+		    "legitimate all-kernel copy_to_user failed");
+	ret |= test(get_user(value, (unsigned long __user *)kmem),
+		    "legitimate kernel get_user failed");
+	ret |= test(put_user(value, (unsigned long __user *)kmem),
+		    "legitimate kernel put_user failed");
+
+	/* Restore previous address limit. */
+	set_fs(fs);
+
 	vm_munmap(user_addr, PAGE_SIZE * 2);
 	kfree(kmem);
 
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

