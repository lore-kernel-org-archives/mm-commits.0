Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEABABE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628259; cv=none; b=KKNISt8iIH8ZsE+1MoAAI9EJl22UKh/15bUjNPOqzikmiWoW8LxdDUVaxC12qoRYEQ4rV+kyL/wz6fHoxj4dzC1SH1DnGkEIzKpspp52PWXEAaMYJ7TLvuuMsxMhh+DtzQBvmNL/oZNrDZjXGVV6QjT4K+P1Eh0xIgri88Ye5Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628259; c=relaxed/simple;
	bh=wW/J7DRu0vZ74BycxTb+p9BJVVAK8qP+N4ayUSxLWtk=;
	h=Date:To:From:Subject:Message-Id; b=RhPkwMliB48CZXcM5+EZ27GY8UaWv0YuiDWNvUZukRIDDtwvAc5C6AsAOQvVTLXpjc1NIBhZTrBhwiweIP8y5OHGYPTYvDFPkwPJbC7PSUWBXqMKCrBV9iYeig+OCe0ktMWj8+qNDK1KzVXKUK2hWKj0fIQAZIfnCwB799BDB7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UaKHyIDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UaKHyIDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3948C116B1;
	Sat, 29 Jun 2024 02:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628259;
	bh=wW/J7DRu0vZ74BycxTb+p9BJVVAK8qP+N4ayUSxLWtk=;
	h=Date:To:From:Subject:From;
	b=UaKHyIDTU+BawGpg8zJ7Eq6xtKCcsY9LiKZ6SmBfYoz1V52kAG+aHxYufnW/1auJ+
	 AD+8MPYmFFo4MgOZcwyZ7ouHO7wgc4xdgkHfq2WRovl0CpIIlyVsqBihtBbnnUG2YU
	 C9cxt/6ni0CEsltAJR3ZNuJcEJoInZLAaudmWFxY=
Date: Fri, 28 Jun 2024 19:30:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-disable-kmsan-when-checking-the-canary.patch removed from -mm tree
Message-Id: <20240629023059.A3948C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kfence: disable KMSAN when checking the canary
has been removed from the -mm tree.  Its filename was
     mm-kfence-disable-kmsan-when-checking-the-canary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: mm: kfence: disable KMSAN when checking the canary
Date: Fri, 21 Jun 2024 13:35:03 +0200

KMSAN warns about check_canary() accessing the canary.

The reason is that, even though set_canary() is properly instrumented and
sets shadow, slub explicitly poisons the canary's address range
afterwards.

Unpoisoning the canary is not the right thing to do: only check_canary()
is supposed to ever touch it.  Instead, disable KMSAN checks around canary
read accesses.

Link: https://lkml.kernel.org/r/20240621113706.315500-20-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
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

 mm/kfence/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-disable-kmsan-when-checking-the-canary
+++ a/mm/kfence/core.c
@@ -305,8 +305,14 @@ metadata_update_state(struct kfence_meta
 	WRITE_ONCE(meta->state, next);
 }
 
+#ifdef CONFIG_KMSAN
+#define check_canary_attributes noinline __no_kmsan_checks
+#else
+#define check_canary_attributes inline
+#endif
+
 /* Check canary byte at @addr. */
-static inline bool check_canary_byte(u8 *addr)
+static check_canary_attributes bool check_canary_byte(u8 *addr)
 {
 	struct kfence_metadata *meta;
 	unsigned long flags;
@@ -341,7 +347,8 @@ static inline void set_canary(const stru
 		*((u64 *)addr) = KFENCE_CANARY_PATTERN_U64;
 }
 
-static inline void check_canary(const struct kfence_metadata *meta)
+static check_canary_attributes void
+check_canary(const struct kfence_metadata *meta)
 {
 	const unsigned long pageaddr = ALIGN_DOWN(meta->addr, PAGE_SIZE);
 	unsigned long addr = pageaddr;
_

Patches currently in -mm which might be from iii@linux.ibm.com are


