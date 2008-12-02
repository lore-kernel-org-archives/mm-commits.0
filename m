From: akpm@linux-foundation.org
Subject: - sgi-gru-call-fs_initcall-if-statically-linked.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:31:18 -0800
Message-ID: <200812021831.mB2IVIIj002935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYLBSgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:36:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: call fs_initcall() if statically linked
has been removed from the -mm tree.  Its filename was
     sgi-gru-call-fs_initcall-if-statically-linked.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: call fs_initcall() if statically linked
From: Dean Nelson <dcn@sgi.com>

If xpc.ko and gru.ko are both statically linked into the kernel, then
xpc_init() can get called before gru_init() and make a call to one of the
gru's exported functions before the gru has initialized itself.  The end
result is a NULL dereference.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-call-fs_initcall-if-statically-linked drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-call-fs_initcall-if-statically-linked
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -481,7 +481,11 @@ struct vm_operations_struct gru_vm_ops =
 	.fault		= gru_fault,
 };
 
+#ifndef MODULE
+fs_initcall(gru_init);
+#else
 module_init(gru_init);
+#endif
 module_exit(gru_exit);
 
 module_param(gru_options, ulong, 0644);
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-gru-call-fs_initcall-if-statically-linked.patch
linux-next.patch

