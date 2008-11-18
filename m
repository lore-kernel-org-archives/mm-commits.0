From: akpm@linux-foundation.org
Subject: + kernel-trace-tracec-introduce-missing-kfree.patch added to -mm tree
Date: Tue, 18 Nov 2008 14:42:47 -0800
Message-ID: <200811182242.mAIMgl7H000778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbYKRWn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 17:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     kernel/trace/trace.c: introduce missing kfree()
has been added to the -mm tree.  Its filename is
     kernel-trace-tracec-introduce-missing-kfree.patch

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

drivers-video-bad-error-test-before-a-dereference.patch
linux-next.patch
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch
kernel-trace-tracec-introduce-missing-kfree.patch

