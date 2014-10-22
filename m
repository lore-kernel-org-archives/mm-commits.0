From: akpm@linux-foundation.org
Subject: + sysctl-terminate-strings-also-on-r.patch added to -mm tree
Date: Wed, 22 Oct 2014 16:25:11 -0700
Message-ID: <54483cd7.Nz43M2poc2adsEDu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbaJVXZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 19:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pabs3@bonedaddy.net, atomlin@redhat.com, keescook@chromium.org, paulmck@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: terminate strings also on \r
has been added to the -mm tree.  Its filename is
     sysctl-terminate-strings-also-on-r.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-terminate-strings-also-on-r.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-terminate-strings-also-on-r.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Wise <pabs3@bonedaddy.net>
Subject: sysctl: terminate strings also on \r

This partially mitigates a common strategy used by attackers for hiding
the full contents of strings in procfs from naive sysadmins who use cat,
more or sysctl to inspect the contents of strings in procfs.

See http://www.jakoblell.com/blog/2014/05/07/hacking-contest-hiding-stuff-from-the-terminal/

Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-terminate-strings-also-on-r kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-terminate-strings-also-on-r
+++ a/kernel/sysctl.c
@@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, i
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
-			if (c == 0 || c == '\n')
+			if (c == 0 || c == '\n' || c == '\r')
 				break;
 			data[len++] = c;
 		}
_

Patches currently in -mm which might be from pabs3@bonedaddy.net are

sysctl-terminate-strings-also-on-r.patch
sysctl-terminate-strings-also-on-r-fix.patch

