From: akpm@linux-foundation.org
Subject: - radeonfb-remove-warning-with-config_pm=n.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:21 -0700
Message-ID: <200710301806.l9UI6LFa020511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbXJ3SG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:06:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: remove warning with CONFIG_PM=n
has been removed from the -mm tree.  Its filename was
     radeonfb-remove-warning-with-config_pm=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: radeonfb: remove warning with CONFIG_PM=n
From: Olof Johansson <olof@lixom.net>

Remove warning from powerpc ppc64_defconfig builds:

drivers/video/aty/radeon_pm.c:30: warning: 'radeon_reinitialize_M10' declared 'static' but never defined

It's used only under CONFIG_PM, and only with CONFIG_X86 before it is
defined, so the forward declaration can be moved under the ifdef.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/radeon_pm.c~radeonfb-remove-warning-with-config_pm=n drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeonfb-remove-warning-with-config_pm=n
+++ a/drivers/video/aty/radeon_pm.c
@@ -27,8 +27,6 @@
 
 #include "ati_ids.h"
 
-static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
-
 /*
  * Workarounds for bugs in PC laptops:
  * - enable D2 sleep in some IBM Thinkpads
@@ -39,6 +37,8 @@ static void radeon_reinitialize_M10(stru
  */
 
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
+static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
+
 struct radeon_device_id {
         const char *ident;                     /* (arbitrary) Name */
         const unsigned short subsystem_vendor; /* Subsystem Vendor ID */
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
