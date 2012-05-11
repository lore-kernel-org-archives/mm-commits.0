From: akpm@linux-foundation.org
Subject: + perf-x86-fix-undefined-reference-to-get_ibs_caps.patch added to -mm tree
Date: Fri, 11 May 2012 15:49:37 -0700
Message-ID: <20120511224937.BFA81A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52980 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2EKWtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 18:49:39 -0400
Received: by yenl3 with SMTP id l3so393391yen.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 15:49:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.richter@amd.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org


The patch titled
     Subject: perf, x86: Fix undefined reference to `get_ibs_caps'
has been added to the -mm tree.  Its filename is
     perf-x86-fix-undefined-reference-to-get_ibs_caps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robert Richter <robert.richter@amd.com>
Subject: perf, x86: Fix undefined reference to `get_ibs_caps'

Fixing i386 allnoconfig build errors:

 arch/x86/built-in.o: In function `amd_pmu_hw_config':
 perf_event_amd.c:(.text+0xc3e1): undefined reference to `get_ibs_caps'

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/perf_event.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/include/asm/perf_event.h~perf-x86-fix-undefined-reference-to-get_ibs_caps arch/x86/include/asm/perf_event.h
--- a/arch/x86/include/asm/perf_event.h~perf-x86-fix-undefined-reference-to-get_ibs_caps
+++ a/arch/x86/include/asm/perf_event.h
@@ -188,7 +188,11 @@ struct x86_pmu_capability {
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 #define IBS_RIP_INVALID		(1ULL<<38)
 
+#ifdef CONFIG_X86_LOCAL_APIC
 extern u32 get_ibs_caps(void);
+#else
+static inline u32 get_ibs_caps(void) { return 0; }
+#endif
 
 #ifdef CONFIG_PERF_EVENTS
 extern void perf_events_lapic_init(void);
_
Subject: Subject: perf, x86: Fix undefined reference to `get_ibs_caps'

Patches currently in -mm which might be from robert.richter@amd.com are

linux-next.patch
perf-x86-fix-undefined-reference-to-get_ibs_caps.patch

