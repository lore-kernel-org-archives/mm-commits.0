From: akpm@linux-foundation.org
Subject: +
 drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch added to -mm tree
Date: Wed, 24 Jul 2013 16:12:52 -0700
Message-ID: <51f05f74.3W6b8P2t9sQoC6nY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3GXXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 19:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gustavo.padovan@collabora.co.uk, gustavo@padovan.org

Subject: + drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch added to -mm tree
To: gustavo@padovan.org,gustavo.padovan@collabora.co.uk
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 16:12:52 -0700


The patch titled
     Subject: drivers/misc/ti-st/st_core.c: fix NULL dereference on protocol type check
has been added to the -mm tree.  Its filename is
     drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gustavo Padovan <gustavo@padovan.org>
Subject: drivers/misc/ti-st/st_core.c: fix NULL dereference on protocol type check


If the type we receive is greater than ST_MAX_CHANNELS we can't rely on
type as vector index since we would be accessing unknown memory when we use the type
as index.

 Unable to handle kernel NULL pointer dereference at virtual address 0000001b
 pgd = c0004000
 [0000001b] *pgd=00000000
 Internal error: Oops: 17 [#1] PREEMPT SMP ARM
 Modules linked in: btwilink wl12xx wlcore mac80211 cfg80211 rfcomm bnep bluo
 CPU: 0    Tainted: G        W     (3.4.0+ #15)
 PC is at st_int_recv+0x278/0x344
 LR is at get_parent_ip+0x14/0x30
 pc : [<c03b01a8>]    lr : [<c007273c>]    psr: 200f0193
 sp : dc631ed0  ip : e3e21c24  fp : dc631f04
 r10: 00000000  r9 : 600f0113  r8 : 0000003f
 r7 : e3e21b14  r6 : 00000067  r5 : e2e49c1c  r4 : e3e21a80
 r3 : 00000001  r2 : 00000001  r1 : 00000001  r0 : 600f0113
 Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
 Control: 10c5387d  Table: 9c50004a  DAC: 00000015

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ti-st/st_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check drivers/misc/ti-st/st_core.c
--- a/drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check
+++ a/drivers/misc/ti-st/st_core.c
@@ -343,7 +343,7 @@ void st_int_recv(void *disc_data,
 			/* Unknow packet? */
 		default:
 			type = *ptr;
-			if (st_gdata->list[type] == NULL) {
+			if (type >= ST_MAX_CHANNELS || st_gdata->list[type] == NULL) {
 				pr_err("chip/interface misbehavior dropping"
 					" frame starting with 0x%02x", type);
 				goto done;
_

Patches currently in -mm which might be from gustavo@padovan.org are

drivers-misc-ti-st-st_corec-fix-null-dereference-on-protocol-type-check.patch

