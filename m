From: akpm@linux-foundation.org
Subject: + jprobes-make-jprobes-a-little-safer-for-users-fix.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:04:44 -0700
Message-ID: <200706260304.l5Q34i1J017001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbXFZDFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com


The patch titled
     Add a prototype for arch_deref_entry_point()
has been added to the -mm tree.  Its filename is
     jprobes-make-jprobes-a-little-safer-for-users-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add a prototype for arch_deref_entry_point()
From: Michael Ellerman <michael@ellerman.id.au>

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kprobes.h~jprobes-make-jprobes-a-little-safer-for-users-fix include/linux/kprobes.h
--- a/include/linux/kprobes.h~jprobes-make-jprobes-a-little-safer-for-users-fix
+++ a/include/linux/kprobes.h
@@ -214,6 +214,7 @@ int longjmp_break_handler(struct kprobe 
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
 void jprobe_return(void);
+unsigned long arch_deref_entry_point(void *);
 
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
_

Patches currently in -mm which might be from michael@ellerman.id.au are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
