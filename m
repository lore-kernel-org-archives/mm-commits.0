From: akpm@linux-foundation.org
Subject: [merged] isdn-eicon-return-on-error.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:18 -0800
Message-ID: <200911091955.nA9JtIlB023638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbZKITzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, armin@melware.de, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     isdn: eicon, return on error
has been removed from the -mm tree.  Its filename was
     isdn-eicon-return-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: eicon, return on error
From: Jiri Slaby <jirislaby@gmail.com>

When diva_strace_read_uint returns an error, return even from
process_idi_event, because l2_state is uninitialized.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Acked-by: Armin Schindler <armin@melware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/maintidi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/hardware/eicon/maintidi.c~isdn-eicon-return-on-error drivers/isdn/hardware/eicon/maintidi.c
--- a/drivers/isdn/hardware/eicon/maintidi.c~isdn-eicon-return-on-error
+++ a/drivers/isdn/hardware/eicon/maintidi.c
@@ -959,8 +959,9 @@ static int process_idi_event (diva_strac
 	}
 	if (!strncmp("State\\Layer2 No1", path, pVar->path_length)) {
 		char* tmp = &pLib->lines[0].pInterface->Layer2[0];
-    dword l2_state;
-    diva_strace_read_uint (pVar, &l2_state);
+		dword l2_state;
+		if (diva_strace_read_uint(pVar, &l2_state))
+			return -1;
 
 		switch (l2_state) {
 			case 0:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
isicomc-use-pr_fmt-and-pr_level.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

