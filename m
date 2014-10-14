From: akpm@linux-foundation.org
Subject: [merged] batman-adv-replace-strnicmp-with-strncasecmp.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:18 -0700
Message-ID: <543d69da.XuIPUk1BJupg5ql7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbaJNSWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, antonio@meshcoding.com, mareklindner@neomailbox.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: batman-adv: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     batman-adv-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

