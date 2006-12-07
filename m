From: akpm@osdl.org
Subject: - mm-cleanup-indentation-on-switch-for-cpu-operations.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:59 -0800
Message-ID: <200612072257.kB7MvxiW029344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163653AbWLGW6d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: cleanup indentation on switch for CPU operations
has been removed from the -mm tree.  Its filename was
     mm-cleanup-indentation-on-switch-for-cpu-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: cleanup indentation on switch for CPU operations
From: Andy Whitcroft <apw@shadowen.org>

These patches introduced new switch statements which are indented contrary
to the concensus in mm/*.c.  Fix them up to match that concensus.

    [PATCH] node local per-cpu-pages
    [PATCH] ZVC: Scale thresholds depending on the size of the system
    commit e7c8d5c9955a4d2e88e36b640563f5d6d5aba48a
    commit df9ecaba3f152d1ea79f2a5e0b87505e03f47590

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |   20 ++++++++++----------
 mm/vmstat.c     |   14 +++++++-------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~mm-cleanup-indentation-on-switch-for-cpu-operations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cleanup-indentation-on-switch-for-cpu-operations
+++ a/mm/page_alloc.c
@@ -2042,16 +2042,16 @@ static int __cpuinit pageset_cpuup_callb
 	int ret = NOTIFY_OK;
 
 	switch (action) {
-		case CPU_UP_PREPARE:
-			if (process_zones(cpu))
-				ret = NOTIFY_BAD;
-			break;
-		case CPU_UP_CANCELED:
-		case CPU_DEAD:
-			free_zone_pagesets(cpu);
-			break;
-		default:
-			break;
+	case CPU_UP_PREPARE:
+		if (process_zones(cpu))
+			ret = NOTIFY_BAD;
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		free_zone_pagesets(cpu);
+		break;
+	default:
+		break;
 	}
 	return ret;
 }
diff -puN mm/vmstat.c~mm-cleanup-indentation-on-switch-for-cpu-operations mm/vmstat.c
--- a/mm/vmstat.c~mm-cleanup-indentation-on-switch-for-cpu-operations
+++ a/mm/vmstat.c
@@ -679,13 +679,13 @@ static int __cpuinit vmstat_cpuup_callba
 		void *hcpu)
 {
 	switch (action) {
-		case CPU_UP_PREPARE:
-		case CPU_UP_CANCELED:
-		case CPU_DEAD:
-			refresh_zone_stat_thresholds();
-			break;
-		default:
-			break;
+	case CPU_UP_PREPARE:
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		refresh_zone_stat_thresholds();
+		break;
+	default:
+		break;
 	}
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

