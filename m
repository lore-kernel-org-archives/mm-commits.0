From: akpm@linux-foundation.org
Subject: [merged] staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:34 -0700
Message-ID: <543d69ea.CKodJMEHkZlLTp+R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaJNSWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: r8188eu: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     staging-r8188eu-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: staging: r8188eu: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8188eu/os_dep/rtw_android.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/rtl8188eu/os_dep/rtw_android.c~staging-r8188eu-replace-strnicmp-with-strncasecmp drivers/staging/rtl8188eu/os_dep/rtw_android.c
--- a/drivers/staging/rtl8188eu/os_dep/rtw_android.c~staging-r8188eu-replace-strnicmp-with-strncasecmp
+++ a/drivers/staging/rtl8188eu/os_dep/rtw_android.c
@@ -79,7 +79,7 @@ int rtw_android_cmdstr_to_num(char *cmds
 {
 	int cmd_num;
 	for (cmd_num = 0; cmd_num < ANDROID_WIFI_CMD_MAX; cmd_num++)
-		if (0 == strnicmp(cmdstr , android_wifi_cmd_str[cmd_num],
+		if (0 == strncasecmp(cmdstr , android_wifi_cmd_str[cmd_num],
 				  strlen(android_wifi_cmd_str[cmd_num])))
 			break;
 	return cmd_num;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

