From: akpm@linux-foundation.org
Subject: + ban-config_localversion_auto-with-allmodconfig.patch added to
 -mm tree
Date: Thu, 07 Jul 2016 17:45:29 -0700
Message-ID: <577ef7a9.H8xZuJ22BIZX4xAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbcGHApa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2016 20:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: ban CONFIG_LOCALVERSION_AUTO with allmodconfig
has been added to the -mm tree.  Its filename is
     ban-config_localversion_auto-with-allmodconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ban-config_localversion_auto-with-allmodconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ban-config_localversion_auto-with-allmodconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: init/Kconfig: ban CONFIG_LOCALVERSION_AUTO with allmodconfig

Doing patches with allmodconfig kernel compiled and committing stuff into
local tree have unfortunate consequence: kernel version changes (as it
should) leading to recompiling and relinking of several files even if they
weren't touched (or interesting at all).  This and "git-whatever" figuring
out current version slow down compilation for no good reason.

But lets face it, "allmodconfig" kernels don't care about kernel version,
they are simply compile check guinea pigs.

Make LOCALVERSION_AUTO depend on !COMPILE_TEST, so it doesn't sneak into
allmodconfig .config.

Link: http://lkml.kernel.org/r/20160707214954.GC31678@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~ban-config_localversion_auto-with-allmodconfig init/Kconfig
--- a/init/Kconfig~ban-config_localversion_auto-with-allmodconfig
+++ a/init/Kconfig
@@ -80,6 +80,7 @@ config LOCALVERSION
 config LOCALVERSION_AUTO
 	bool "Automatically append version information to the version string"
 	default y
+	depends on !COMPILE_TEST
 	help
 	  This will try to automatically determine if the current tree is a
 	  release tree by looking for git tags that belong to the current
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ban-config_localversion_auto-with-allmodconfig.patch

