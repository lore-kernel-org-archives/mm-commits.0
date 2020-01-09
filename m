From: akpm@linux-foundation.org
Subject: [alternative-merged]
 bitops-more-bits_to_-macros-fix.patch removed from -mm tree
Date: Thu, 09 Jan 2020 13:50:25 -0800
Message-ID: <20200109215025.nOIfdAJ1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIVu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, akpm@linux-foundation.org, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: bitops-more-bits_to_-macros-fix
has been removed from the -mm tree.  Its filename was
     bitops-more-bits_to_-macros-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitops-more-bits_to_-macros-fix

remove ocfs2's private BITS_PER_BYTE()

Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ocfs2/dlm/dlmcommon.h~bitops-more-bits_to_-macros-fix
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -11,6 +11,7 @@
 #define DLMCOMMON_H
 
 #include <linux/kref.h>
+#include <linux/bitops.h>
 
 #define DLM_HB_NODE_DOWN_PRI     (0xf000000)
 #define DLM_HB_NODE_UP_PRI       (0x8000000)
@@ -689,9 +690,6 @@ struct dlm_begin_reco
 };
 
 
-#define BITS_PER_BYTE 8
-#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
