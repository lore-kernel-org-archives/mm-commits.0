From: akpm@linux-foundation.org
Subject: + fix-sscanf-%n-match-at-end-of-input-string.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:17:04 -0800
Message-ID: <200703252217.l2PMH492004053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXCYWRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net


The patch titled
     fix sscanf %n match at end of input string
has been added to the -mm tree.  Its filename is
     fix-sscanf-%n-match-at-end-of-input-string.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sscanf %n match at end of input string
From: Johannes Berg <johannes@sipsolutions.net>

I was playing with some code that sometimes got a string where a %n
match should have been done where the input string ended, for example
like this:

  sscanf("abc123", "abc%d%n", &a, &n);  /* doesn't work */
  sscanf("abc123a", "abc%d%n", &a, &n); /* works */

However, the scanf function in the kernel doesn't convert the %n in that
case because it has already matched the complete input after %d and just
completely stops matching then. This patch fixes that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string lib/vsprintf.c
--- a/lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string
+++ a/lib/vsprintf.c
@@ -825,6 +825,15 @@ int vsscanf(const char * buf, const char
 			break;
 		str = next;
 	}
+
+	/* Now we've come all the way through so either the input string or
+	 * the format ended. In the former case, there can be a %n at the
+	 * current position in the format that needs to be filled. */
+	if (*fmt == '%' && *(fmt+1) == 'n') {
+		int *i = (int *)va_arg(args,int*);
+		*i = str - buf;
+	}
+
 	return num;
 }
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-alsa.patch
git-wireless.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
