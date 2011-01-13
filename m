From: akpm@linux-foundation.org
Subject: [merged] um-mark-config_highmem-as-broken.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:38 -0800
Message-ID: <201101132006.p0DK6JZq029739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933405Ab1AMUMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: mark CONFIG_HIGHMEM as broken
has been removed from the -mm tree.  Its filename was
     um-mark-config_highmem-as-broken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: mark CONFIG_HIGHMEM as broken
From: Richard Weinberger <richard@nod.at>

Currently CONFIG_HIGHMEM is broken on User Mode Linux.  I'm not sure if it
worked ever.

It doesn't compile and this breaks randomconfig testing.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.um~um-mark-config_highmem-as-broken arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~um-mark-config_highmem-as-broken
+++ a/arch/um/Kconfig.um
@@ -131,7 +131,7 @@ config NR_CPUS
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
-	depends on !64BIT && EXPERIMENTAL
+	depends on !64BIT && BROKEN
 	default n
 	help
 	  This was used to allow UML to run with big amounts of memory.
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

