Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260C218D74
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017726; cv=none; b=f36VfhPOmIlv7bAw8o5F1VQKBqp6GxP41wYMN56Vl/6BasbwwHpMHdjYHaRvORYDp0rj/VdLK44kiqkpTWJNHx7Vri86wueEvIf8m+0Mc+N9mMQjiJTizGd/oBeu9HINbilE+Jd2Jr+ai8Xz79iTnX793P/OLrBKO4VM4lsMdyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017726; c=relaxed/simple;
	bh=dDKO4BMOTAuFvxFT6BqDqcdvbotmfAQVAtxgwB4ef4w=;
	h=Date:To:From:Subject:Message-Id; b=cQiEwHjjHG7ofxBIKuPkRI762OtUhjJf5mIcuq9SylGnOKuBBCd7MS9U+FAY9socGpusZDvyq5hisz99vbhjD5VG3dmyKSnG5nIrTi5DYXJKsM3cCrsTCc3V5JCW89tkls5dBn9b8HO2MkmO5XtaN1PfZO2ea6/MIsgCgfammkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFzvmN0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFzvmN0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A48CC4CECC;
	Thu,  7 Nov 2024 22:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017726;
	bh=dDKO4BMOTAuFvxFT6BqDqcdvbotmfAQVAtxgwB4ef4w=;
	h=Date:To:From:Subject:From;
	b=FFzvmN0zTG8lBZroNmpRnnmJ0d4nU16Cegm45PQ8yvZxbuk57Yjbc5rAeSV8O274i
	 vbW6IUA2kIYe5QXSnm/wh0R2PvU/U2lNVrNoYM/xqc7aGWVdWyXj1nh93kYIr9Bxhz
	 kSICMfkERGkml0DX8+41ST5aroxgKArEuGeZXcSQ=
Date: Thu, 07 Nov 2024 14:15:25 -0800
To: mm-commits@vger.kernel.org,wuqiang.matt@bytedance.com,vmalik@redhat.com,torvalds@linux-foundation.org,rostedt@goodmis.org,mikel@mikelr.com,leo.yan@arm.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] objpool-fix-to-make-percpu-slot-allocation-more-robust.patch removed from -mm tree
Message-Id: <20241107221526.3A48CC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: objpool: fix to make percpu slot allocation more robust
has been removed from the -mm tree.  Its filename was
     objpool-fix-to-make-percpu-slot-allocation-more-robust.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: objpool: fix to make percpu slot allocation more robust
Date: Mon, 28 Oct 2024 12:26:27 +0900

Since gfp & GFP_ATOMIC == GFP_ATOMIC is true for GFP_KERNEL | GFP_HIGH, it
will use kmalloc if user specifies that combination.  Here the reason why
combining the __vmalloc_node() and kmalloc_node() is that the vmalloc does
not support all GFP flag, especially GFP_ATOMIC.  So we should check if
gfp & (GFP_ATOMIC | GFP_KERNEL) != GFP_ATOMIC for vmalloc first.  This
ensures caller can sleep.  And for the robustness, even if vmalloc fails,
it should retry with kmalloc to allocate it.

Link: https://lkml.kernel.org/r/173008598713.1262174.2959179484209897252.stgit@mhiramat.roam.corp.google.com
Fixes: aff1871bfc81 ("objpool: fix choosing allocation for percpu slots")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/all/CAHk-=whO+vSH+XVRio8byJU8idAWES0SPGVZ7KAVdc4qrV0VUA@mail.gmail.com/
Cc: Leo Yan <leo.yan@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: Mikel Rychliski <mikel@mikelr.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/lib/objpool.c~objpool-fix-to-make-percpu-slot-allocation-more-robust
+++ a/lib/objpool.c
@@ -74,15 +74,21 @@ objpool_init_percpu_slots(struct objpool
 		 * warm caches and TLB hits. in default vmalloc is used to
 		 * reduce the pressure of kernel slab system. as we know,
 		 * mimimal size of vmalloc is one page since vmalloc would
-		 * always align the requested size to page size
+		 * always align the requested size to page size.
+		 * but if vmalloc fails or it is not available (e.g. GFP_ATOMIC)
+		 * allocate percpu slot with kmalloc.
 		 */
-		if ((pool->gfp & GFP_ATOMIC) == GFP_ATOMIC)
-			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
-		else
+		slot = NULL;
+
+		if ((pool->gfp & (GFP_ATOMIC | GFP_KERNEL)) != GFP_ATOMIC)
 			slot = __vmalloc_node(size, sizeof(void *), pool->gfp,
 				cpu_to_node(i), __builtin_return_address(0));
-		if (!slot)
-			return -ENOMEM;
+
+		if (!slot) {
+			slot = kmalloc_node(size, pool->gfp, cpu_to_node(i));
+			if (!slot)
+				return -ENOMEM;
+		}
 		memset(slot, 0, size);
 		pool->cpu_slots[i] = slot;
 
_

Patches currently in -mm which might be from mhiramat@kernel.org are


