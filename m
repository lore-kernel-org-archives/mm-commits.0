From: akpm@linux-foundation.org
Subject: - ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch removed from -mm tree
Date: Mon, 22 Sep 2008 14:43:06 -0700
Message-ID: <200809222143.m8MLh688031403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbYIVVnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 17:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 UV: use blinking LED for heartbeat display fix
has been removed from the -mm tree.  Its filename was
     ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch

This patch was dropped because it was folded into ia64-uv-use-blinking-led-for-heartbeat-display.patch

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
ia64-uv-provide-a-led-driver-for-uv-systems.patch
ia64-uv-use-led-to-indicate-cpu-is-active.patch
ia64-uv-use-blinking-led-for-heartbeat-display.patch
ia64-uv-use-blinking-led-for-heartbeat-display-fix.patch
cpuset-use-seq_cpumask-seq_nodemask.patch

