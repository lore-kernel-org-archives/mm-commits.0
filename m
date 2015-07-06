From: akpm@linux-foundation.org
Subject: [merged] target-use-kvfree-in-session-alloc-and-free.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:53 -0700
Message-ID: <559adb69.7bGXg9i9N668y+x+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbbGFTrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, nab@linux-iscsi.org, mm-commits@vger.kernel.org


The patch titled
     Subject: target: use kvfree() in session alloc and free
has been removed from the -mm tree.  Its filename was
     target-use-kvfree-in-session-alloc-and-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: target: use kvfree() in session alloc and free

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/target/target_core_transport.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/target/target_core_transport.c~target-use-kvfree-in-session-alloc-and-free drivers/target/target_core_transport.c
--- a/drivers/target/target_core_transport.c~target-use-kvfree-in-session-alloc-and-free
+++ a/drivers/target/target_core_transport.c
@@ -279,10 +279,7 @@ int transport_alloc_session_tags(struct
 	if (rc < 0) {
 		pr_err("Unable to init se_sess->sess_tag_pool,"
 			" tag_num: %u\n", tag_num);
-		if (is_vmalloc_addr(se_sess->sess_cmd_map))
-			vfree(se_sess->sess_cmd_map);
-		else
-			kfree(se_sess->sess_cmd_map);
+		kvfree(se_sess->sess_cmd_map);
 		se_sess->sess_cmd_map = NULL;
 		return -ENOMEM;
 	}
@@ -489,10 +486,7 @@ void transport_free_session(struct se_se
 {
 	if (se_sess->sess_cmd_map) {
 		percpu_ida_destroy(&se_sess->sess_tag_pool);
-		if (is_vmalloc_addr(se_sess->sess_cmd_map))
-			vfree(se_sess->sess_cmd_map);
-		else
-			kfree(se_sess->sess_cmd_map);
+		kvfree(se_sess->sess_cmd_map);
 	}
 	kmem_cache_free(se_sess_cache, se_sess);
 }
_

Patches currently in -mm which might be from penberg@kernel.org are

slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch

