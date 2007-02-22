From: akpm@linux-foundation.org
Subject: + x86_64-wire-up-compat-sched_rr_get_interval2.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:10:44 -0800
Message-ID: <200702220110.l1M1Ai0C032473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60822 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbXBVBKt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:10:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aandreev@openvz.org, adobriyan@openvz.org, ak@suse.de


The patch titled
     x86_64: wire up compat sched_rr_get_interval(2)
has been added to the -mm tree.  Its filename is
     x86_64-wire-up-compat-sched_rr_get_interval2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: wire up compat sched_rr_get_interval(2)
From: Alexandr Andreev <aandreev@openvz.org>

sys32_sched_rr_get_interval() uses compat_timespec but wasn't used itself.

Signed-off-by: Alexandr Andreev <aandreev@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/ia32/ia32entry.S~x86_64-wire-up-compat-sched_rr_get_interval2 arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~x86_64-wire-up-compat-sched_rr_get_interval2
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -560,7 +560,7 @@ ia32_sys_call_table:
 	.quad sys_sched_yield
 	.quad sys_sched_get_priority_max
 	.quad sys_sched_get_priority_min  /* 160 */
-	.quad sys_sched_rr_get_interval
+	.quad sys32_sched_rr_get_interval
 	.quad compat_sys_nanosleep
 	.quad sys_mremap
 	.quad sys_setresuid16
_

Patches currently in -mm which might be from aandreev@openvz.org are

ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
