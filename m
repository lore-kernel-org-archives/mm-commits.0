Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21367282F06
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917752; cv=none; b=c+dfpoQButGLodFEg/mt0y0LmIf70ZfFzmVTdBPImKDZ0Nmu+iU00dg8qWiNMv4hZbUonDTLwgybPU4XvLO3ra5Qf7C1fWmlfhKgbkilHqBqZ6+ty+OKMRXa/dULPWKf9Ik3ALcIUnlQqiUkY/HOnP3B/rE+jgXWWlx5qHV9alU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917752; c=relaxed/simple;
	bh=1kbvT4wAGe6oe/Jd9S0PrxShfX4hsVZB2HW9WvXLOSU=;
	h=Date:To:From:Subject:Message-Id; b=IJgzQjBl0E4Ah7/N9aKzUdiotgybTsarxDngwHd3086ApgWiXAC4iDZVUKeG0kLBoGL5I7h3FLhEIvQAfUcSZ6HlUjheook2PbVu9w5EZpNb2EITTl18csEZVylPrOQ5rdRRx1uOlNPlFF/7+LbX7XnLqBO9bhyUQ3eRerI7N4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAt0eYly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAt0eYly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE664C4CEF7;
	Tue, 31 Mar 2026 00:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917751;
	bh=1kbvT4wAGe6oe/Jd9S0PrxShfX4hsVZB2HW9WvXLOSU=;
	h=Date:To:From:Subject:From;
	b=WAt0eYlyfw0jOXYMvohYFfBavopHX+EI+anB1xBuUD8FU/4SsEbuiP+NvRgq8SJA+
	 q2y5rPAkVaXWqT+mDq/kMIgLteMkI16SgWIYsrY/yl6uUj6mtaBTHkqO1+wtFq1iId
	 t1moXCqF7mYaK8NIiP1SSavpTtUYru2ZS29fQ13o=
Date: Mon, 30 Mar 2026 17:42:31 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch removed from -mm tree
Message-Id: <20260331004231.BE664C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: test that legacy flag helpers work correctly
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools/testing/vma: test that legacy flag helpers work correctly
Date: Fri, 20 Mar 2026 19:38:29 +0000

Update the existing compare_legacy_flags() predicate function to assert
that legacy_to_vma_flags() and vma_flags_to_legacy() behave as expected.

Link: https://lkml.kernel.org/r/3374e50053adb65818fde948ae3488e1e29ae8b1.1774034900.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/vma.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-test-that-legacy-flag-helpers-work-correctly
+++ a/tools/testing/vma/tests/vma.c
@@ -5,6 +5,7 @@ static bool compare_legacy_flags(vm_flag
 	const unsigned long legacy_val = legacy_flags;
 	/* The lower word should contain the precise same value. */
 	const unsigned long flags_lower = flags.__vma_flags[0];
+	vma_flags_t converted_flags;
 #if NUM_VMA_FLAG_BITS > BITS_PER_LONG
 	int i;
 
@@ -17,6 +18,11 @@ static bool compare_legacy_flags(vm_flag
 
 	static_assert(sizeof(legacy_flags) == sizeof(unsigned long));
 
+	/* Assert that legacy flag helpers work correctly. */
+	converted_flags = legacy_to_vma_flags(legacy_flags);
+	ASSERT_FLAGS_SAME_MASK(&converted_flags, flags);
+	ASSERT_EQ(vma_flags_to_legacy(flags), legacy_flags);
+
 	return legacy_val == flags_lower;
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

