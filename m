From: akpm@linux-foundation.org
Subject: [merged] documentation-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
Date: Fri, 23 Aug 2013 12:06:11 -0700
Message-ID: <5217b2a3.15UY3wB7AfSdXzEi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3HWTGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 15:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] documentation-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 12:06:11 -0700


The patch titled
     Subject: Documentation: replace strict_strtoul() with kstrtoul()
has been removed from the -mm tree.  Its filename was
     documentation-replace-strict_strtoul-with-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: Documentation: replace strict_strtoul() with kstrtoul()

The usage of strict_strtoul() is not preferred, because strict_strtoul()
is obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/target/tcm_mod_builder.py |    2 +-
 Documentation/trace/ftrace.txt          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/target/tcm_mod_builder.py~documentation-replace-strict_strtoul-with-kstrtoul Documentation/target/tcm_mod_builder.py
--- a/Documentation/target/tcm_mod_builder.py~documentation-replace-strict_strtoul-with-kstrtoul
+++ a/Documentation/target/tcm_mod_builder.py
@@ -300,7 +300,7 @@ def tcm_mod_build_configfs(proto_ident,
 	buf += "	int ret;\n\n"
 	buf += "	if (strstr(name, \"tpgt_\") != name)\n"
 	buf += "		return ERR_PTR(-EINVAL);\n"
-	buf += "	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)\n"
+	buf += "	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)\n"
 	buf += "		return ERR_PTR(-EINVAL);\n\n"
 	buf += "	tpg = kzalloc(sizeof(struct " + fabric_mod_name + "_tpg), GFP_KERNEL);\n"
 	buf += "	if (!tpg) {\n"
diff -puN Documentation/trace/ftrace.txt~documentation-replace-strict_strtoul-with-kstrtoul Documentation/trace/ftrace.txt
--- a/Documentation/trace/ftrace.txt~documentation-replace-strict_strtoul-with-kstrtoul
+++ a/Documentation/trace/ftrace.txt
@@ -735,7 +735,7 @@ Here are the available options:
 		 function as well as the function being traced.
 
   print-parent:
-   bash-4000  [01]  1477.606694: simple_strtoul <-strict_strtoul
+   bash-4000  [01]  1477.606694: simple_strtoul <-kstrtoul
 
   noprint-parent:
    bash-4000  [01]  1477.606694: simple_strtoul
@@ -759,7 +759,7 @@ Here are the available options:
             latency-format option is enabled.
 
     bash  4000 1 0 00000000 00010a95 [58127d26] 1720.415ms \
-    (+0.000ms): simple_strtoul (strict_strtoul)
+    (+0.000ms): simple_strtoul (kstrtoul)
 
   raw - This will display raw numbers. This option is best for
 	use with user applications that can translate the raw
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-iommu-remove-unnecessary-platform_set_drvdata.patch
block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
drivers-block-swimc-remove-unnecessary-platform_set_drvdata.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
rtc-rtc-nuc900-use-null-instead-of-0.patch
drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch
drivers-memstick-host-rtsx_pci_msc-remove-unnecessary-platform_set_drvdata.patch
w1-replace-strict_strtol-with-kstrtol.patch
drivers-w1-masters-mxc_w1c-remove-unnecessary-platform_set_drvdata.patch
kernel-replace-strict_strto-with-kstrto.patch

