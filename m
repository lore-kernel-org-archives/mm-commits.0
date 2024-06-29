Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DEBE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628251; cv=none; b=mynWJrftBEHJTDrFgm8V/WptOoq4pqxpouQUN73XCnoPjQdD9kWA8LOohUmTugnAINZgVe+SHfG4meWi0lyxXdzNaIryK7El3k9qJh79sBKcxl85qIJWbuEhanhmgHasjQ8JKBDmwaeCz/7vlvxbKASCAPybpMTRw0bU5f6nfxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628251; c=relaxed/simple;
	bh=hmti92g1DtSHO2bLxc1lUObMjWzo2yQWdrWrS0ugFko=;
	h=Date:To:From:Subject:Message-Id; b=Yeu8ryV+vubPzerXoAzGLnoY1mEWRE7Lmlq25xjOwi+imUxKsR/5TC7MQibp3JaPMPw6IhuoRkZ2BsHf0bOcoZ4n6Qir6Z2fsCbEma2bwYNUKfGQ7EcUZvIBrgMY3VjX9RMwuo0utc4jC3VAxVjLgDstTqJfdWsx2n+AL24NYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHUc8POJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHUc8POJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B97C116B1;
	Sat, 29 Jun 2024 02:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628251;
	bh=hmti92g1DtSHO2bLxc1lUObMjWzo2yQWdrWrS0ugFko=;
	h=Date:To:From:Subject:From;
	b=KHUc8POJXEpS9Ec5jrrUOCxUk8urIpPlNlvbWInEgZ4Ohb0w+AGmZsMWJIMBj8wBv
	 Zv4FJvlT4ER5DXCSKqpP8VI6muflMvpnpj4Z7dLD7eyh+fJNiqb3umh3YVAveKNpOu
	 j6rhLqyMwTjNQde4+T7I2ib4seCUNz+4COmkebaA=
Date: Fri, 28 Jun 2024 19:30:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-support-slab_poison.patch removed from -mm tree
Message-Id: <20240629023051.62B97C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: support SLAB_POISON
has been removed from the -mm tree.  Its filename was
     kmsan-support-slab_poison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: support SLAB_POISON
Date: Fri, 21 Jun 2024 13:34:57 +0200

Avoid false KMSAN negatives with SLUB_DEBUG by allowing kmsan_slab_free()
to poison the freed memory, and by preventing init_object() from
unpoisoning new allocations by using __memset().

There are two alternatives to this approach.  First, init_object() can be
marked with __no_sanitize_memory.  This annotation should be used with
great care, because it drops all instrumentation from the function, and
any shadow writes will be lost.  Even though this is not a concern with
the current init_object() implementation, this may change in the future.

Second, kmsan_poison_memory() calls may be added after memset() calls. 
The downside is that init_object() is called from free_debug_processing(),
in which case poisoning will erase the distinction between simply
uninitialized memory and UAF.

Link: https://lkml.kernel.org/r/20240621113706.315500-14-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    2 +-
 mm/slub.c        |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/mm/kmsan/hooks.c~kmsan-support-slab_poison
+++ a/mm/kmsan/hooks.c
@@ -74,7 +74,7 @@ void kmsan_slab_free(struct kmem_cache *
 		return;
 
 	/* RCU slabs could be legally used after free within the RCU period */
-	if (unlikely(s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)))
+	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
 		return;
 	/*
 	 * If there's a constructor, freed memory must remain in the same state
--- a/mm/slub.c~kmsan-support-slab_poison
+++ a/mm/slub.c
@@ -1139,7 +1139,13 @@ static void init_object(struct kmem_cach
 	unsigned int poison_size = s->object_size;
 
 	if (s->flags & SLAB_RED_ZONE) {
-		memset(p - s->red_left_pad, val, s->red_left_pad);
+		/*
+		 * Here and below, avoid overwriting the KMSAN shadow. Keeping
+		 * the shadow makes it possible to distinguish uninit-value
+		 * from use-after-free.
+		 */
+		memset_no_sanitize_memory(p - s->red_left_pad, val,
+					  s->red_left_pad);
 
 		if (slub_debug_orig_size(s) && val == SLUB_RED_ACTIVE) {
 			/*
@@ -1152,12 +1158,13 @@ static void init_object(struct kmem_cach
 	}
 
 	if (s->flags & __OBJECT_POISON) {
-		memset(p, POISON_FREE, poison_size - 1);
-		p[poison_size - 1] = POISON_END;
+		memset_no_sanitize_memory(p, POISON_FREE, poison_size - 1);
+		memset_no_sanitize_memory(p + poison_size - 1, POISON_END, 1);
 	}
 
 	if (s->flags & SLAB_RED_ZONE)
-		memset(p + poison_size, val, s->inuse - poison_size);
+		memset_no_sanitize_memory(p + poison_size, val,
+					  s->inuse - poison_size);
 }
 
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
_

Patches currently in -mm which might be from iii@linux.ibm.com are


