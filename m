From: akpm@linux-foundation.org
Subject: [patch 2/9] drivers/media/cec/cec-adap.c: fix build with
 gcc-4.4.4
Date: Wed, 13 Sep 2017 16:28:14 -0700
Message-ID: <59b9bf0e.IacqJrSMey9YFNPm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMX2P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geert@linux-m68k.org, hans.verkuil@cisco.com, maxime.ripard@free-electrons.com, mchehab@s-opensource.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with initialization of anonymous unions:

drivers/media/cec/cec-adap.c: In function 'cec_queue_msg_fh':
drivers/media/cec/cec-adap.c:184: error: unknown field 'lost_msgs' specified in initializer

work around this.

Fixes: 6b2bbb08747a5 ("media: cec: rework the cec event handling")
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/cec/cec-adap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/cec/cec-adap.c~drivers-media-cec-cec-adapc-fix-build-with-gcc-444 drivers/media/cec/cec-adap.c
--- a/drivers/media/cec/cec-adap.c~drivers-media-cec-cec-adapc-fix-build-with-gcc-444
+++ a/drivers/media/cec/cec-adap.c
@@ -181,7 +181,10 @@ static void cec_queue_msg_fh(struct cec_
 {
 	static const struct cec_event ev_lost_msgs = {
 		.event = CEC_EVENT_LOST_MSGS,
-		.lost_msgs.lost_msgs = 1,
+		.flags = 0,
+		{
+			.lost_msgs = { 1 },
+		},
 	};
 	struct cec_msg_entry *entry;
 
_
