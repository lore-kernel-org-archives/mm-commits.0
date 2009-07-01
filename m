From: akpm@linux-foundation.org
Subject: [merged] kernel-resourcec-fix-sign-extension-in-reserve_setup.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:13 -0700
Message-ID: <200907011727.n61HRDgT002041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbZGAR2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, drzeus@drzeus.cx, jbarnes@virtuousgeek.org, leann@ubuntu.com, pablomme@googlemail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/resource.c: fix sign extension in reserve_setup()
has been removed from the -mm tree.  Its filename was
     kernel-resourcec-fix-sign-extension-in-reserve_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/resource.c: fix sign extension in reserve_setup()
From: Zhang Rui <rui.zhang@intel.com>

When the 32-bit signed quantities get assigned to the u64 resource_size_t,
they are incorrectly sign-extended.


Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13253
Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9905

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: Leann Ogasawara <leann@ubuntu.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Reported-by: <pablomme@googlemail.com>
Tested-by: <pablomme@googlemail.com>
Cc: <stable@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/resource.c~kernel-resourcec-fix-sign-extension-in-reserve_setup kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-fix-sign-extension-in-reserve_setup
+++ a/kernel/resource.c
@@ -787,7 +787,7 @@ static int __init reserve_setup(char *st
 	static struct resource reserve[MAXRESERVE];
 
 	for (;;) {
-		int io_start, io_num;
+		unsigned int io_start, io_num;
 		int x = reserved;
 
 		if (get_option (&str, &io_start) != 2)
_

Patches currently in -mm which might be from rui.zhang@intel.com are

origin.patch
linux-next.patch

