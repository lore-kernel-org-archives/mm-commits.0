From: akpm@linux-foundation.org
Subject: + net-caif-cfrfmlc-use-asm-unalignedh.patch added to -mm tree
Date: Tue, 24 Aug 2010 15:39:52 -0700
Message-ID: <201008242239.o7OMdqZN018936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0HXWkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 18:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, davem@davemloft.net, sjur.brandeland@stericsson.com


The patch titled
     net/caif/cfrfml.c: use asm/unaligned.h
has been added to the -mm tree.  Its filename is
     net-caif-cfrfmlc-use-asm-unalignedh.patch

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
Subject: net/caif/cfrfml.c: use asm/unaligned.h
From: Jeff Mahoney <jeffm@suse.com>

caif does not build on ia64 starting with 2.6.32-rc1.  Using
asm/unaligned.h instead of linux/unaligned/le_byteshift.h fixes the issue.

include/linux/unaligned/le_byteshift.h:40:50: error: redefinition of 'get_unaligned_le16'
include/linux/unaligned/le_byteshift.h:45:50: error: redefinition of 'get_unaligned_le32'
include/linux/unaligned/le_byteshift.h:50:50: error: redefinition of 'get_unaligned_le64'
include/linux/unaligned/le_byteshift.h:55:51: error: redefinition of 'put_unaligned_le16'
include/linux/unaligned/le_byteshift.h:60:51: error: redefinition of 'put_unaligned_le32'
include/linux/unaligned/le_byteshift.h:65:51: error: redefinition of 'put_unaligned_le64'
include/linux/unaligned/le_struct.h:31:51: note: previous definition of 'put_unaligned_le64' was here

Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/caif/cfrfml.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/caif/cfrfml.c~net-caif-cfrfmlc-use-asm-unalignedh net/caif/cfrfml.c
--- a/net/caif/cfrfml.c~net-caif-cfrfmlc-use-asm-unalignedh
+++ a/net/caif/cfrfml.c
@@ -7,7 +7,7 @@
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <linux/unaligned/le_byteshift.h>
+#include <asm/unaligned.h>
 #include <net/caif/caif_layer.h>
 #include <net/caif/cfsrvl.h>
 #include <net/caif/cfpkt.h>
_

Patches currently in -mm which might be from jeffm@suse.com are

net-caif-cfrfmlc-use-asm-unalignedh.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

