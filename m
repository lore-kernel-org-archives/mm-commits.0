Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371253612DB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966102; cv=none; b=lLXKo/SQ9baYLDFNgd+g1Za0Hn3k0WIB4T692nQF0ICPbmd2Kl+fitn4dc2ifFFbGMVQE9p1jC7mBnOPv/xg/lP3h0IKfuQ1B+Sg8k+IX8NFQZZMKRVsa64ibAhOqeWHE0j64SBpxQ2PT2F2iEVmTN/uAQzpPytiRI0wpMTXBuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966102; c=relaxed/simple;
	bh=c6csvlLOyFbJHJecmnN6IPhRJgJG6oNc1HeIHpdONX4=;
	h=Date:To:From:Subject:Message-Id; b=Fl7J5NgA4joiErNtMV0z3G8A7eu/gGYL0qTc9pK/pyhGNvIG7BC9usj5Wyf4VrPUEczEWWj1XKjNjbRfPviBX8sFb/SCunID73Y50a7GBuiHhrebLINxsEGcCo1X/xESM1dw3WjFlvqlRaIuO/WqJKNaymtG9YVREhfdETl4tXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WxgT6zPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WxgT6zPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D380C16AAE;
	Wed, 21 Jan 2026 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966102;
	bh=c6csvlLOyFbJHJecmnN6IPhRJgJG6oNc1HeIHpdONX4=;
	h=Date:To:From:Subject:From;
	b=WxgT6zPX/pxu9j2Uq1Oi5wntRMNatXSeo1lJvsoVtTFtvGj2piTtU9iSmYS3ti+28
	 NaklfkEB6G2mX4t6fpvQbo81Ttt1ux4EBBiy/DeESdRJuE5/DzieTz0AJKhdk+Lher
	 fYFjF8U2jDkD2D8NhU2yhvws5SNTCDL7Y5DmYxPs=
Date: Tue, 20 Jan 2026 19:28:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch removed from -mm tree
Message-Id: <20260121032822.0D380C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
has been removed from the -mm tree.  Its filename was
     mm-clarify-gfp_atomic-gfp_nowait-doc-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


