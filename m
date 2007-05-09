From: akpm@linux-foundation.org
Subject: - fix-sscanf-%n-match-at-end-of-input-string.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:40 -0700
Message-ID: <200705090247.l492le0Z009001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967154AbXEICtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     fix sscanf %n match at end of input string
has been removed from the -mm tree.  Its filename was
     fix-sscanf-%n-match-at-end-of-input-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string lib/vsprintf.c
--- a/lib/vsprintf.c~fix-sscanf-%n-match-at-end-of-input-string
+++ a/lib/vsprintf.c
@@ -825,6 +825,17 @@ int vsscanf(const char * buf, const char
 			break;
 		str = next;
 	}
+
+	/*
+	 * Now we've come all the way through so either the input string or the
+	 * format ended. In the former case, there can be a %n at the current
+	 * position in the format that needs to be filled.
+	 */
+	if (*fmt == '%' && *(fmt + 1) == 'n') {
+		int *p = (int *)va_arg(args, int *);
+		*p = str - buf;
+	}
+
 	return num;
 }
 
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-alsa.patch
power-management-remove-some-useless-code-from-arm.patch
git-wireless.patch
pm-separate-hibernation-code-from-suspend-code.patch
swsusp-use-reasonable-default-for-hibernation_mode.patch
