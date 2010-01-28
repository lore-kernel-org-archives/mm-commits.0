From: akpm@linux-foundation.org
Subject: + oprofile-x86-fix-crash-when-profiling-more-than-28-events.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:05:01 -0800
Message-ID: <201001280005.o0S051ls008365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166Ab0A1AG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:06:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suravee.suthikulpanit@amd.com, mingo@elte.hu, robert.richter@amd.com, stable@kernel.org


The patch titled
     oprofile/x86: fix crash when profiling more than 28 events
has been added to the -mm tree.  Its filename is
     oprofile-x86-fix-crash-when-profiling-more-than-28-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

oprofile-x86-fix-crash-when-profiling-more-than-28-events.patch

