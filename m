From: akpm@linux-foundation.org
Subject: + kernel-resourcec-fix-sign-extension-in-reserve_setup.patch added to -mm tree
Date: Wed, 24 Jun 2009 20:28:48 -0700
Message-ID: <200906250328.n5P3Smhq025823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbZFYDaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 23:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, drzeus@drzeus.cx, jbarnes@virtuousgeek.org, leann@ubuntu.com, pablomme@googlemail.com, stable@kernel.org


The patch titled
     kernel/resource.c: fix sign extension in reserve_setup()
has been added to the -mm tree.  Its filename is
     kernel-resourcec-fix-sign-extension-in-reserve_setup.patch

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
kernel-resourcec-fix-sign-extension-in-reserve_setup.patch

