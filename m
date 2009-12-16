From: akpm@linux-foundation.org
Subject: [merged] uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:40:06 -0800
Message-ID: <200912162040.nBGKe6QF013584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965001AbZLPUkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:40:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     UV - XPC: pass nasid instead of nid to gru_create_message_queue
has been removed from the -mm tree.  Its filename was
     uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UV - XPC: pass nasid instead of nid to gru_create_message_queue
From: Robin Holt <holt@sgi.com>

Currently, the UV xpc code is passing nid to the gru_create_message_queue
instead of nasid as it expects.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -207,6 +207,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	enum xp_retval xp_ret;
 	int ret;
 	int nid;
+	int nasid;
 	int pg_order;
 	struct page *page;
 	struct xpc_gru_mq_uv *mq;
@@ -262,9 +263,11 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 		goto out_5;
 	}
 
+	nasid = UV_PNODE_TO_NASID(uv_cpu_to_pnode(cpu));
+
 	mmr_value = (struct uv_IO_APIC_route_entry *)&mq->mmr_value;
 	ret = gru_create_message_queue(mq->gru_mq_desc, mq->address, mq_size,
-				       nid, mmr_value->vector, mmr_value->dest);
+				     nasid, mmr_value->vector, mmr_value->dest);
 	if (ret != 0) {
 		dev_err(xpc_part, "gru_create_message_queue() returned "
 			"error=%d\n", ret);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

