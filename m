From: akpm@linux-foundation.org
Subject: [merged]
 frv-declare-jiffies-to-be-located-in-the-data-section.patch removed from
 -mm tree
Date: Mon, 05 Jun 2017 12:02:40 -0700
Message-ID: <20170605190240.cb07UWfLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFETCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 15:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux@roeck-us.net, mka@chromium.org, mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com


The patch titled
     Subject: frv: declare jiffies to be located in the .data section
has been removed from the -mm tree.  Its filename was
     frv-declare-jiffies-to-be-located-in-the-data-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: frv: declare jiffies to be located in the .data section

7c30f352c852 ("jiffies.h: declare jiffies and jiffies_64 with
____cacheline_aligned_in_smp") removed a section specification from the
jiffies declaration that caused conflicts on some platforms. 
Unfortunately this change broke the build for frv:

kernel/built-in.o: In function `__do_softirq':
(.text+0x6460): relocation truncated to fit: R_FRV_GPREL12 against symbol
    `jiffies' defined in *ABS* section in .tmp_vmlinux1
kernel/built-in.o: In function `__do_softirq':
(.text+0x6574): relocation truncated to fit: R_FRV_GPREL12 against symbol
    `jiffies' defined in *ABS* section in .tmp_vmlinux1
kernel/built-in.o: In function `pwq_activate_delayed_work':
workqueue.c:(.text+0x15b9c): relocation truncated to fit: R_FRV_GPREL12 against
    symbol `jiffies' defined in *ABS* section in .tmp_vmlinux1
...

Add __jiffy_arch_data to the declaration of jiffies and use it on frv to
include the section specification.  For all other platforms
__jiffy_arch_data (currently) has no effect.

Fixes: 7c30f352c852 ("jiffies.h: declare jiffies and jiffies_64 with ____cacheline_aligned_in_smp")
Link: http://lkml.kernel.org/r/20170516221333.177280-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/timex.h |    6 ++++++
 include/linux/jiffies.h      |    6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/frv/include/asm/timex.h~frv-declare-jiffies-to-be-located-in-the-data-section arch/frv/include/asm/timex.h
--- a/arch/frv/include/asm/timex.h~frv-declare-jiffies-to-be-located-in-the-data-section
+++ a/arch/frv/include/asm/timex.h
@@ -16,5 +16,11 @@ static inline cycles_t get_cycles(void)
 #define vxtime_lock()		do {} while (0)
 #define vxtime_unlock()		do {} while (0)
 
+/* This attribute is used in include/linux/jiffies.h alongside with
+ * __cacheline_aligned_in_smp. It is assumed that __cacheline_aligned_in_smp
+ * for frv does not contain another section specification.
+ */
+#define __jiffy_arch_data	__attribute__((__section__(".data")))
+
 #endif
 
diff -puN include/linux/jiffies.h~frv-declare-jiffies-to-be-located-in-the-data-section include/linux/jiffies.h
--- a/include/linux/jiffies.h~frv-declare-jiffies-to-be-located-in-the-data-section
+++ a/include/linux/jiffies.h
@@ -64,13 +64,17 @@ extern int register_refined_jiffies(long
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
 
+#ifndef __jiffy_arch_data
+#define __jiffy_arch_data
+#endif
+
 /*
  * The 64-bit value is not atomic - you MUST NOT read it
  * without sampling the sequence number in jiffies_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
 extern u64 __cacheline_aligned_in_smp jiffies_64;
-extern unsigned long volatile __cacheline_aligned_in_smp jiffies;
+extern unsigned long volatile __cacheline_aligned_in_smp __jiffy_arch_data jiffies;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void);
_

Patches currently in -mm which might be from mka@chromium.org are

mm-page_alloc-mark-bad_range-and-meminit_pfn_in_nid-as-__maybe_unused.patch

