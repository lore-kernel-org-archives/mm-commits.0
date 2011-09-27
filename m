From: akpm@google.com
Subject: + drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch added to -mm tree
Date: Tue, 27 Sep 2011 15:44:20 -0700
Message-ID: <201109272324.p8RNO5kL022497@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:49649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1I0XYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 19:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, davem@davemloft.net, jbaron@redhat.com, philb@gnu.org


The patch titled
     drivers/net/ethernet/i825xx/3c505.c: fix build with dynamic debug
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch

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
Subject: drivers/net/ethernet/i825xx/3c505.c: fix build with dynamic debug
From: Andrew Morton <akpm@google.com>

The `#define filename' screws up the expansion of
DEFINE_DYNAMIC_DEBUG_METADATA:

drivers/net/ethernet/i825xx/3c505.c: In function 'send_pcb':
drivers/net/ethernet/i825xx/3c505.c:390: error: expected identifier before string constant
drivers/net/ethernet/i825xx/3c505.c:390: error: expected '}' before '.' token
drivers/net/ethernet/i825xx/3c505.c:436: error: expected identifier before string constant
drivers/net/ethernet/i825xx/3c505.c:435: error: expected '}' before '.' token
drivers/net/ethernet/i825xx/3c505.c: In function 'start_receive':
drivers/net/ethernet/i825xx/3c505.c:557: error: expected identifier before string constant
drivers/net/ethernet/i825xx/3c505.c:557: error: expected '}' before '.' token
drivers/net/ethernet/i825xx/3c505.c: In function 'receive_packet':
drivers/net/ethernet/i825xx/3c505.c:629: error: expected identifier before string constant

etc

Cc: Philip Blundell <philb@gnu.org>
Cc: David Miller <davem@davemloft.net>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/net/ethernet/i825xx/3c505.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/ethernet/i825xx/3c505.c~drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug drivers/net/ethernet/i825xx/3c505.c
--- a/drivers/net/ethernet/i825xx/3c505.c~drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug
+++ a/drivers/net/ethernet/i825xx/3c505.c
@@ -126,15 +126,13 @@
  *
  *********************************************************/
 
-#define filename __FILE__
