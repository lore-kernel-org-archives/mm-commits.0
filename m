From: akpm@linux-foundation.org
Subject: - lockstat-better-class-name-representation.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:54 -0700
Message-ID: <200707192003.l6JK3sE8019899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761512AbXGSUSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockstat: better class name representation
has been removed from the -mm tree.  Its filename was
     lockstat-better-class-name-representation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockstat: better class name representation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

optionally add class->name_version and class->subclass to the class name

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN kernel/lockdep_proc.c~lockstat-better-class-name-representation kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockstat-better-class-name-representation
+++ a/kernel/lockdep_proc.c
@@ -421,8 +421,30 @@ static void seq_stats(struct seq_file *m
 	class = data->class;
 	stats = &data->stats;
 
-	snprintf(name, 38, "%s", class->name);
+	namelen = 38;
+	if (class->name_version > 1)
+		namelen -= 2; /* XXX truncates versions > 9 */
+	if (class->subclass)
+		namelen -= 2;
+
+	if (!class->name) {
+		char str[KSYM_NAME_LEN];
+		const char *key_name;
+
+		key_name = __get_key_name(class->key, str);
+		snprintf(name, namelen, "%s", key_name);
+	} else {
+		snprintf(name, namelen, "%s", class->name);
+	}
 	namelen = strlen(name);
+	if (class->name_version > 1) {
+		snprintf(name+namelen, 3, "#%d", class->name_version);
+		namelen += 2;
+	}
+	if (class->subclass) {
+		snprintf(name+namelen, 3, "/%d", class->subclass);
+		namelen += 2;
+	}
 
 	if (stats->write_holdtime.nr) {
 		if (stats->read_holdtime.nr)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
