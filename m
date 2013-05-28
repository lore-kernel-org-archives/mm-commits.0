From: akpm@linux-foundation.org
Subject: [merged] drivers-char-randomc-fix-priming-of-last_data.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:37:17 -0700
Message-ID: <51a5076d.M5kh+sM6guKDWf97%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3E1ThS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org, nhorman@tuxdriver.com, mpm@selenic.com, jstodola@redhat.com, jstancek@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net, jarod@redhat.com

Subject: [merged] drivers-char-randomc-fix-priming-of-last_data.patch removed from -mm tree
To: jarod@redhat.com,davem@davemloft.net,herbert@gondor.apana.org.au,jstancek@redhat.com,jstodola@redhat.com,mpm@selenic.com,nhorman@tuxdriver.com,stable@vger.kernel.org,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:17 -0700


The patch titled
     Subject: drivers/char/random.c: fix priming of last_data
has been removed from the -mm tree.  Its filename was
     drivers-char-randomc-fix-priming-of-last_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jarod Wilson <jarod@redhat.com>
Subject: drivers/char/random.c: fix priming of last_data

Commit ec8f02da9e ("random: prime last_data value per fips requirements")
added priming of last_data per fips requirements.  Unfortuantely, it did
so in a way that can lead to multiple threads all incrementing nbytes, but
only one actually doing anything with the extra data, which leads to some
fun random corruption and panics.

The fix is to simply do everything needed to prime last_data in a single
shot, so there's no window for multiple cpus to increment nbytes -- in
fact, we won't even increment or decrement nbytes anymore, we'll just
extract the needed EXTRACT_SIZE one time per pool and then carry on with
the normal routine.

All these changes have been tested across multiple hosts and architectures
where panics were previously encoutered.  The code changes are are
strictly limited to areas only touched when when booted in fips mode.

This change should also go into 3.8-stable, to make the myriads of fips
users on 3.8.x happy.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stodola <jstodola@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/char/random.c~drivers-char-randomc-fix-priming-of-last_data drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomc-fix-priming-of-last_data
+++ a/drivers/char/random.c
@@ -957,10 +957,23 @@ static ssize_t extract_entropy(struct en
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
+	unsigned long flags;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
-	if (fips_enabled && !r->last_data_init)
-		nbytes += EXTRACT_SIZE;
+	if (fips_enabled) {
+		spin_lock_irqsave(&r->lock, flags);
+		if (!r->last_data_init) {
+			r->last_data_init = true;
+			spin_unlock_irqrestore(&r->lock, flags);
+			trace_extract_entropy(r->name, EXTRACT_SIZE,
+					      r->entropy_count, _RET_IP_);
+			xfer_secondary_pool(r, EXTRACT_SIZE);
+			extract_buf(r, tmp);
+			spin_lock_irqsave(&r->lock, flags);
+			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+		}
+		spin_unlock_irqrestore(&r->lock, flags);
+	}
 
 	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
@@ -970,19 +983,6 @@ static ssize_t extract_entropy(struct en
 		extract_buf(r, tmp);
 
 		if (fips_enabled) {
-			unsigned long flags;
-
-
-			/* prime last_data value if need be, per fips 140-2 */
-			if (!r->last_data_init) {
-				spin_lock_irqsave(&r->lock, flags);
-				memcpy(r->last_data, tmp, EXTRACT_SIZE);
-				r->last_data_init = true;
-				nbytes -= EXTRACT_SIZE;
-				spin_unlock_irqrestore(&r->lock, flags);
-				extract_buf(r, tmp);
-			}
