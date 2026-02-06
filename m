Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11717309EF4
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421708; cv=none; b=nP9pe2138z6Ng/BzNHx2JxW4p8Z9VYU0a8/JLI5UpybZ+sx2U3N39BKEjQWqWCBR4gvJSwD2+BEXwJjwe/aXg5Ffj+pzSdJMVGbvnbnPw+Xylu4KhPONuDfAAS095v0x4Zgj8OJL773aBDXfCfcDwDtXaAT8LOfteI6tHKaZlIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421708; c=relaxed/simple;
	bh=r9f5YdLU75UTa1CJa/vwGTL68rdMqkrJ1y0VWwuvavc=;
	h=Date:To:From:Subject:Message-Id; b=Y5+4IPeNyJhp17G6rKK8NGHbQtszuZewDsFGRZl2ZLnJGeG6tkoSh6fp+j+XW3P925jp7g0mH8oCv9XURodhCw6eKW37fFfT5ZBs4dOQTCgwExkEw8jAiG0BjU/Op+rOpTQkzm6MWHYqL9USHX4mdqdxhANkCQkjfU4zilhGU6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ldzPxQa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ldzPxQa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971A3C116C6;
	Fri,  6 Feb 2026 23:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421707;
	bh=r9f5YdLU75UTa1CJa/vwGTL68rdMqkrJ1y0VWwuvavc=;
	h=Date:To:From:Subject:From;
	b=ldzPxQa874Og+ERfaWLhnVuqZ/BktlyKOlFX/WJ2xVAAjEVYfrG67BAVPrRCRRTiV
	 oRLOPvIZ2fbzAWYtlbI4ZrzESrBhMUiweYX7NnqOCxGADaMXPUDzEoZapw2NDHpJxZ
	 jB28WkPGlpcv5qwAWxzw2xojsLpf2sgVAcSABo7w=
Date: Fri, 06 Feb 2026 15:48:27 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@kernel.org,surenb@google.com,rppt@kernel.org,richard.weiyang@gmail.com,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linmag7@gmail.com,Liam.Howlett@oracle.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,hpa@zytor.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,bp@alien8.de,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] um-mm-enable-mmu_gather_rcu_table_free.patch removed from -mm tree
Message-Id: <20260206234827.971A3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: um: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     um-mm-enable-mmu_gather_rcu_table_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:59 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/e2217546504668b8a87a39eb0e378839339a1bb4.1769515122.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/Kconfig~um-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/um/Kconfig
@@ -42,6 +42,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


