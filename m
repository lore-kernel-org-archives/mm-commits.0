From: akpm@linux-foundation.org
Subject: + tools-add-warn_on_once.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:50:10 -0800
Message-ID: <58472482.28z0Uv707PzHxPo8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUtk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: add WARN_ON_ONCE
has been added to the -mm tree.  Its filename is
     tools-add-warn_on_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-add-warn_on_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-add-warn_on_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: tools: add WARN_ON_ONCE

Patch series "Radix tree patches for 4.10", v3.

Mostly these are improvements; the only bug fixes in here relate to
multiorder entries (which are unused in the 4.9 tree).


This patch (of 32):

The radix tree uses its own buggy WARN_ON_ONCE.  Replace it with the
definition from asm-generic/bug.h

Link: http://lkml.kernel.org/r/1480369871-5271-37-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/asm/bug.h                |   11 +++++++++++
 tools/testing/radix-tree/Makefile      |    2 +-
 tools/testing/radix-tree/linux/bug.h   |    2 +-
 tools/testing/radix-tree/linux/types.h |    2 --
 4 files changed, 13 insertions(+), 4 deletions(-)

diff -puN tools/include/asm/bug.h~tools-add-warn_on_once tools/include/asm/bug.h
--- a/tools/include/asm/bug.h~tools-add-warn_on_once
+++ a/tools/include/asm/bug.h
@@ -12,6 +12,17 @@
 	unlikely(__ret_warn_on);		\
 })
 
+#define WARN_ON_ONCE(condition) ({			\
+	static int __warned;				\
+	int __ret_warn_once = !!(condition);		\
+							\
+	if (unlikely(__ret_warn_once && !__warned)) {	\
+		__warned = true;			\
+		WARN_ON(1);				\
+	}						\
+	unlikely(__ret_warn_once);			\
+})
+
 #define WARN_ONCE(condition, format...)	({	\
 	static int __warned;			\
 	int __ret_warn_once = !!(condition);	\
diff -puN tools/testing/radix-tree/Makefile~tools-add-warn_on_once tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~tools-add-warn_on_once
+++ a/tools/testing/radix-tree/Makefile
@@ -1,5 +1,5 @@
 
-CFLAGS += -I. -g -O2 -Wall -D_LGPL_SOURCE
+CFLAGS += -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE
 LDFLAGS += -lpthread -lurcu
 TARGETS = main
 OFILES = main.o radix-tree.o linux.o test.o tag_check.o find_next_bit.o \
diff -puN tools/testing/radix-tree/linux/bug.h~tools-add-warn_on_once tools/testing/radix-tree/linux/bug.h
--- a/tools/testing/radix-tree/linux/bug.h~tools-add-warn_on_once
+++ a/tools/testing/radix-tree/linux/bug.h
@@ -1 +1 @@
-#define WARN_ON_ONCE(x)		assert(x)
+#include "asm/bug.h"
diff -puN tools/testing/radix-tree/linux/types.h~tools-add-warn_on_once tools/testing/radix-tree/linux/types.h
--- a/tools/testing/radix-tree/linux/types.h~tools-add-warn_on_once
+++ a/tools/testing/radix-tree/linux/types.h
@@ -6,8 +6,6 @@
 #define __rcu
 #define __read_mostly
 
-#define BITS_PER_LONG (sizeof(long) * 8)
