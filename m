From: akpm@linux-foundation.org
Subject: - acpi-handle-invalid-acpi-slit-table.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:44 -0700
Message-ID: <200806122037.m5CKbi81005456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760110AbYFLUhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: handle invalid ACPI SLIT table
has been removed from the -mm tree.  Its filename was
     acpi-handle-invalid-acpi-slit-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: handle invalid ACPI SLIT table
From: Fenghua Yu <fenghua.yu@intel.com>

This is a SLIT sanity checking patch.  It moves slit_valid() function to
generic ACPI code and does sanity checking for both x86 and ia64.  It sets up
node_distance with LOCAL_DISTANCE and REMOTE_DISTANCE when hitting invalid
SLIT table on ia64.  It also cleans up unused variable localities in
acpi_parse_slit() on x86.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    9 +++++++--
 arch/x86/mm/srat_64.c   |   27 ---------------------------
 drivers/acpi/numa.c     |   31 +++++++++++++++++++++++++++----
 3 files changed, 34 insertions(+), 33 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~acpi-handle-invalid-acpi-slit-table arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~acpi-handle-invalid-acpi-slit-table
+++ a/arch/ia64/kernel/acpi.c
@@ -465,7 +465,6 @@ void __init acpi_numa_slit_init(struct a
 		printk(KERN_ERR
 		       "ACPI 2.0 SLIT: size mismatch: %d expected, %d actual\n",
 		       len, slit->header.length);
-		memset(numa_slit, 10, sizeof(numa_slit));
 		return;
 	}
 	slit_table = slit;
@@ -574,8 +573,14 @@ void __init acpi_numa_arch_fixup(void)
 	printk(KERN_INFO "Number of memory chunks in system = %d\n",
 	       num_node_memblks);
 
-	if (!slit_table)
+	if (!slit_table) {
+		for (i = 0; i < MAX_NUMNODES; i++)
+			for (j = 0; j < MAX_NUMNODES; j++)
+				node_distance(i, j) = i == j ? LOCAL_DISTANCE :
+							REMOTE_DISTANCE;
 		return;
+	}
+
 	memset(numa_slit, -1, sizeof(numa_slit));
 	for (i = 0; i < slit_table->locality_count; i++) {
 		if (!pxm_bit_test(i))
diff -puN arch/x86/mm/srat_64.c~acpi-handle-invalid-acpi-slit-table arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c~acpi-handle-invalid-acpi-slit-table
+++ a/arch/x86/mm/srat_64.c
@@ -97,36 +97,9 @@ static __init inline int srat_disabled(v
 	return numa_off || acpi_numa < 0;
 }
 
-/*
- * A lot of BIOS fill in 10 (= no distance) everywhere. This messes
- * up the NUMA heuristics which wants the local node to have a smaller
- * distance than the others.
- * Do some quick checks here and only use the SLIT if it passes.
- */
-static __init int slit_valid(struct acpi_table_slit *slit)
-{
-	int i, j;
-	int d = slit->locality_count;
-	for (i = 0; i < d; i++) {
-		for (j = 0; j < d; j++)  {
-			u8 val = slit->entry[d*i + j];
-			if (i == j) {
-				if (val != LOCAL_DISTANCE)
-					return 0;
-			} else if (val <= LOCAL_DISTANCE)
-				return 0;
-		}
-	}
-	return 1;
-}
-
 /* Callback for SLIT parsing */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
-	if (!slit_valid(slit)) {
-		printk(KERN_INFO "ACPI: SLIT table looks invalid. Not used.\n");
-		return;
-	}
 	acpi_slit = slit;
 }
 
diff -puN drivers/acpi/numa.c~acpi-handle-invalid-acpi-slit-table drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~acpi-handle-invalid-acpi-slit-table
+++ a/drivers/acpi/numa.c
@@ -140,19 +140,42 @@ acpi_table_print_srat_entry(struct acpi_
 	}
 }
 
+/*
+ * A lot of BIOS fill in 10 (= no distance) everywhere. This messes
+ * up the NUMA heuristics which wants the local node to have a smaller
+ * distance than the others.
+ * Do some quick checks here and only use the SLIT if it passes.
+ */
+static __init int slit_valid(struct acpi_table_slit *slit)
+{
+	int i, j;
+	int d = slit->locality_count;
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			if (i == j) {
+				if (val != LOCAL_DISTANCE)
+					return 0;
+			} else if (val <= LOCAL_DISTANCE)
+				return 0;
+		}
+	}
+	return 1;
+}
+
 static int __init acpi_parse_slit(struct acpi_table_header *table)
 {
 	struct acpi_table_slit *slit;
-	u32 localities;
 
 	if (!table)
 		return -EINVAL;
 
 	slit = (struct acpi_table_slit *)table;
 
-	/* downcast just for %llu vs %lu for i386/ia64  */
-	localities = (u32) slit->locality_count;
