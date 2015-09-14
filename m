From: akpm@linux-foundation.org
Subject: + lib-fix-data-race-in-llist_del_first.patch added to -mm tree
Date: Mon, 14 Sep 2015 14:59:29 -0700
Message-ID: <55f74341.Ijm+Yacx9TF5OHCw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbINV7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, andreyknvl@google.com, glider@google.com, kcc@google.com, linux@rasmusvillemoes.dk, paulmck@linux.vnet.ibm.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/llist.c: fix data race in llist_del_first
has been added to the -mm tree.  Its filename is
     lib-fix-data-race-in-llist_del_first.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-fix-data-race-in-llist_del_first.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-data-race-in-llist_del_first.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: lib/llist.c: fix data race in llist_del_first

llist_del_first reads entry->next, but it did not acquire visibility over
the entry node.  As the result it can get a stale value of entry->next
(e.g.  NULL or whatever garbage was there before the appending thread
wrote correct value).  And then commit that value as llist head with
cmpxchg.  That will corrupt llist.

Note there is a control-dependency between read of head->first and read of
entry->next, but it does not make the code correct.  Kernel memory model
unambiguously says: "A load-load control dependency requires a full read
memory barrier".

Use smp_load_acquire to acquire visibility over the entry node.

The data race was found with KernelThreadSanitizer (KTSAN).


Here is an example of KTSAN report:

ThreadSanitizer: data-race in llist_del_first

Read of size 1 by thread T389 (K2630, CPU0):
 [<ffffffff8156b8a9>] llist_del_first+0x39/0x70 lib/llist.c:74
 [<     inlined    >] tty_buffer_alloc drivers/tty/tty_buffer.c:181
 [<ffffffff81664af4>] __tty_buffer_request_room+0xb4/0x250 drivers/tty/tty_buffer.c:292
 [<ffffffff81664e6c>] tty_insert_flip_string_fixed_flag+0x6c/0x150 drivers/tty/tty_buffer.c:337
 [<     inlined    >] tty_insert_flip_string include/linux/tty_flip.h:35
 [<ffffffff81667422>] pty_write+0x72/0xc0 drivers/tty/pty.c:110
 [<     inlined    >] process_output_block drivers/tty/n_tty.c:611
 [<ffffffff8165c016>] n_tty_write+0x346/0x7f0 drivers/tty/n_tty.c:2401
 [<     inlined    >] do_tty_write drivers/tty/tty_io.c:1159
 [<ffffffff816568df>] tty_write+0x21f/0x3f0 drivers/tty/tty_io.c:1245
 [<ffffffff8125f00f>] __vfs_write+0x5f/0x1f0 fs/read_write.c:489
 [<ffffffff8125ff8f>] vfs_write+0xef/0x280 fs/read_write.c:538
 [<     inlined    >] SYSC_write fs/read_write.c:585
 [<ffffffff81261390>] SyS_write+0x70/0xe0 fs/read_write.c:577
 [<ffffffff81ee862e>] entry_SYSCALL_64_fastpath+0x12/0x71 arch/x86/entry/entry_64.S:186

Previous write of size 8 by thread T226 (K761, CPU0):
 [<ffffffff8156b832>] llist_add_batch+0x32/0x70 lib/llist.c:44 (discriminator 16)
 [<     inlined    >] llist_add include/linux/llist.h:180
 [<ffffffff816649fc>] tty_buffer_free+0x6c/0xb0 drivers/tty/tty_buffer.c:221
 [<ffffffff816651e7>] flush_to_ldisc+0x107/0x300 drivers/tty/tty_buffer.c:514
 [<ffffffff810b20ee>] process_one_work+0x47e/0x930 kernel/workqueue.c:2036
 [<ffffffff810b2650>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bbe20>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee8a1f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:526

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/llist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/llist.c~lib-fix-data-race-in-llist_del_first lib/llist.c
--- a/lib/llist.c~lib-fix-data-race-in-llist_del_first
+++ a/lib/llist.c
@@ -66,12 +66,12 @@ struct llist_node *llist_del_first(struc
 {
 	struct llist_node *entry, *old_entry, *next;
 
-	entry = head->first;
+	entry = smp_load_acquire(&head->first);
 	for (;;) {
 		if (entry == NULL)
 			return NULL;
 		old_entry = entry;
-		next = entry->next;
+		next = READ_ONCE(entry->next);
 		entry = cmpxchg(&head->first, old_entry, next);
 		if (entry == old_entry)
 			break;
_

Patches currently in -mm which might be from dvyukov@google.com are

lib-fix-data-race-in-llist_del_first.patch

