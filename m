From: akpm@linux-foundation.org
Subject: + compilerh-fix-c-uninitialized-const-issue.patch added to -mm
 tree
Date: Tue, 28 Feb 2017 17:06:10 -0800
Message-ID: <58b61e82.b0lNRjl0P/vsjPa3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdCACBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 21:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joakim.tjernlund@infinera.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler.h: fix C++ uninitialized const issue
has been added to the -mm tree.  Its filename is
     compilerh-fix-c-uninitialized-const-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compilerh-fix-c-uninitialized-const-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compilerh-fix-c-uninitialized-const-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: include/linux/compiler.h: fix C++ uninitialized const issue

C++ does not like the union { typeof(x) __val; char __c[1]; } __u
construct for const types:
 error: uninitialized const member in
 'union atomic_read(const atomic_t*)::<anonymous>'
Address this by creating a C++ version of READ_ONCE where this union is
initialized: union { void _u(){}; typeof(x) __val; char __c[1]; } __u={0}

To please gcc 6.3.0 also add in a _u(){} as default ctor.

This makes C++ happy enough to build.

Link: http://lkml.kernel.org/r/20170221151044.5499-2-joakim.tjernlund@infinera.com
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN include/linux/compiler.h~compilerh-fix-c-uninitialized-const-issue include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-fix-c-uninitialized-const-issue
+++ a/include/linux/compiler.h
@@ -311,6 +311,7 @@ static __always_inline void __write_once
  * required ordering.
  */
 
+#ifndef __cplusplus
 #define __READ_ONCE(x, check)						\
 ({									\
 	union { typeof(x) __val; char __c[1]; } __u;			\
@@ -320,6 +321,17 @@ static __always_inline void __write_once
 		__read_once_size_nocheck(&(x), __u.__c, sizeof(x));	\
 	__u.__val;							\
 })
+#else
+#define __READ_ONCE(x, check)						\
+({									\
+	union { void _u(){}; typeof(x) __val; char __c[1]; } __u={0};	\
+	if (check)							\
+		__read_once_size(&(x), __u.__c, sizeof(x));		\
+	else								\
+		__read_once_size_nocheck(&(x), __u.__c, sizeof(x));	\
+	__u.__val;							\
+})
+#endif
 #define READ_ONCE(x) __READ_ONCE(x, 1)
 
 /*
_

Patches currently in -mm which might be from joakim.tjernlund@infinera.com are

correct-function-definition-for-c.patch
compilerh-fix-c-uninitialized-const-issue.patch

