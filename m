From: akpm@linux-foundation.org
Subject: [nacked] sysctl-terminate-strings-also-on-r.patch removed from
 -mm tree
Date: Mon, 15 Dec 2014 15:45:05 -0800
Message-ID: <548f7281.kNCdxbM1timY4NrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaLOXpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Dec 2014 18:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pabs3@bonedaddy.net, atomlin@redhat.com, keescook@chromium.org, paulmck@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: terminate strings also on \r
has been removed from the -mm tree.  Its filename was
     sysctl-terminate-strings-also-on-r.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Paul Wise <pabs3@bonedaddy.net>
Subject: sysctl: terminate strings also on \r

This partially mitigates a common strategy used by attackers for hiding
the full contents of strings in procfs from naive sysadmins who use cat,
more or sysctl to inspect the contents of strings in procfs.

See http://www.jakoblell.com/blog/2014/05/07/hacking-contest-hiding-stuff-from-the-terminal/

[akpm@linux-foundation.org: add missing comment]
Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-terminate-strings-also-on-r kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-terminate-strings-also-on-r
+++ a/kernel/sysctl.c
@@ -1749,7 +1749,11 @@ static int _proc_do_string(char *data, i
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
-			if (c == 0 || c == '\n')
+			/*
+			 * \r terminates input to partially prevent attackers
+			 * from hiding info from sysadmins who use cat
+			 */
+			if (c == 0 || c == '\n' || c == '\r')
 				break;
 			data[len++] = c;
 		}
_

Patches currently in -mm which might be from pabs3@bonedaddy.net are


