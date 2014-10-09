From: akpm@linux-foundation.org
Subject: [folded-merged] vmstat-on-demand-vmstat-workers-v8-fix.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:45:58 -0700
Message-ID: <5436f406.d99g8ZNBL0rSDOlG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJIUp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu_stat_off can be static
has been removed from the -mm tree.  Its filename was
     vmstat-on-demand-vmstat-workers-v8-fix.patch

This patch was dropped because it was folded into vmstat-on-demand-vmstat-workers-v8.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: cpu_stat_off can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix
+++ a/mm/vmstat.c
@@ -1255,7 +1255,7 @@ static const struct file_operations proc
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-struct cpumask *cpu_stat_off;
+static struct cpumask *cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
vmstat-on-demand-vmstat-workers-v8.patch
frv-remove-unused-cpuinfo_frv-and-friends-to-fix-future-build-error.patch

