From: akpm@linux-foundation.org
Subject: + ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch added to -mm tree
Date: Thu, 15 Mar 2007 18:55:31 -0800
Message-ID: <200703160255.l2G2tVXK000950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50729 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXCPCzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@gate.crashing.org, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Ocotea board: ntpd complains that the frequency error exceeds the tolerance
has been added to the -mm tree.  Its filename is
     ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Ocotea board: ntpd complains that the frequency error exceeds the tolerance


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

Patches currently in -mm which might be from galak@gate.crashing.org are

ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch
