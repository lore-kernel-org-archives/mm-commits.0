From: akpm@linux-foundation.org
Subject: + isdn-eicon-return-on-error.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:58:35 -0700
Message-ID: <200908242058.n7OKwZH5014970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbZHXU73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, armin@melware.de, isdn@linux-pingi.de


The patch titled
     isdn: eicon, return on error
has been added to the -mm tree.  Its filename is
     isdn-eicon-return-on-error.patch

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

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

