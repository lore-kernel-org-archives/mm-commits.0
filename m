From: akpm@linux-foundation.org
Subject: [patch 6/6] sparse doesn't support struct randomization
Date: Thu, 18 Jan 2018 16:34:08 -0800
Message-ID: <5a613d00.2mp2JGcolhB/Hj7b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755230AbeASAeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 19:34:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: sparse doesn't support struct randomization

Without this patch, I drown in a sea of unknown attribute warnings

Link: http://lkml.kernel.org/r/20180117024539.27354-1-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~sparse-doesnt-support-struct-randomization include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~sparse-doesnt-support-struct-randomization
+++ a/include/linux/compiler-gcc.h
@@ -219,7 +219,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
 
-#ifdef RANDSTRUCT_PLUGIN
+#if defined(RANDSTRUCT_PLUGIN) && !defined(__CHECKER__)
 #define __randomize_layout __attribute__((randomize_layout))
 #define __no_randomize_layout __attribute__((no_randomize_layout))
 #endif
_
