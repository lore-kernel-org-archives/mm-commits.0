From: akpm@linux-foundation.org
Subject: + uts-make-default-hostname-configurable-rather-than-always-using-none.patch added to -mm tree
Date: Mon, 06 Jun 2011 16:21:30 -0700
Message-ID: <201106062321.p56NLU8i029438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab1FFXWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 19:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, davem@davemloft.net, kel@otaku42.de, serue@us.ibm.com, torvalds@linux-foundation.org


The patch titled
     uts: make default hostname configurable, rather than always using "(none)"
has been added to the -mm tree.  Its filename is
     uts-make-default-hostname-configurable-rather-than-always-using-none.patch

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
Subject: uts: make default hostname configurable, rather than always using "(none)"
From: Josh Triplett <josh@joshtriplett.org>

The "hostname" tool falls back to setting the hostname to "localhost" if
/etc/hostname does not exist.  Distribution init scripts have the same
fallback.  However, if userspace never calls sethostname, such as when
booting with init=/bin/sh, or otherwise booting a minimal system without
the usual init scripts, the default hostname of "(none)" remains,
unhelpfully appearing in various places such as prompts ("root@(none):~#")
and logs.  Furthermore, "(none)" doesn't typically resolve to anything
useful.

Make the default hostname configurable.  This removes the need for the
standard fallback, provides a useful default for systems that never call
sethostname, and makes minimal systems that much more useful with less
configuration.  Distributions could choose to use "localhost" here to
avoid the fallback, while embedded systems may wish to use a specific
target hostname.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Miller <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Kel Modderman <kel@otaku42.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uts.h |    2 +-
 init/Kconfig        |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/uts.h~uts-make-default-hostname-configurable-rather-than-always-using-none include/linux/uts.h
--- a/include/linux/uts.h~uts-make-default-hostname-configurable-rather-than-always-using-none
+++ a/include/linux/uts.h
@@ -9,7 +9,7 @@
 #endif
 
 #ifndef UTS_NODENAME
-#define UTS_NODENAME "(none)"	/* set by sethostname() */
+#define UTS_NODENAME CONFIG_DEFAULT_HOSTNAME /* set by sethostname() */
 #endif
 
 #ifndef UTS_DOMAINNAME
diff -puN init/Kconfig~uts-make-default-hostname-configurable-rather-than-always-using-none init/Kconfig
--- a/init/Kconfig~uts-make-default-hostname-configurable-rather-than-always-using-none
+++ a/init/Kconfig
@@ -204,6 +204,15 @@ config KERNEL_LZO
 
 endchoice
 
+config DEFAULT_HOSTNAME
+	string "Default hostname"
+	default "(none)"
+	help
+	  This option determines the default system hostname before userspace
+	  calls sethostname(2). The kernel traditionally uses "(none)" here,
+	  but you may wish to use a different default here to make a minimal
+	  system more usable with less configuration.
+
 config SWAP
 	bool "Support for paging of anonymous memory (swap)"
 	depends on MMU && BLOCK
_

Patches currently in -mm which might be from josh@joshtriplett.org are

uts-make-default-hostname-configurable-rather-than-always-using-none.patch

