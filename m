From: akpm@linux-foundation.org
Subject: + namespaces-remove-pid_ns-and-net_ns-experimental-status.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:44:32 -0700
Message-ID: <201010072244.o97MiWT8028870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244Ab0JGWof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     namespaces: remove pid_ns and net_ns experimental status
has been added to the -mm tree.  Its filename is
     namespaces-remove-pid_ns-and-net_ns-experimental-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: remove pid_ns and net_ns experimental status
From: Daniel Lezcano <daniel.lezcano@free.fr>

The pid namespace is in the kernel since 2.6.27 and the net_ns since
2.6.29.  They are enabled in the distro by default and used by userspace
component.  They are mature enough to remove the 'experimental' label.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN init/Kconfig~namespaces-remove-pid_ns-and-net_ns-experimental-status init/Kconfig
--- a/init/Kconfig~namespaces-remove-pid_ns-and-net_ns-experimental-status
+++ a/init/Kconfig
@@ -759,21 +759,18 @@ config USER_NS
 	  If unsure, say N.
 
 config PID_NS
-	bool "PID Namespaces (EXPERIMENTAL)"
+	bool "PID Namespaces"
 	default n
-	depends on NAMESPACES && EXPERIMENTAL
+	depends on NAMESPACES
 	help
 	  Support process id namespaces.  This allows having multiple
 	  processes with the same pid as long as they are in different
 	  pid namespaces.  This is a building block of containers.
 
-	  Unless you want to work with an experimental feature
-	  say N here.
