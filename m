From: akpm@linux-foundation.org
Subject: + uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:32:09 -0800
Message-ID: <200912032232.nB3MW92u005692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZLCWcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, steiner@sgi.com


The patch titled
     UV - XPC: pass nasid instead of nid to gru_create_message_queue
has been added to the -mm tree.  Its filename is
     uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch

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

x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch

