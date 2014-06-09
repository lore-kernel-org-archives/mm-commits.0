From: akpm@linux-foundation.org
Subject: [merged]
 random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:48 -0700
Message-ID: <53960d48.ql9ajVrPBnZUH6ed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:48 -0700


The patch titled
     Subject: random: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: random: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/random.c~random-convert-use-of-typedef-ctl_table-to-struct-ctl_table drivers/char/random.c
--- a/drivers/char/random.c~random-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/drivers/char/random.c
@@ -1582,10 +1582,10 @@ static int proc_do_uuid(struct ctl_table
 /*
  * Return entropy available scaled to integral bits
  */
-static int proc_do_entropy(ctl_table *table, int write,
+static int proc_do_entropy(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	ctl_table fake_table;
+	struct ctl_table fake_table;
 	int entropy_count;
 
 	entropy_count = *(int *)table->data >> ENTROPY_SHIFT;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

