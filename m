From: akpm@linux-foundation.org
Subject: +
 kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 13:14:52 -0800
Message-ID: <528a834c.CQL7JpOm6P5FdrCM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRVOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 16:14:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, kirill.shutemov@linux.intel.com

Subject: + kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 13:14:52 -0800


The patch titled
     Subject: kernel/bounds: avoid circular dependencies in generated headers
has been added to the -mm tree.  Its filename is
     kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: kernel/bounds: avoid circular dependencies in generated headers

<linux/spinlock.h> has havy dependencies on other header files.
It trigger circular dependencies in generated headers on IA64, at least:

  CC      kernel/bounds.s
In file included from arch/ia64/include/asm/thread_info.h:9:0,
                 from include/linux/thread_info.h:54,
                 from include/asm-generic/preempt.h:4,
                 from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
arch/ia64/include/asm/asm-offsets.h:1:35: fatal error: generated/asm-offsets.h: No such file or directory
compilation terminated.

Let's replace <linux/spinlock.h> with <linux/spinlock_types.h>, it's
enough to find out size of spinlock_t.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bounds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/bounds.c~kernel-bounds-avoid-circular-dependencies-in-generated-headers kernel/bounds.c
--- a/kernel/bounds.c~kernel-bounds-avoid-circular-dependencies-in-generated-headers
+++ a/kernel/bounds.c
@@ -11,7 +11,7 @@
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
 #include <linux/log2.h>
-#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
 
 void foo(void)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
kernel-bounds-avoid-circular-dependencies-in-generated-headers.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch

