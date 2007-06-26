From: akpm@linux-foundation.org
Subject: + jprobes-make-struct-jprobeentry-a-void.patch added to -mm tree
Date: Mon, 25 Jun 2007 19:04:31 -0700
Message-ID: <200706260204.l5Q24VDQ016158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbXFZCEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 22:04:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com


The patch titled
     jprobes: make struct jprobe.entry a void *
has been added to the -mm tree.  Its filename is
     jprobes-make-struct-jprobeentry-a-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
