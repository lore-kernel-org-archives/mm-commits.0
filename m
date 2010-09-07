From: akpm@linux-foundation.org
Subject: + drivers-atm-firestreamc-fix-unsigned-return-type.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:47:27 -0700
Message-ID: <201009072347.o87NlR2M013916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab0IGXsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/atm/firestream.c: fix unsigned return type
has been added to the -mm tree.  Its filename is
     drivers-atm-firestreamc-fix-unsigned-return-type.patch

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
Subject: drivers/atm/firestream.c: fix unsigned return type
From: Julia Lawall <julia@diku.dk>

The function has an unsigned return type, but returns a negative constant
to indicate an error condition.  The result of calling the function is
always stored in a variable of type (signed) int, and thus unsigned can be
dropped from the return type.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/firestream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/atm/firestream.c~drivers-atm-firestreamc-fix-unsigned-return-type drivers/atm/firestream.c
--- a/drivers/atm/firestream.c~drivers-atm-firestreamc-fix-unsigned-return-type
+++ a/drivers/atm/firestream.c
@@ -444,8 +444,8 @@ static inline void fs_kfree_skb (struct 
 #define ROUND_NEAREST 3
 /********** make rate (not quite as much fun as Horizon) **********/
 
-static unsigned int make_rate (unsigned int rate, int r,
-			       u16 * bits, unsigned int * actual) 
+static int make_rate(unsigned int rate, int r,
+		      u16 *bits, unsigned int *actual)
 {
 	unsigned char exp = -1; /* hush gcc */
 	unsigned int man = -1;  /* hush gcc */
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
net-9p-trans_fdc-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-atm-firestreamc-fix-unsigned-return-type.patch
drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function.patch

