From: akpm@linux-foundation.org
Subject: + kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch added to -mm tree
Date: Fri, 23 Aug 2013 15:52:50 -0700
Message-ID: <5217e7c2.3iBGkxwA7JlZNLDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3HWWwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 18:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com, heiko.carstens@de.ibm.com

Subject: + kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch added to -mm tree
To: heiko.carstens@de.ibm.com,ananth@in.ibm.com,masami.hiramatsu.pt@hitachi.com,mingo@kernel.org,schwidefsky@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 15:52:50 -0700


The patch titled
     Subject: kprobes: allow to specify custum allocator for insn caches
has been added to the -mm tree.  Its filename is
     kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: kprobes: allow to specify custum allocator for insn caches

The current two insn slot caches both use module_alloc/module_free to
allocate and free insn slot cache pages.

For s390 this is not sufficient since there is the need to allocate insn
slots that are either within the vmalloc module area or within dma memory.

Therefore add a mechanism which allows to specify an own allocator for an
own insn slot cache.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    2 ++
 kernel/kprobes.c        |   20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-allow-to-specify-custum-allocator-for-insn-caches include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-allow-to-specify-custum-allocator-for-insn-caches
+++ a/include/linux/kprobes.h
@@ -268,6 +268,8 @@ extern void kprobes_inc_nmissed_count(st
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
+	void *(*alloc)(void);	/* allocate insn page */
+	void (*free)(void *);	/* free insn page */
 	struct list_head pages; /* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
diff -puN kernel/kprobes.c~kprobes-allow-to-specify-custum-allocator-for-insn-caches kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-allow-to-specify-custum-allocator-for-insn-caches
+++ a/kernel/kprobes.c
@@ -112,6 +112,7 @@ static struct kprobe_blackpoint kprobe_b
 struct kprobe_insn_page {
 	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
+	struct kprobe_insn_cache *cache;
 	int nused;
 	int ngarbage;
 	char slot_used[];
@@ -132,8 +133,20 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };
 
+static void *alloc_insn_page(void)
+{
+	return module_alloc(PAGE_SIZE);
+}
+
+static void free_insn_page(void *page)
+{
+	module_free(NULL, page);
+}
+
 struct kprobe_insn_cache kprobe_insn_slots = {
 	.mutex = __MUTEX_INITIALIZER(kprobe_insn_slots.mutex),
+	.alloc = alloc_insn_page,
+	.free = free_insn_page,
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
@@ -182,7 +195,7 @@ kprobe_opcode_t __kprobes *__get_insn_sl
 	 * kernel image and loaded module images reside. This is required
 	 * so x86_64 can correctly handle the %rip-relative fixups.
 	 */
-	kip->insns = module_alloc(PAGE_SIZE);
+	kip->insns = c->alloc();
 	if (!kip->insns) {
 		kfree(kip);
 		goto out;
@@ -192,6 +205,7 @@ kprobe_opcode_t __kprobes *__get_insn_sl
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	kip->cache = c;
 	list_add(&kip->list, &c->pages);
 	slot = kip->insns;
 out:
@@ -213,7 +227,7 @@ static int __kprobes collect_one_slot(st
 		 */
 		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
-			module_free(NULL, kip->insns);
+			kip->cache->free(kip->insns);
 			kfree(kip);
 		}
 		return 1;
@@ -274,6 +288,8 @@ out:
 /* For optimized_kprobe buffer */
 struct kprobe_insn_cache kprobe_optinsn_slots = {
 	.mutex = __MUTEX_INITIALIZER(kprobe_optinsn_slots.mutex),
+	.alloc = alloc_insn_page,
+	.free = free_insn_page,
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

kprobes-unify-insn-caches.patch
kprobes-allow-to-specify-custum-allocator-for-insn-caches.patch
s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch
linux-next.patch

