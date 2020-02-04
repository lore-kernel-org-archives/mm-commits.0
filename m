From: akpm@linux-foundation.org
Subject: [merged]
 cpumask-dont-calculate-length-of-the-input-string.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:42:35 -0800
Message-ID: <20200204184235.MnqFmqcwY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbgBDSmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: include/linux/cpumask.h: don't calculate length of the input string
has been removed from the -mm tree.  Its filename was
     cpumask-dont-calculate-length-of-the-input-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: include/linux/cpumask.h: don't calculate length of the input string

New design of inner bitmap_parse() allows to avoid calculating the size of
a null-terminated string.

Link: http://lkml.kernel.org/r/20200102043031.30357-8-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/cpumask.h~cpumask-dont-calculate-length-of-the-input-string
+++ a/include/linux/cpumask.h
@@ -663,9 +663,7 @@ static inline int cpumask_parselist_user
  */
 static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
 {
-	unsigned int len = strchrnul(buf, '\n') - buf;
