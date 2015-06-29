From: akpm@linux-foundation.org
Subject: [merged] blktrace-use-strreplace-in-do_blk_trace_setup.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:09 -0700
Message-ID: <5591af09.QH1wEF8k/UanqsJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbbF2UsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, axboe@fb.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/trace/blktrace.c: use strreplace() in do_blk_trace_setup()
has been removed from the -mm tree.  Its filename was
     blktrace-use-strreplace-in-do_blk_trace_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/trace/blktrace.c: use strreplace() in do_blk_trace_setup()

Part of the disassembly of do_blk_trace_setup:

    231b:       e8 00 00 00 00          callq  2320 <do_blk_trace_setup+0x50>
                        231c: R_X86_64_PC32     strlen+0xfffffffffffffffc
    2320:       eb 0a                   jmp    232c <do_blk_trace_setup+0x5c>
    2322:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
    2328:       48 83 c3 01             add    $0x1,%rbx
    232c:       48 39 d8                cmp    %rbx,%rax
    232f:       76 47                   jbe    2378 <do_blk_trace_setup+0xa8>
    2331:       41 80 3c 1c 2f          cmpb   $0x2f,(%r12,%rbx,1)
    2336:       75 f0                   jne    2328 <do_blk_trace_setup+0x58>
    2338:       41 c6 04 1c 5f          movb   $0x5f,(%r12,%rbx,1)
    233d:       4c 89 e7                mov    %r12,%rdi
    2340:       e8 00 00 00 00          callq  2345 <do_blk_trace_setup+0x75>
                        2341: R_X86_64_PC32     strlen+0xfffffffffffffffc
    2345:       eb e1                   jmp    2328 <do_blk_trace_setup+0x58>

Yep, that's right: gcc isn't smart enough to realize that replacing '/' by
'_' cannot change the strlen(), so we call it again and again (at least
when a '/' is found).  Even if gcc were that smart, this construction
would still loop over the string twice, once for the initial strlen() call
and then the open-coded loop.

Let's simply use strreplace() instead.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Liked-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/blktrace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/trace/blktrace.c~blktrace-use-strreplace-in-do_blk_trace_setup kernel/trace/blktrace.c
--- a/kernel/trace/blktrace.c~blktrace-use-strreplace-in-do_blk_trace_setup
+++ a/kernel/trace/blktrace.c
@@ -439,7 +439,7 @@ int do_blk_trace_setup(struct request_qu
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
-	int ret, i;
+	int ret;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
@@ -451,9 +451,7 @@ int do_blk_trace_setup(struct request_qu
 	 * some device names have larger paths - convert the slashes
 	 * to underscores for this to work as expected
 	 */
-	for (i = 0; i < strlen(buts->name); i++)
-		if (buts->name[i] == '/')
-			buts->name[i] = '_';
+	strreplace(buts->name, '/', '_');
 
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
 	if (!bt)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

