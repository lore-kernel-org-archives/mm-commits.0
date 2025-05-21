Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9E17A310
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846638; cv=none; b=uP5nyfPYBnyHTlhD/YdhqOEt/+uSZE//uskaq68mZPtEKgCb59Z8EE2JbFu7U4Lu+mp62I0F84A5DCpAOkdoaL2IlWY/TrTAoksH4cgDYF8uli83Sl25pfc7gxRcJVCgpf27GaDvHIWt2aH/adJEDFItcszZQX+VXUmXPChp3ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846638; c=relaxed/simple;
	bh=pjTA6gq7cyLLOEqh1TVDTVGp21TtaoDs7TMyeh0yyAc=;
	h=Date:To:From:Subject:Message-Id; b=dXBuXUPF+Ywmxoc/mpc68x+zSNPy+wfuw0bFGYgqCmbmi5dbs08bosASUpVubL+X9kb+GDNlcEb/ge7YBPWh4yvGsayUx5E4Coj3jRsFgn0G/Xg9O+YhnYQyBz4KJm3k3RfXxGNqS/gDcW5JLUjTXcgElmkNZQ5O9Ggqq/1AvXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/THLLTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/THLLTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56880C4CEE4;
	Wed, 21 May 2025 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846638;
	bh=pjTA6gq7cyLLOEqh1TVDTVGp21TtaoDs7TMyeh0yyAc=;
	h=Date:To:From:Subject:From;
	b=a/THLLTKVq8kpT4+mXnywQt2tX1prs7tFWcvyWVYldJ8s7UomZN+MqRW6IVTuXJuU
	 N3vS4zllPZl3gUQnp7yu1V2/sunevK/ZJKlVy0n9mqnxnleImxb0FGNKs2X6CCvbH+
	 IWhx/OwAUjl3kTbaE+PJmZ+4J2AA0Du8am9ehqE0=
Date: Wed, 21 May 2025 09:57:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-io-mapping-track_pfn-pfnmap-tracking.patch removed from -mm tree
Message-Id: <20250521165718.56880C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/io-mapping: track_pfn() -> "pfnmap tracking"
has been removed from the -mm tree.  Its filename was
     mm-io-mapping-track_pfn-pfnmap-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/io-mapping: track_pfn() -> "pfnmap tracking"
Date: Mon, 12 May 2025 14:34:24 +0200

track_pfn() does not exist, let's simply refer to it as "pfnmap tracking".

Link: https://lkml.kernel.org/r/20250512123424.637989-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86 bits]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/io-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/io-mapping.c~mm-io-mapping-track_pfn-pfnmap-tracking
+++ a/mm/io-mapping.c
@@ -24,7 +24,7 @@ int io_mapping_map_user(struct io_mappin
 	pgprot_t remap_prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
 				       (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
 
-	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
+	/* We rely on prevalidation of the io-mapping to skip pfnmap tracking. */
 	return remap_pfn_range_notrack(vma, addr, pfn, size, remap_prot);
 }
 EXPORT_SYMBOL_GPL(io_mapping_map_user);
_

Patches currently in -mm which might be from david@redhat.com are


