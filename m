From: akpm@linux-foundation.org
Subject: + percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch added to -mm tree
Date: Fri, 29 Oct 2010 12:16:32 -0700
Message-ID: <201010291916.o9TJGWhv012214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757050Ab0J2TRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 15:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com, eric.dumazet@gmail.com


The patch titled
     percpu_counter: optimize __percpu_counter_add a bit through the use of this_cpu operations
has been added to the -mm tree.  Its filename is
     percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch

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
Subject: percpu_counter: optimize __percpu_counter_add a bit through the use of this_cpu operations
From: Christoph Lameter <cl@linux.com>

this_cpu_* operations can be used to optimize __percpu_counter_add a bit. 
Avoids some address arithmetic and saves 12 bytes.

Before:

00000000000001d3 <__percpu_counter_add>:
 1d3:	55                   	push   %rbp
 1d4:	48 89 e5             	mov    %rsp,%rbp
 1d7:	41 55                	push   %r13
 1d9:	41 54                	push   %r12
 1db:	53                   	push   %rbx
 1dc:	48 89 fb             	mov    %rdi,%rbx
 1df:	48 83 ec 08          	sub    $0x8,%rsp
 1e3:	4c 8b 67 30          	mov    0x30(%rdi),%r12
 1e7:	65 4c 03 24 25 00 00 	add    %gs:0x0,%r12
 1ee:	00 00
 1f0:	4d 63 2c 24          	movslq (%r12),%r13
 1f4:	48 63 c2             	movslq %edx,%rax
 1f7:	49 01 f5             	add    %rsi,%r13
 1fa:	49 39 c5             	cmp    %rax,%r13
 1fd:	7d 0a                	jge    209 <__percpu_counter_add+0x36>
 1ff:	f7 da                	neg    %edx
 201:	48 63 d2             	movslq %edx,%rdx
 204:	49 39 d5             	cmp    %rdx,%r13
 207:	7f 1e                	jg     227 <__percpu_counter_add+0x54>
 209:	48 89 df             	mov    %rbx,%rdi
 20c:	e8 00 00 00 00       	callq  211 <__percpu_counter_add+0x3e>
 211:	4c 01 6b 18          	add    %r13,0x18(%rbx)
 215:	48 89 df             	mov    %rbx,%rdi
 218:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
 21f:	00
 220:	e8 00 00 00 00       	callq  225 <__percpu_counter_add+0x52>
 225:	eb 04                	jmp    22b <__percpu_counter_add+0x58>
 227:	45 89 2c 24          	mov    %r13d,(%r12)
 22b:	5b                   	pop    %rbx
 22c:	5b                   	pop    %rbx
 22d:	41 5c                	pop    %r12
 22f:	41 5d                	pop    %r13
 231:	c9                   	leaveq
 232:	c3                   	retq

After:

00000000000001d3 <__percpu_counter_add>:
 1d3:	55                   	push   %rbp
 1d4:	48 63 ca             	movslq %edx,%rcx
 1d7:	48 89 e5             	mov    %rsp,%rbp
 1da:	41 54                	push   %r12
 1dc:	53                   	push   %rbx
 1dd:	48 89 fb             	mov    %rdi,%rbx
 1e0:	48 8b 47 30          	mov    0x30(%rdi),%rax
 1e4:	65 44 8b 20          	mov    %gs:(%rax),%r12d
 1e8:	4d 63 e4             	movslq %r12d,%r12
 1eb:	49 01 f4             	add    %rsi,%r12
 1ee:	49 39 cc             	cmp    %rcx,%r12
 1f1:	7d 0a                	jge    1fd <__percpu_counter_add+0x2a>
 1f3:	f7 da                	neg    %edx
 1f5:	48 63 d2             	movslq %edx,%rdx
 1f8:	49 39 d4             	cmp    %rdx,%r12
 1fb:	7f 21                	jg     21e <__percpu_counter_add+0x4b>
 1fd:	48 89 df             	mov    %rbx,%rdi
 200:	e8 00 00 00 00       	callq  205 <__percpu_counter_add+0x32>
 205:	4c 01 63 18          	add    %r12,0x18(%rbx)
 209:	48 8b 43 30          	mov    0x30(%rbx),%rax
 20d:	48 89 df             	mov    %rbx,%rdi
 210:	65 c7 00 00 00 00 00 	movl   $0x0,%gs:(%rax)
 217:	e8 00 00 00 00       	callq  21c <__percpu_counter_add+0x49>
 21c:	eb 04                	jmp    222 <__percpu_counter_add+0x4f>
 21e:	65 44 89 20          	mov    %r12d,%gs:(%rax)
 222:	5b                   	pop    %rbx
 223:	41 5c                	pop    %r12
 225:	c9                   	leaveq
 226:	c3                   	retq

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN lib/percpu_counter.c~percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations
+++ a/lib/percpu_counter.c
@@ -72,18 +72,16 @@ EXPORT_SYMBOL(percpu_counter_set);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
-	s32 *pcount;
 
 	preempt_disable();
-	pcount = this_cpu_ptr(fbc->counters);
-	count = *pcount + amount;
+	count = this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
 		fbc->count += count;
-		*pcount = 0;
+		this_cpu_write(*fbc->counters, 0);
 		spin_unlock(&fbc->lock);
 	} else {
-		*pcount = count;
+		this_cpu_write(*fbc->counters, count);
 	}
 	preempt_enable();
 }
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch

