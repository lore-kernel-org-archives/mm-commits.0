From: akpm@linux-foundation.org
Subject: - ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:36 -0700
Message-ID: <200704132328.l3DNSaWS012533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60365 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161020AbXDMX2m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Ocotea board: ntpd complains that the frequency error exceeds the tolerance
has been removed from the -mm tree.  Its filename was
     ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Ocotea board: ntpd complains that the frequency error exceeds the tolerance
From: Bart Van Assche <bart.vanassche@gmail.com>

Lifted from http://bugzilla.kernel.org/show_bug.cgi?id=8182

Steps to reproduce:
- Boot an Ocotea board with the mainline 2.6.20.1 kernel.
- Create an /etc/ntp.conf file with at least one NTP server and iburst mode set.
- Issue the command "ntpd -g".
- Wait about two minutes.
- Verify ntpd's status via "ntpq -pn" and by looking in /var/log/ntp.

Patch that fixes this problem:

Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/platforms/4xx/ocotea.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ppc/platforms/4xx/ocotea.c~ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance arch/ppc/platforms/4xx/ocotea.c
--- a/arch/ppc/platforms/4xx/ocotea.c~ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance
+++ a/arch/ppc/platforms/4xx/ocotea.c
@@ -289,7 +289,7 @@ ocotea_setup_arch(void)
 	 * from FPGA, because it can be changed by on-board switches
 	 * --ebs
 	 */
-	ibm440gx_get_clocks(&clocks, 33333333, 6 * 1843200);
+	ibm440gx_get_clocks(&clocks, 33300000, 6 * 1843200);
 	ocp_sys_info.opb_bus_freq = clocks.opb;
 
 	/* Setup TODC access */
_

Patches currently in -mm which might be from bart.vanassche@gmail.com are

git-powerpc.patch
