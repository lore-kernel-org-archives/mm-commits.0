From: akpm@linux-foundation.org
Subject: + is_power_of_2-jbd.patch added to -mm tree
Date: Mon, 25 Jun 2007 12:15:44 -0700
Message-ID: <200706251915.l5PJFij1008738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbXFYTQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 15:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com


The patch titled
     is_power_of_2(): jbd
has been added to the -mm tree.  Its filename is
     is_power_of_2-jbd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: is_power_of_2(): jbd
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with
is_power_of_2().

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/revoke.c  |    5 +++--
 fs/jbd2/revoke.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/jbd/revoke.c~is_power_of_2-jbd fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~is_power_of_2-jbd
+++ a/fs/jbd/revoke.c
@@ -68,6 +68,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #endif
+#include <linux/log2.h>
 
 static struct kmem_cache *revoke_record_cache;
 static struct kmem_cache *revoke_table_cache;
@@ -215,7 +216,7 @@ int journal_init_revoke(journal_t *journ
 	journal->j_revoke = journal->j_revoke_table[0];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT(is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
@@ -242,7 +243,7 @@ int journal_init_revoke(journal_t *journ
 	journal->j_revoke = journal->j_revoke_table[1];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT(is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
diff -puN fs/jbd2/revoke.c~is_power_of_2-jbd fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~is_power_of_2-jbd
+++ a/fs/jbd2/revoke.c
@@ -68,6 +68,7 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #endif
+#include <linux/log2.h>
 
 static struct kmem_cache *jbd2_revoke_record_cache;
 static struct kmem_cache *jbd2_revoke_table_cache;
@@ -212,7 +213,7 @@ int jbd2_journal_init_revoke(journal_t *
 	journal->j_revoke = journal->j_revoke_table[0];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT(is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
@@ -239,7 +240,7 @@ int jbd2_journal_init_revoke(journal_t *
 	journal->j_revoke = journal->j_revoke_table[1];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT(is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-ubi.patch
use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-jbd.patch
is_power_of_2-ext4-superc.patch
