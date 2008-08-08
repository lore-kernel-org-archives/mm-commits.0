From: akpm@linux-foundation.org
Subject: + ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch added to -mm tree
Date: Thu, 07 Aug 2008 23:08:19 -0700
Message-ID: <200808080608.m7868JpE025825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYHHGIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 02:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, tony.luck@intel.com


The patch titled
     ia64 UV: use blinking LED for heartbeat display fix
has been added to the -mm tree.  Its filename is
     ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64 UV: use blinking LED for heartbeat display fix
From: Mike Travis <travis@sgi.com>

  Fix error not caught on initial build test.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/uv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/uv/kernel/setup.c~ia64-uv-use-blinking-led-for-heartbeat-display-fix arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c~ia64-uv-use-blinking-led-for-heartbeat-display-fix
+++ a/arch/ia64/uv/kernel/setup.c
@@ -71,7 +71,7 @@ static void uv_display_heartbeat(void)
 {
 	int cpu;
 
-	uv_hub_info->uv_heartbeat = nr_cpu_ids;
+	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
 
 	for_each_online_cpu(cpu) {
 		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
switch-proc-irq-smp_affinity-et-al-to-seqfiles.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
x86_64-uv-provide-a-led-driver-for-uv-systems.patch
x86_64-uv-use-led-to-indicate-cpu-is-active.patch
x86_64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-provide-a-led-driver-for-uv-systems.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch

