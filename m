From: akpm@linux-foundation.org
Subject: - jprobes-make-struct-jprobeentry-a-void.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:32 -0700
Message-ID: <200707192001.l6JK1WSY019546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224AbXGSU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jprobes: make struct jprobe.entry a void *
has been removed from the -mm tree.  Its filename was
     jprobes-make-struct-jprobeentry-a-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jprobes: make struct jprobe.entry a void *
From: Michael Ellerman <michael@ellerman.id.au>

Currently jprobe.entry is a kprobe_opcode_t *, but that's a lie.  On some
platforms it doesn't point to an opcode at all, it points to a function
descriptor.

It's really a pointer to something that the arch code can turn into a function
entry point.  And that's what actually happens, none of the generic code ever
looks at jprobe.entry, it's only ever dereferenced by arch code.

So just make it a void *.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kprobes.h~jprobes-make-struct-jprobeentry-a-void include/linux/kprobes.h
--- a/include/linux/kprobes.h~jprobes-make-struct-jprobeentry-a-void
+++ a/include/linux/kprobes.h
@@ -116,7 +116,7 @@ struct kprobe {
  */
 struct jprobe {
 	struct kprobe kp;
-	kprobe_opcode_t *entry;	/* probe handling code to jump to */
+	void *entry;	/* probe handling code to jump to */
 };
 
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
