From: akpm@linux-foundation.org
Subject: + net-xfrm-statistics-depend-on-inet.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:02:40 -0800
Message-ID: <200802142102.m1EL2eFg002627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932723AbYBNVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org


The patch titled
     net: xfrm statistics depend on INET
has been added to the -mm tree.  Its filename is
     net-xfrm-statistics-depend-on-inet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: xfrm statistics depend on INET
From: Paul Mundt <lethal@linux-sh.org>

net/built-in.o: In function `xfrm_policy_init':
/home/pmundt/devel/git/sh-2.6.25/net/xfrm/xfrm_policy.c:2338: undefined reference to `snmp_mib_init'

snmp_mib_init() is only built in if CONFIG_INET is set.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/xfrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/xfrm/Kconfig~net-xfrm-statistics-depend-on-inet net/xfrm/Kconfig
--- a/net/xfrm/Kconfig~net-xfrm-statistics-depend-on-inet
+++ a/net/xfrm/Kconfig
@@ -38,7 +38,7 @@ config XFRM_MIGRATE
 
 config XFRM_STATISTICS
 	bool "Transformation statistics (EXPERIMENTAL)"
-	depends on XFRM && PROC_FS && EXPERIMENTAL
+	depends on INET && XFRM && PROC_FS && EXPERIMENTAL
 	---help---
 	  This statistics is not a SNMP/MIB specification but shows
 	  statistics about transformation error (or almost error) factor
_

Patches currently in -mm which might be from lethal@linux-sh.org are

pcmcia-ipwireless-depends-on-netdevices.patch
fix-module_update_markers-compile-error.patch
media-tuner-xc2028-depends-on-fw_loader.patch
git-sh.patch
xtime_lock-vs-update_process_times.patch
net-xfrm-statistics-depend-on-inet.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
asm-futexh-should-include-linux-uaccessh.patch
