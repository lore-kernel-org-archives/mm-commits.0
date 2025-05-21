Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4E22D4C8
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846631; cv=none; b=Jr9EWTG2ySPv9lYzsOK92E0ZPgWcRMCCX7IYC2oAWTStAfODPO4wOEkbBiG4Pqt1e8vhM2EsDWd+umcu9UwtpjlddithjM16oOX//z8KZ8MYRBDQ6889xQAylAWkNYwZINgFQyRgpFAvlqklzgtMnRrAx7NqhqlAvtBUDCYPbM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846631; c=relaxed/simple;
	bh=nzHT5a12yvRnrUs5nnSUOH4m7nrT/4a6M3Zaxs6JkWs=;
	h=Date:To:From:Subject:Message-Id; b=R5BjXC6GL/IhYZqrwYlhPuYpZNeZPGFVIntwyzUkBLJCExjU4FP5B/HtFIsjKf7TxSZ2dJKmBVJf1AHZSkWVZHm5is330jHmt9jWzqsiCggBCGBK98+3KyYnJLqnzADm2ttEEwx2PrFTw2HlY5/dLtu8QDTQJn7lh+19tsbMnA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RXqgkFCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RXqgkFCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCB3C4CEEF;
	Wed, 21 May 2025 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846631;
	bh=nzHT5a12yvRnrUs5nnSUOH4m7nrT/4a6M3Zaxs6JkWs=;
	h=Date:To:From:Subject:From;
	b=RXqgkFCeegnSqorNAgb/nVcNfVgEQ5DRQIcCpWHgUrIOPd4MJQj4QuJKMw+lR/wxl
	 RMIQGpaN1snHYECrHahlx9gRvkCbubsNpRjMjaOQtvx+wMsdkDDX/0yxY5ix39WUtu
	 HbZQgcELbkEIoZQBTYoTj+/P27bkUOiXbU3YeDpY=
Date: Wed, 21 May 2025 09:57:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-vm_pat.patch removed from -mm tree
Message-Id: <20250521165711.9FCB3C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove VM_PAT
has been removed from the -mm tree.  Its filename was
     mm-remove-vm_pat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove VM_PAT
Date: Mon, 12 May 2025 14:34:19 +0200

It's unused, so let's remove it.

Link: https://lkml.kernel.org/r/20250512123424.637989-7-david@redhat.com
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

 include/linux/mm.h             |    4 +---
 include/trace/events/mmflags.h |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-remove-vm_pat
+++ a/include/linux/mm.h
@@ -357,9 +357,7 @@ extern unsigned int kobjsize(const void
 # define VM_SHADOW_STACK	VM_NONE
 #endif
 
-#if defined(CONFIG_X86)
-# define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
-#elif defined(CONFIG_PPC64)
+#if defined(CONFIG_PPC64)
 # define VM_SAO		VM_ARCH_1	/* Strong Access Ordering (powerpc) */
 #elif defined(CONFIG_PARISC)
 # define VM_GROWSUP	VM_ARCH_1
--- a/include/trace/events/mmflags.h~mm-remove-vm_pat
+++ a/include/trace/events/mmflags.h
@@ -172,9 +172,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	__def_pageflag_names						\
 	) : "none"
 
-#if defined(CONFIG_X86)
-#define __VM_ARCH_SPECIFIC_1 {VM_PAT,     "pat"           }
-#elif defined(CONFIG_PPC64)
+#if defined(CONFIG_PPC64)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
_

Patches currently in -mm which might be from david@redhat.com are


