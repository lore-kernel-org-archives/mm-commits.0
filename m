From: akpm@linux-foundation.org
Subject: + update-__copy_to_user_inatomic.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:36 -0800
Message-ID: <200702272058.l1RKweOJ028397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXB0U6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@gmail.com


The patch titled
     Update  __copy_to_user_inatomic documentation
has been added to the -mm tree.  Its filename is
     update-__copy_to_user_inatomic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update  __copy_to_user_inatomic documentation
From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>

Explicity specify that the caller should pin the user memory otherwise the
function will sleep

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/uaccess.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/uaccess.h~update-__copy_to_user_inatomic include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~update-__copy_to_user_inatomic
+++ a/include/asm-i386/uaccess.h
@@ -397,7 +397,19 @@ unsigned long __must_check __copy_from_u
 unsigned long __must_check __copy_from_user_ll_nocache_nozero(void *to,
 				const void __user *from, unsigned long n);
 
-/*
+/**
+ * __copy_to_user_inatomic: - Copy a block of data into user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @from: Source address, in kernel space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.
+ *
+ * Copy data from kernel space to user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ * The caller should also make sure he pins the user space address
+ * so that the we don't result in page fault and sleep.
+ *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.
  * If a store crosses a page boundary and gets a fault, the x86 will not write
_

Patches currently in -mm which might be from aneesh.kumar@gmail.com are

update-__copy_to_user_inatomic.patch
