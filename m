From: akpm@linux-foundation.org
Subject: + sgi-gru-call-gru_init-at-fs_initcall-level.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:25:45 -0800
Message-ID: <200812030825.mB38PjGj013968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbYLCIZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com


The patch titled
     sgi-gru: call gru_init() at fs_initcall() level
has been added to the -mm tree.  Its filename is
     sgi-gru-call-gru_init-at-fs_initcall-level.patch

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
Subject: sgi-gru: call gru_init() at fs_initcall() level
From: Dean Nelson <dcn@sgi.com>

If xpc.ko and gru.ko are both statically linked into the kernel, then
xpc_init() can get called before gru_init() and make a call to one of the
gru's exported functions before the gru has initialized itself. The end
result is a NULL dereference.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufile.c~sgi-gru-call-gru_init-at-fs_initcall-level drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-gru-call-gru_init-at-fs_initcall-level
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -481,7 +481,7 @@ struct vm_operations_struct gru_vm_ops =
 	.fault		= gru_fault,
 };
 
-module_init(gru_init);
+fs_initcall(gru_init);
 module_exit(gru_exit);
 
 module_param(gru_options, ulong, 0644);
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-gru-call-gru_init-at-fs_initcall-level.patch
linux-next.patch

