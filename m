From: akpm@linux-foundation.org
Subject: + arch-powerpc-replace-obsolete-strict_strto-calls.patch added to -mm tree
Date: Mon, 23 Jun 2014 16:29:48 -0700
Message-ID: <53a8b86c.zE+0J/lJC6Hvmgjv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaFWX3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 19:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalter@google.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc: replace obsolete strict_strto* calls
has been added to the -mm tree.  Its filename is
     arch-powerpc-replace-obsolete-strict_strto-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-powerpc-replace-obsolete-strict_strto-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-powerpc-replace-obsolete-strict_strto-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -399,10 +399,10 @@ out:
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
@@ -319,7 +319,7 @@ static ssize_t migrate_store(struct clas
 	u64 streamid;
 	int rc;
 
-	rc = strict_strtoull(buf, 0, &streamid);
+	rc = kstrtou64(buf, 0, &streamid);
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from dwalter@google.com are

arch-arm-mach-omap2-replace-strict_strto-with-kstrto.patch
arch-arm-mach-pxa-replace-strict_strto-call-with-kstrto.patch
arch-arm-mach-s3c24xx-mach-jivec-replace-strict_strto-with-kstrto.patch
arch-arm-mach-w90x900-cpuc-replace-obsolete-strict_strto.patch
arch-powerpc-replace-obsolete-strict_strto-calls.patch
arch-x86-replace-strict_strto-calls.patch
drivers-scsi-replace-strict_strto-calls.patch
net-sunrpc-replace-strict_strto-calls.patch
include-linux-remove-strict_strto-definitions.patch

