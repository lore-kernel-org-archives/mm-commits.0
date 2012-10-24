From: akpm@linux-foundation.org
Subject: [to-be-updated] random-fix-debug-format-strings.patch removed from -mm tree
Date: Wed, 24 Oct 2012 12:23:43 -0700
Message-ID: <20121024192345.9170D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54149 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2JXTXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 15:23:48 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so58904wey.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 12:23:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random: fix debug format strings
has been removed from the -mm tree.  Its filename was
     random-fix-debug-format-strings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: random: fix debug format strings

Fix the following warnings in formatting debug output:

drivers/char/random.c: In function `xfer_secondary_pool':
drivers/char/random.c:827: warning: format `%d' expects type `int', but argument 7 has type `size_t'
drivers/char/random.c: In function `account':
drivers/char/random.c:859: warning: format `%d' expects type `int', but argument 5 has type `size_t'
drivers/char/random.c:881: warning: format `%d' expects type `int', but argument 5 has type `size_t'
drivers/char/random.c: In function `random_read':
drivers/char/random.c:1141: warning: format `%d' expects type `int', but argument 5 has type `ssize_t'
drivers/char/random.c:1145: warning: format `%d' expects type `int', but argument 5 has type `ssize_t'
drivers/char/random.c:1145: warning: format `%d' expects type `int', but argument 6 has type `long unsigned int'

by using '%zd' instead of '%d' to properly denote ssize_t/size_t conversion.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/random.c~random-fix-debug-format-strings drivers/char/random.c
--- a/drivers/char/random.c~random-fix-debug-format-strings
+++ a/drivers/char/random.c
@@ -825,7 +825,7 @@ static void xfer_secondary_pool(struct e
 		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
-			  "(%d of %d requested)\n",
+			  "(%zd of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
@@ -856,7 +856,7 @@ static size_t account(struct entropy_sto
 	spin_lock_irqsave(&r->lock, flags);
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-	DEBUG_ENT("trying to extract %d bits from %s\n",
+	DEBUG_ENT("trying to extract %zd bits from %s\n",
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
@@ -878,7 +878,7 @@ static size_t account(struct entropy_sto
 		}
 	}
 
-	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
+	DEBUG_ENT("debiting %zd entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1138,11 +1138,11 @@ random_read(struct file *file, char __us
 		if (n > SEC_XFER_SIZE)
 			n = SEC_XFER_SIZE;
 
-		DEBUG_ENT("reading %d bits\n", n*8);
+		DEBUG_ENT("reading %zd bits\n", n*8);
 
 		n = extract_entropy_user(&blocking_pool, buf, n);
 
-		DEBUG_ENT("read got %d bits (%d still needed)\n",
+		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
 			  n*8, (nbytes-n)*8);
 
 		if (n == 0) {
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
random-make-it-possible-to-enable-debugging-without-rebuild.patch
random-fix-debug-format-strings-fix.patch

