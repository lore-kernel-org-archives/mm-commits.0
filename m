Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BF9238C1A
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271089; cv=none; b=VJXY3cCQOjQGWUFRNYn83xc6Q9vKJCShjC1mM90oMVdvRF5K60kweNlu9W70YfRG/xWIj9tVuF/DEcrzIMqjbPoKS0N7FpjKJwVN532WnGKI/mY2Ae5cBouS7DL8gVeOazSQybl+SZm+x+U83jvzh2yTMdxl2jvI1d+fDEKIHjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271089; c=relaxed/simple;
	bh=vzjqTSGsY9w7NZWXo3WWxg4N2DpQdlammke/m9xpZTo=;
	h=Date:To:From:Subject:Message-Id; b=ndgfV6/OG3j+nJ2S6Leeo+/aosWpTMZ/eBJNZ0jDFOrBmNOWKlbEwU+r1LUf6DJ8NuxfSXmqyKTO7X8fkexrWYIaIjJVKg1XlFt7fmoJTpl3CqRF0BtLOlFO6rNfqQ9LmQwyY6cmXcp60Wvm+zWa6Sc8m7RlOOnkPOLjXUu7mkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2vHHIhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2vHHIhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD2FC4CEF5;
	Sat, 20 Dec 2025 22:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271088;
	bh=vzjqTSGsY9w7NZWXo3WWxg4N2DpQdlammke/m9xpZTo=;
	h=Date:To:From:Subject:From;
	b=i2vHHIhnpzBsmcyRSSOz0XBYNBi6dJfYS4wbmNS9ZBkMC3Sxi09OrZLQtdUeMPFXh
	 6S5K4CDYAKK/rXwWgg+cbWJWxYw5a1sQXoTGANuXIQQq6of5ZYWd9Y3IzHP1vQ1Z4r
	 CPuCopB91CwwZqYe2nb5+R8vPuVpufi+cTA1F3jw=
Date: Sat, 20 Dec 2025 14:51:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch added to mm-new branch
Message-Id: <20251220225128.CCD2FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
has been added to the -mm mm-new branch.  Its filename is
     mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
Date: Fri, 19 Dec 2025 11:32:18 +0000

The current description of contexts where it's invalid to make GFP_ATOMIC
and GFP_NOWAIT calls is rather vague.

Replace this with a direct description of the actual contexts of concern
and refer to the RT docs where this is explained more discursively.

While rejigging this prose, also move the documentation of GFP_NOWAIT to
the GFP_NOWAIT section.

Link: https://lore.kernel.org/all/d912480a-5229-4efe-9336-b31acded30f5@suse.cz/
Link: https://lkml.kernel.org/r/20251219-b4-gfp_atomic-comment-v2-1-4c4ce274c2b6@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/gfp_types.h~mm-clarify-gfp_atomic-gfp_nowait-doc-comment
+++ a/include/linux/gfp_types.h
@@ -309,8 +309,10 @@ enum {
  *
  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
  * watermark is applied to allow access to "atomic reserves".
- * The current implementation doesn't support NMI and few other strict
- * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
+ * The current implementation doesn't support NMI, nor contexts that disable
+ * preemption under PREEMPT_RT. This includes raw_spin_lock() and plain
+ * preempt_disable() - see "Memory allocation" in
+ * Documentation/core-api/real-time/differences.rst for more info.
  *
  * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
@@ -321,6 +323,7 @@ enum {
  * %GFP_NOWAIT is for kernel allocations that should not stall for direct
  * reclaim, start physical IO or use any filesystem callback.  It is very
  * likely to fail to allocate memory, even for very small allocations.
+ * The same restrictions on calling contexts apply as for %GFP_ATOMIC.
  *
  * %GFP_NOIO will use direct reclaim to discard clean pages or slab pages
  * that do not require the starting of any physical IO.
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep.patch
mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch

