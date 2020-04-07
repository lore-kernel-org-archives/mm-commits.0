From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 120/166] percpu_counter: fix a data race at
 vm_committed_as
Date: Mon, 06 Apr 2020 20:10:25 -0700
Message-ID: <20200407031025.f94p4szuy%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:27 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, elver@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Qian Cai <cai@lca.pw>
Subject: percpu_counter: fix a data race at vm_committed_as

"vm_committed_as.count" could be accessed concurrently as reported by
KCSAN,

 BUG: KCSAN: data-race in __vm_enough_memory / percpu_counter_add_batch

 write to 0xffffffff9451c538 of 8 bytes by task 65879 on cpu 35:
  percpu_counter_add_batch+0x83/0xd0
  percpu_counter_add_batch at lib/percpu_counter.c:91
  __vm_enough_memory+0xb9/0x260
  dup_mm+0x3a4/0x8f0
  copy_process+0x2458/0x3240
  _do_fork+0xaa/0x9f0
  __do_sys_clone+0x125/0x160
  __x64_sys_clone+0x70/0x90
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 read to 0xffffffff9451c538 of 8 bytes by task 66773 on cpu 19:
  __vm_enough_memory+0x199/0x260
  percpu_counter_read_positive at include/linux/percpu_counter.h:81
  (inlined by) __vm_enough_memory at mm/util.c:839
  mmap_region+0x1b2/0xa10
  do_mmap+0x45c/0x700
  vm_mmap_pgoff+0xc0/0x130
  ksys_mmap_pgoff+0x6e/0x300
  __x64_sys_mmap+0x33/0x40
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The read is outside percpu_counter::lock critical section which results in
a data race.  Fix it by adding a READ_ONCE() in
percpu_counter_read_positive() which could also service as the existing
compiler memory barrier.

Link: http://lkml.kernel.org/r/1582302724-2804-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/percpu_counter.h~percpu_counter-fix-a-data-race-at-vm_committed_as
+++ a/include/linux/percpu_counter.h
@@ -78,9 +78,9 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	/* Prevent reloads of fbc->count */
+	s64 ret = READ_ONCE(fbc->count);
 
-	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
 		return ret;
 	return 0;
_
