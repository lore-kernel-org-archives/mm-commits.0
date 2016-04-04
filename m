From: akpm@linux-foundation.org
Subject: [merged] make-config_fhandle-default-y.patch removed from -mm
 tree
Date: Mon, 04 Apr 2016 11:09:51 -0700
Message-ID: <5702adef.LDO43T65X0uxvK4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbcDDSJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, richard.weinberger@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Make CONFIG_FHANDLE default y
has been removed from the -mm tree.  Its filename was
     make-config_fhandle-default-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: Make CONFIG_FHANDLE default y

Newer Fedora and OpenSUSE didn't boot with my standard configuration.  It
took me some time to figure out why, in fact I had to write a script to
try different config options systematically.

The problem is that something (systemd) in dracut depends on
CONFIG_FHANDLE, which adds open by file handle syscalls.

While it is set in defconfigs it is very easy to miss when updating older
configs because it is not default y.

Make it default y and also depend on EXPERT, as dracut use is likely
widespread.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~make-config_fhandle-default-y init/Kconfig
--- a/init/Kconfig~make-config_fhandle-default-y
+++ a/init/Kconfig
@@ -272,8 +272,9 @@ config CROSS_MEMORY_ATTACH
 	  See the man page for more details.
 
 config FHANDLE
-	bool "open by fhandle syscalls"
+	bool "open by fhandle syscalls" if EXPERT
 	select EXPORTFS
+	default y
 	help
 	  If you say Y here, a user level program will be able to map
 	  file names to handle and then later use the handle for
_

Patches currently in -mm which might be from ak@linux.intel.com are


