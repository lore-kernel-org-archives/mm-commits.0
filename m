From: akpm@linux-foundation.org
Subject: [merged] perf-x86-fix-undefined-reference-to-get_ibs_caps.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:17 -0700
Message-ID: <20120516184717.44AEAA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32966 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab2EPSrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:18 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so126689qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.richter@amd.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: perf, x86: Fix undefined reference to `get_ibs_caps'
has been removed from the -mm tree.  Its filename was
     perf-x86-fix-undefined-reference-to-get_ibs_caps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from robert.richter@amd.com are

linux-next.patch

