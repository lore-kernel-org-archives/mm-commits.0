From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-host-xhci-memc-introduce-missing-kfree.patch removed from -mm tree
Date: Wed, 09 Dec 2009 11:50:07 -0800
Message-ID: <200912091950.nB9Jo7pf029574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757334AbZLITuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 14:50:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/host/xhci-mem.c: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-usb-host-xhci-memc-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/host/xhci-mem.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/xhci-mem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/usb/host/xhci-mem.c~drivers-usb-host-xhci-memc-introduce-missing-kfree drivers/usb/host/xhci-mem.c
--- a/drivers/usb/host/xhci-mem.c~drivers-usb-host-xhci-memc-introduce-missing-kfree
+++ a/drivers/usb/host/xhci-mem.c
@@ -779,14 +779,17 @@ struct xhci_command *xhci_alloc_command(
 
 	command->in_ctx =
 		xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_INPUT, mem_flags);
-	if (!command->in_ctx)
+	if (!command->in_ctx) {
+		kfree(command);
 		return NULL;
+	}
 
 	if (allocate_completion) {
 		command->completion =
 			kzalloc(sizeof(struct completion), mem_flags);
 		if (!command->completion) {
 			xhci_free_container_ctx(xhci, command->in_ctx);
+			kfree(command);
 			return NULL;
 		}
 		init_completion(command->completion);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-cpuidle-move-dereference-after-null-test.patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-function.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-edac-introduce-missing-kfree.patch

