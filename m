From: akpm@linux-foundation.org
Subject: + add-unitialized_var-macro-for-suppressing-gcc-warnings.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:17:59 -0700
Message-ID: <200704290917.l3T9HxnS012736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbXD2JSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de


The patch titled
     Add unitialized_var() macro for suppressing gcc warnings
has been added to the -mm tree.  Its filename is
     add-unitialized_var-macro-for-suppressing-gcc-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add unitialized_var() macro for suppressing gcc warnings
From: Borislav Petkov <bbpetkov@yahoo.de>

Introduce a macro for suppressing gcc from generating a warning about a
probable uninitialized state of a variable.

Not a happy solution, but those warnings are obnoxious.

- Using the usual pointlessly-set-it-to-zero approach wastes several
  bytes of text.

- Using a macro means we can (hopefully) do something else if gcc changes
  cause the `x = x' hack to stop working

- Using a macro means that people who are worried about hiding true bugs
  can easily turn it off.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/compiler.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler.h
--- a/include/linux/compiler.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler.h
@@ -74,6 +74,8 @@ extern void __chk_io_ptr(const void __io
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define uninitialized_var(x) x = x
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
git-acpi.patch
add-unitialized_var-macro-for-suppressing-gcc-warnings.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kill-warnings-when-building-mandocs.patch
