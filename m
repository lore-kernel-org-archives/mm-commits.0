From: akpm@linux-foundation.org
Subject: [merged] pps-kc-fix-non-tickless-system-config-dependency.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:25:22 -0700
Message-ID: <57fe8e22.qypP+FPJIHpj+m/l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcJLTZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@maciej.szmigiero.name, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: kc: fix non-tickless system config dependency
has been removed from the -mm tree.  Its filename was
     pps-kc-fix-non-tickless-system-config-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: pps: kc: fix non-tickless system config dependency

CONFIG_NO_HZ currently only sets the default value of dynticks config so
if PPS kernel consumer needs periodic timer ticks it should depend on
!CONFIG_NO_HZ_COMMON instead of !CONFIG_NO_HZ.

Otherwise it is possible to enable it even on tickless system which has
CONFIG_NO_HZ not set and CONFIG_NO_HZ_IDLE (or CONFIG_NO_HZ_FULL) set.

Link: http://lkml.kernel.org/r/57E2B769.50202@maciej.szmigiero.name
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/Kconfig~pps-kc-fix-non-tickless-system-config-dependency drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-kc-fix-non-tickless-system-config-dependency
+++ a/drivers/pps/Kconfig
@@ -31,7 +31,7 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on !NO_HZ
+	depends on !NO_HZ_COMMON
 	help
 	  This option adds support for direct in-kernel time
 	  synchronization using an external PPS signal.
_

Patches currently in -mm which might be from mail@maciej.szmigiero.name are


