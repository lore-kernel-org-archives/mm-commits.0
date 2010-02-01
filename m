From: akpm@linux-foundation.org
Subject: [merged] oprofile-x86-fix-crash-when-profiling-more-than-28-events.patch removed from -mm tree
Date: Mon, 01 Feb 2010 10:38:52 -0800
Message-ID: <201002011838.o11IcqJG004878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576Ab0BASji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 13:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suravee.suthikulpanit@amd.com, mingo@elte.hu, robert.richter@amd.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oprofile/x86: fix crash when profiling more than 28 events
has been removed from the -mm tree.  Its filename was
     oprofile-x86-fix-crash-when-profiling-more-than-28-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oprofile/x86: fix crash when profiling more than 28 events
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

With multiplexing enabled oprofile crashs when profiling more than 28
events.  This patch fixes this.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/oprofile/nmi_int.c~oprofile-x86-fix-crash-when-profiling-more-than-28-events arch/x86/oprofile/nmi_int.c
--- a/arch/x86/oprofile/nmi_int.c~oprofile-x86-fix-crash-when-profiling-more-than-28-events
+++ a/arch/x86/oprofile/nmi_int.c
@@ -222,7 +222,7 @@ static void nmi_cpu_switch(void *dummy)
 
 	/* move to next set */
 	si += model->num_counters;
-	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+	if ((si >= model->num_virt_counters) || (counter_config[si].count == 0))
 		per_cpu(switch_index, cpu) = 0;
 	else
 		per_cpu(switch_index, cpu) = si;
_

Patches currently in -mm which might be from suravee.suthikulpanit@amd.com are

linux-next.patch

