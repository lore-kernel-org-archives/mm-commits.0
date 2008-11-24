From: akpm@linux-foundation.org
Subject: - kernel-trace-tracec-introduce-missing-kfree.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:55 -0800
Message-ID: <200811241929.mAOJTtng027943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbYKXTaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:30:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     kernel/trace/trace.c: introduce missing kfree()
has been removed from the -mm tree.  Its filename was
     kernel-trace-tracec-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/trace/trace.c: introduce missing kfree()
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/trace/trace.c~kernel-trace-tracec-introduce-missing-kfree kernel/trace/trace.c
--- a/kernel/trace/trace.c~kernel-trace-tracec-introduce-missing-kfree
+++ a/kernel/trace/trace.c
@@ -2139,6 +2139,7 @@ __tracing_open(struct inode *inode, stru
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
 	mutex_unlock(&trace_types_lock);
+	kfree(iter);
 
 	return ERR_PTR(-ENOMEM);
 }
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch

