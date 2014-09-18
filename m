From: akpm@linux-foundation.org
Subject: + batman-adv-replace-strnicmp-with-strncasecmp.patch added to -mm tree
Date: Thu, 18 Sep 2014 14:36:13 -0700
Message-ID: <541b504d./LIewl1RxY21gbs5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbaIRVgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, antonio@meshcoding.com, mareklindner@neomailbox.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: batman-adv: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     batman-adv-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/batman-adv-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/batman-adv-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: batman-adv: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Acked-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/batman-adv/gateway_common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN net/batman-adv/gateway_common.c~batman-adv-replace-strnicmp-with-strncasecmp net/batman-adv/gateway_common.c
--- a/net/batman-adv/gateway_common.c~batman-adv-replace-strnicmp-with-strncasecmp
+++ a/net/batman-adv/gateway_common.c
@@ -44,10 +44,10 @@ static bool batadv_parse_gw_bandwidth(st
 	if (strlen(buff) > 4) {
 		tmp_ptr = buff + strlen(buff) - 4;
 
-		if (strnicmp(tmp_ptr, "mbit", 4) == 0)
+		if (strncasecmp(tmp_ptr, "mbit", 4) == 0)
 			bw_unit_type = BATADV_BW_UNIT_MBIT;
 
-		if ((strnicmp(tmp_ptr, "kbit", 4) == 0) ||
+		if ((strncasecmp(tmp_ptr, "kbit", 4) == 0) ||
 		    (bw_unit_type == BATADV_BW_UNIT_MBIT))
 			*tmp_ptr = '\0';
 	}
@@ -77,10 +77,10 @@ static bool batadv_parse_gw_bandwidth(st
 		if (strlen(slash_ptr + 1) > 4) {
 			tmp_ptr = slash_ptr + 1 - 4 + strlen(slash_ptr + 1);
 
-			if (strnicmp(tmp_ptr, "mbit", 4) == 0)
+			if (strncasecmp(tmp_ptr, "mbit", 4) == 0)
 				bw_unit_type = BATADV_BW_UNIT_MBIT;
 
-			if ((strnicmp(tmp_ptr, "kbit", 4) == 0) ||
+			if ((strncasecmp(tmp_ptr, "kbit", 4) == 0) ||
 			    (bw_unit_type == BATADV_BW_UNIT_MBIT))
 				*tmp_ptr = '\0';
 		}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

