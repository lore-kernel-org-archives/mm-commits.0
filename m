From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-replace-obsolete-strict_strto-calls.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:10 -0700
Message-ID: <53ea6e12.9uvuzGgmcfpM3qnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:47312 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaHLTmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:11 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1915435oac.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc: replace obsolete strict_strto* calls
has been removed from the -mm tree.  Its filename was
     arch-powerpc-replace-obsolete-strict_strto-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Walter <dwalter@google.com>
Subject: arch/powerpc: replace obsolete strict_strto* calls

Replace strict_strto calls with more appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_64.c            |    6 +++---
 arch/powerpc/kernel/vio.c                 |    2 +-
 arch/powerpc/platforms/pseries/dlpar.c    |    4 ++--
 arch/powerpc/platforms/pseries/mobility.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/kernel/setup_64.c~arch-powerpc-replace-obsolete-strict_strto-calls arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~arch-powerpc-replace-obsolete-strict_strto-calls
+++ a/arch/powerpc/kernel/setup_64.c
@@ -149,13 +149,13 @@ static void check_smt_enabled(void)
 		else if (!strcmp(smt_enabled_cmdline, "off"))
 			smt_enabled_at_boot = 0;
 		else {
-			long smt;
+			int smt;
 			int rc;
 
-			rc = strict_strtol(smt_enabled_cmdline, 10, &smt);
+			rc = kstrtoint(smt_enabled_cmdline, 10, &smt);
 			if (!rc)
 				smt_enabled_at_boot =
-					min(threads_per_core, (int)smt);
+					min(threads_per_core, smt);
 		}
 	} else {
 		dn = of_find_node_by_path("/options");
diff -puN arch/powerpc/kernel/vio.c~arch-powerpc-replace-obsolete-strict_strto-calls arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~arch-powerpc-replace-obsolete-strict_strto-calls
+++ a/arch/powerpc/kernel/vio.c
@@ -977,7 +977,7 @@ static ssize_t viodev_cmo_desired_set(st
 	size_t new_desired;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &new_desired);
+	ret = kstrtoul(buf, 10, &new_desired);
 	if (ret)
 		return ret;
 
diff -puN arch/powerpc/platforms/pseries/dlpar.c~arch-powerpc-replace-obsolete-strict_strto-calls arch/powerpc/platforms/pseries/dlpar.c
--- a/arch/powerpc/platforms/pseries/dlpar.c~arch-powerpc-replace-obsolete-strict_strto-calls
+++ a/arch/powerpc/platforms/pseries/dlpar.c
@@ -400,10 +400,10 @@ out:
 static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 {
 	struct device_node *dn, *parent;
-	unsigned long drc_index;
+	u32 drc_index;
 	int rc;
 
-	rc = strict_strtoul(buf, 0, &drc_index);
+	rc = kstrtou32(buf, 0, &drc_index);
 	if (rc)
 		return -EINVAL;
 
diff -puN arch/powerpc/platforms/pseries/mobility.c~arch-powerpc-replace-obsolete-strict_strto-calls arch/powerpc/platforms/pseries/mobility.c
--- a/arch/powerpc/platforms/pseries/mobility.c~arch-powerpc-replace-obsolete-strict_strto-calls
+++ a/arch/powerpc/platforms/pseries/mobility.c
@@ -320,7 +320,7 @@ static ssize_t migrate_store(struct clas
 	u64 streamid;
 	int rc;
 
-	rc = strict_strtoull(buf, 0, &streamid);
+	rc = kstrtou64(buf, 0, &streamid);
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from dwalter@google.com are

origin.patch
linux-next.patch
include-linux-remove-strict_strto-definitions.patch

