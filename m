Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192EC13DDC3
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721847819; cv=none; b=bgGrmSL+GP3lLLJqLEta2aTiDMmyxNgcwqJmM/wK8hYbRmDfiC5Sp+xZYEBaM6CfmbAI+Xb+1tWtsDGgXbxnUfkxXCdPuTaJaL5rclE02HuQFNBIajsxDdWzVW2VaWU/d95d8VpyOcXpsZK6TdU8UYnROYCVh7UjVL3O6s96wgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721847819; c=relaxed/simple;
	bh=N42BL9190ZRSLrMa7qK3UHO3XgWKA+qzGz9NLwJiwto=;
	h=Date:To:From:Subject:Message-Id; b=lo87ywQV2ZhpcWupThM/A67FxlJONkRP5vYaYaUifYwSEJH4dpv5Nu4EEJWUDx7HugaivJYhCtCzlzyEgCml1KI9mGVUfazP1R3sHxvl2XNoFq6HrSevOUNckKlwx3EmhAkotT5jF69ym2C6YxkWVnt14TuPr8wNm4B+6Vr2XRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cDx8I6/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cDx8I6/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8197AC32781;
	Wed, 24 Jul 2024 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721847818;
	bh=N42BL9190ZRSLrMa7qK3UHO3XgWKA+qzGz9NLwJiwto=;
	h=Date:To:From:Subject:From;
	b=cDx8I6/svPr0Kql7Txyb9BqDrtb2w/V+JQBcAaqhsT7ZBeGDgxld9mJKRDn6a5sQa
	 QKZoy0r7ei+WCGc+Kh3PLcJOO50JjLT7QkR461UcfR4qCuZo7auyhBPnc7HqonCsXG
	 22Rw1vguqfwPwtFvts18MRoaulscKSxpZKV9kBSE=
Date: Wed, 24 Jul 2024 12:03:37 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,andreyknvl@gmail.com,42.hyeyoo@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch added to mm-unstable branch
Message-Id: <20240724190338.8197AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: catch invalid free before SLUB reinitializes the object
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kasan: catch invalid free before SLUB reinitializes the object
Date: Wed, 24 Jul 2024 18:34:12 +0200

Patch series "allow KASAN to detect UAF in SLAB_TYPESAFE_BY_RCU slabs",
v2.


The purpose of the series is to allow KASAN to detect use-after-free
access in SLAB_TYPESAFE_BY_RCU slab caches, by essentially making them
behave as if the cache was not SLAB_TYPESAFE_BY_RCU but instead every
kfree() in the cache was a kfree_rcu().  This is gated behind a config
flag that is supposed to only be enabled in fuzzing/testing builds where
the performance impact doesn't matter.

Patch 1/2 is new; it's some necessary prep work for the main patch to
work, though the KASAN integration maybe is a bit ugly.  Patch 2/2 is a
rebased version of the old patch, with some changes to how the config is
wired up, with poison/unpoison logic added as suggested by dvyukov@ back
then, with cache destruction fixed using rcu_barrier() as pointed out by
dvyukov@ and the test robot, and a test added as suggested by elver@.

Output of the new kunit testcase I added to the KASAN test suite:
==================================================================
BUG: KASAN: slab-use-after-free in kmem_cache_rcu_uaf+0x3ae/0x4d0
Read of size 1 at addr ffff88810d3c8000 by task kunit_try_catch/225

CPU: 7 PID: 225 Comm: kunit_try_catch Tainted: G    B            N 6.10.0-00003-gf0fc688e25ed #422
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 print_report+0xce/0x670
[...]
 kasan_report+0xa5/0xe0
[...]
 kmem_cache_rcu_uaf+0x3ae/0x4d0
[...]
 kunit_try_run_case+0x1b3/0x490
[...]
 kunit_generic_run_threadfn_adapter+0x80/0xe0
 kthread+0x2a5/0x370
[...]
 ret_from_fork+0x34/0x70
[...]
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 225:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x6e/0x70
 kmem_cache_alloc_noprof+0xef/0x2b0
 kmem_cache_rcu_uaf+0x10d/0x4d0
 kunit_try_run_case+0x1b3/0x490
 kunit_generic_run_threadfn_adapter+0x80/0xe0
 kthread+0x2a5/0x370
 ret_from_fork+0x34/0x70
 ret_from_fork_asm+0x1a/0x30

Freed by task 0:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x47/0x70
 slab_free_after_rcu_debug+0xee/0x240
 rcu_core+0x676/0x15b0
 handle_softirqs+0x22f/0x690
 irq_exit_rcu+0x84/0xb0
 sysvec_apic_timer_interrupt+0x6a/0x80
 asm_sysvec_apic_timer_interrupt+0x1a/0x20

Last potentially related work creation:
 kasan_save_stack+0x33/0x60
 __kasan_record_aux_stack+0x8e/0xa0
 __call_rcu_common.constprop.0+0x70/0xa70
 kmem_cache_rcu_uaf+0x16e/0x4d0
 kunit_try_run_case+0x1b3/0x490
 kunit_generic_run_threadfn_adapter+0x80/0xe0
 kthread+0x2a5/0x370
 ret_from_fork+0x34/0x70
 ret_from_fork_asm+0x1a/0x30

The buggy address belongs to the object at ffff88810d3c8000
 which belongs to the cache test_cache of size 200
The buggy address is located 0 bytes inside of
 freed 200-byte region [ffff88810d3c8000, ffff88810d3c80c8)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10d3c8
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x200000000000040(head|node=0|zone=2)
page_type: 0xffffefff(slab)
raw: 0200000000000040 ffff88810d3c2000 dead000000000122 0000000000000000
raw: 0000000000000000 00000000801f001f 00000001ffffefff 0000000000000000
head: 0200000000000040 ffff88810d3c2000 dead000000000122 0000000000000000
head: 0000000000000000 00000000801f001f 00000001ffffefff 0000000000000000
head: 0200000000000001 ffffea000434f201 ffffffffffffffff 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88810d3c7f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88810d3c7f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88810d3c8000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88810d3c8080: fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc
 ffff88810d3c8100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
    ok 38 kmem_cache_rcu_uaf


This patch (of 2):

Currently, when KASAN is combined with init-on-free behavior, the
initialization happens before KASAN's "invalid free" checks.

More importantly, a subsequent commit will want to use the object metadata
region to store an rcu_head, and we should let KASAN check that the object
pointer is valid before that.  (Otherwise that change will make the
existing testcase kmem_cache_invalid_free fail.)

So add a new KASAN hook that allows KASAN to pre-validate a
kmem_cache_free() operation before SLUB actually starts modifying the
object or its metadata.

Link: https://lkml.kernel.org/r/20240724-kasan-tsbrcu-v2-0-45f898064468@google.com
Link: https://lkml.kernel.org/r/20240724-kasan-tsbrcu-v2-1-45f898064468@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   10 +++++++
 mm/kasan/common.c     |   51 ++++++++++++++++++++++++++++++----------
 mm/slub.c             |    7 +++++
 3 files changed, 56 insertions(+), 12 deletions(-)

--- a/include/linux/kasan.h~kasan-catch-invalid-free-before-slub-reinitializes-the-object
+++ a/include/linux/kasan.h
@@ -175,6 +175,16 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
+bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
+			unsigned long ip);
+static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
+						void *object)
+{
+	if (kasan_enabled())
+		return __kasan_slab_pre_free(s, object, _RET_IP_);
+	return false;
+}
+
 bool __kasan_slab_free(struct kmem_cache *s, void *object,
 			unsigned long ip, bool init);
 static __always_inline bool kasan_slab_free(struct kmem_cache *s,
--- a/mm/kasan/common.c~kasan-catch-invalid-free-before-slub-reinitializes-the-object
+++ a/mm/kasan/common.c
@@ -208,31 +208,52 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static inline bool poison_slab_object(struct kmem_cache *cache, void *object,
-				      unsigned long ip, bool init)
+enum free_validation_result {
+	KASAN_FREE_IS_IGNORED,
+	KASAN_FREE_IS_VALID,
+	KASAN_FREE_IS_INVALID
+};
+
+static enum free_validation_result check_slab_free(struct kmem_cache *cache,
+						void *object, unsigned long ip)
 {
-	void *tagged_object;
+	void *tagged_object = object;
 
-	if (!kasan_arch_is_ready())
-		return false;
+	if (is_kfence_address(object) || !kasan_arch_is_ready())
+		return KASAN_FREE_IS_IGNORED;
 
-	tagged_object = object;
 	object = kasan_reset_tag(object);
 
 	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) != object)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
-		return true;
+		return KASAN_FREE_IS_INVALID;
 	}
 
-	/* RCU slabs could be legally used after free within the RCU period. */
-	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
-		return false;
-
 	if (!kasan_byte_accessible(tagged_object)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
-		return true;
+		return KASAN_FREE_IS_INVALID;
 	}
 
+	return KASAN_FREE_IS_VALID;
+}
+
+static inline bool poison_slab_object(struct kmem_cache *cache, void *object,
+				      unsigned long ip, bool init)
+{
+	void *tagged_object = object;
+	enum free_validation_result valid = check_slab_free(cache, object, ip);
+
+	if (valid == KASAN_FREE_IS_IGNORED)
+		return false;
+	if (valid == KASAN_FREE_IS_INVALID)
+		return true;
+
+	object = kasan_reset_tag(object);
+
+	/* RCU slabs could be legally used after free within the RCU period. */
+	if (unlikely(cache->flags & SLAB_TYPESAFE_BY_RCU))
+		return false;
+
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
 
@@ -242,6 +263,12 @@ static inline bool poison_slab_object(st
 	return false;
 }
 
+bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
+				unsigned long ip)
+{
+	return check_slab_free(cache, object, ip) == KASAN_FREE_IS_INVALID;
+}
+
 bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 				unsigned long ip, bool init)
 {
--- a/mm/slub.c~kasan-catch-invalid-free-before-slub-reinitializes-the-object
+++ a/mm/slub.c
@@ -2227,6 +2227,13 @@ bool slab_free_hook(struct kmem_cache *s
 		return false;
 
 	/*
+	 * Give KASAN a chance to notice an invalid free operation before we
+	 * modify the object.
+	 */
+	if (kasan_slab_pre_free(s, x))
+		return false;
+
+	/*
 	 * As memory initialization might be integrated into KASAN,
 	 * kasan_slab_free and initialization memset's must be
 	 * kept together to avoid discrepancies in behavior.
_

Patches currently in -mm which might be from jannh@google.com are

kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch
slub-introduce-config_slub_rcu_debug.patch

