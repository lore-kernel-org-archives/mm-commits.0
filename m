From: akpm@linux-foundation.org
Subject: - is_power_of_2-jbd.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:32 -0700
Message-ID: <200707162057.l6GKvWpe002202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174AbXGPVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2(): jbd
has been removed from the -mm tree.  Its filename was
     is_power_of_2-jbd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -211,7 +212,7 @@ int journal_init_revoke(journal_t *journ
 	journal->j_revoke = journal->j_revoke_table[0];
 
 	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
+	J_ASSERT(is_power_of_2(hash_size));
 
 	journal->j_revoke->hash_size = hash_size;
 
@@ -238,7 +239,7 @@ int journal_init_revoke(journal_t *journ
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

origin.patch
git-ubi.patch
git-xfs.patch
is_power_of_2-ext4-superc.patch
