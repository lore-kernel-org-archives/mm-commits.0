From: akpm@linux-foundation.org
Subject: + drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch added to -mm tree
Date: Wed, 15 Apr 2009 14:32:44 -0700
Message-ID: <200904152132.n3FLWiTi012793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZDOVev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 17:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com, rolandd@cisco.com


The patch titled
     drivers/infiniband/hw/nes/nes_cm.c: fix unused var warning
has been added to the -mm tree.  Its filename is
     drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch

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
Subject: drivers/infiniband/hw/nes/nes_cm.c: fix unused var warning
From: Zhenwen Xu <helight.xu@gmail.com>

drivers/infiniband/hw/nes/nes_cm.c:862: warning: unused variable `tmp_addr'

The 'tmp_addr' is defined for debug, so it should be defined in
CONFIG_INFINIBAND_NES_DEBUG

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/nes/nes_cm.c~drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -854,8 +854,9 @@ static struct nes_cm_listener *find_list
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
+#ifdef CONFIG_INFINIBAND_NES_DEBUG
 	__be32 tmp_addr = cpu_to_be32(dst_addr);
