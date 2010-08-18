From: akpm@linux-foundation.org
Subject: + kfifo-fix-kernel-bug-in-dma-example.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:54:12 -0700
Message-ID: <201008181854.o7IIsCE1006095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757Ab0HRSzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, stefani@seibold.net


The patch titled
     kfifo: fix kernel BUG in dma example
has been added to the -mm tree.  Its filename is
     kfifo-fix-kernel-bug-in-dma-example.patch

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
Subject: kfifo: fix kernel BUG in dma example
From: Andrea Righi <arighi@develer.com>

The scatterlist is used uninitialized in kfifo_dma_in_prepare().  This
triggers the following bug if CONFIG_DEBUG_SG=y:

  ------------[ cut here ]------------
  kernel BUG at include/linux/scatterlist.h:65!
  invalid opcode: 0000 [#1] PREEMPT SMP
  ...
  Call Trace:
   [<ffffffff810a1eab>] setup_sgl+0x6b/0xe0
   [<ffffffffa03d7000>] ? example_init+0x0/0x265 [dma_example]
   [<ffffffff810a2021>] __kfifo_dma_in_prepare+0x21/0x30
   [<ffffffffa03d7124>] example_init+0x124/0x265 [dma_example]
   [<ffffffff810f9c55>] ? trace_module_notify+0x25/0x370
   [<ffffffff81110c6e>] ? free_pages_prepare+0x11e/0x1e0
   [<ffffffff8106f2b1>] ? get_parent_ip+0x11/0x50
   [<ffffffff810f9c55>] ? trace_module_notify+0x25/0x370
   [<ffffffff810b65fd>] ? trace_hardirqs_on+0xd/0x10
   [<ffffffff814beade>] ? mutex_unlock+0xe/0x10
   [<ffffffff810f9c71>] ? trace_module_notify+0x41/0x370
   [<ffffffff810a77d5>] ? __blocking_notifier_call_chain+0x45/0x80
   [<ffffffff81137b7a>] ? vfree+0x2a/0x30
   [<ffffffff810a6ac3>] ? up_read+0x23/0x40
   [<ffffffff810a77f5>] ? __blocking_notifier_call_chain+0x65/0x80
   [<ffffffff810001e3>] do_one_initcall+0x43/0x180
   [<ffffffff810c577a>] sys_init_module+0xba/0x200
   [<ffffffff8103819b>] system_call_fastpath+0x16/0x1b
  RIP  [<ffffffff810a1e31>] setup_sgl_buf+0x1a1/0x1b0
   RSP <ffff88006720dc98>
  ---[ end trace a72b979fd3c1d3a5 ]---

Add the proper initialization to avoid the bug.

Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/dma-example.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN samples/kfifo/dma-example.c~kfifo-fix-kernel-bug-in-dma-example samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-fix-kernel-bug-in-dma-example
+++ a/samples/kfifo/dma-example.c
@@ -45,6 +45,7 @@ static int __init example_init(void)
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&fifo));
 
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = kfifo_dma_in_prepare(&fifo, sg, ARRAY_SIZE(sg), FIFO_SIZE);
 	printk(KERN_INFO "DMA sgl entries: %d\n", ret);
 
_

Patches currently in -mm which might be from arighi@develer.com are

kfifo-implement-missing-__kfifo_skip_r.patch
kfifo-add-kfifo_skip-testcase.patch
kfifo-add-explicit-error-checking-in-byte-stream-example.patch
kfifo-fix-kernel-bug-in-dma-example.patch
kfifo-fix-a-memory-leak-in-dma-example.patch
kfifo-add-explicit-error-checking-in-all-the-examples.patch

