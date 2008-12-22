From: akpm@linux-foundation.org
Subject: + w1-fix-slave-selection-on-big-endian-systems.patch added to -mm tree
Date: Mon, 22 Dec 2008 13:47:05 -0800
Message-ID: <200812222147.mBMLl6GK020539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563AbYLVWBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 17:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, andi_hummel@gmx.de, zbr@ioremap.net


The patch titled
     w1: fix slave selection on big-endian systems
has been added to the -mm tree.  Its filename is
     w1-fix-slave-selection-on-big-endian-systems.patch

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
Subject: w1: fix slave selection on big-endian systems
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

During test of the w1-gpio driver i found that in "w1.c:679
w1_slave_found()" the device id is converted to little-endian with
"cpu_to_le64()", but its not converted back to cpu format in "w1_io.c:293
w1_reset_select_slave()".

Based on a patch created by Andreas Hummel.

Reported-by: Andreas Hummel <andi_hummel@gmx.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1_io.c~w1-fix-slave-selection-on-big-endian-systems drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-fix-slave-selection-on-big-endian-systems
+++ a/drivers/w1/w1_io.c
@@ -356,7 +356,9 @@ int w1_reset_select_slave(struct w1_slav
 		w1_write_8(sl->master, W1_SKIP_ROM);
 	else {
 		u8 match[9] = {W1_MATCH_ROM, };
-		memcpy(&match[1], (u8 *)&sl->reg_num, 8);
+		u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
+
+		memcpy(&match[1], (u8 *)&rn, 8);
 		w1_write_block(sl->master, match, 9);
 	}
 	return 0;
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

w1-fix-slave-selection-on-big-endian-systems.patch
linux-next.patch

