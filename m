From: akpm@linux-foundation.org
Subject: [patch 107/111] init/Kconfig: ban CONFIG_LOCALVERSION_AUTO with
 allmodconfig
Date: Tue, 02 Aug 2016 14:07:21 -0700
Message-ID: <57a10b89.ZByUIVbGfq9Ghc9V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbcHBVXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, mmarek@suse.cz

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
@@ -81,6 +81,7 @@ config LOCALVERSION
 config LOCALVERSION_AUTO
 	bool "Automatically append version information to the version string"
 	default y
+	depends on !COMPILE_TEST
 	help
 	  This will try to automatically determine if the current tree is a
 	  release tree by looking for git tags that belong to the current
_
