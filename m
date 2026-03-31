Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE533282F06
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917772; cv=none; b=GHDEIxYEqiPvMZms5gPY8//vgyzmEcurJHcWk9vFAd/ELn2KkjiRqY/lMhMyoFGkJyRWtRlGqiBQerHrtmAiohBrC/myX5bV9hYQkyVrvg7dbp+Ta2hYIQLhNo49NfJW++ynyVkCSFtxzKshxlb9R7TMtrBJ2qpFH9hdG0J8ejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917772; c=relaxed/simple;
	bh=tPHgMnSBd4862vvv9M7tcwSlJlqLf0YiEeghnL5afbw=;
	h=Date:To:From:Subject:Message-Id; b=gpO8F9PFAFNw/S57oaOxjU35kIuiUANKeUfwJ75yWOTG4xOEU1KWz5P/KQeB5TEzSnCJkAFFl/4kTFR+por4q3CTow640FPkOMrmZbmYPkBenYOi4FjKg+f8JXKX0NN0rnQ0ZVWCaKpxxUMPiXoYLOy37VyVcCIP878xMx8mjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kT5pNLZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kT5pNLZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B27C4CEF7;
	Tue, 31 Mar 2026 00:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917772;
	bh=tPHgMnSBd4862vvv9M7tcwSlJlqLf0YiEeghnL5afbw=;
	h=Date:To:From:Subject:From;
	b=kT5pNLZAzxMkSjoqW5VIW5Iuxt7E7j5D7ccmgk+y2IsuGRUnVYuFFcugHbwpFCHd7
	 C5MP0+ajbcuxYrXa0F5o7HVTGf7/IZ4G8qTGPRzIfMUZUbgtVuEPp0JtK4PjlF8prt
	 A2gzlKpyqRdBnDQZNG/uXn5TZqJ1gJWZQe+1GvB4=
Date: Mon, 30 Mar 2026 17:42:52 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-bitmap-add-missing-bitmap_copy-implementation.patch removed from -mm tree
Message-Id: <20260331004252.A0B27C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: bitmap: add missing bitmap_copy() implementation
has been removed from the -mm tree.  Its filename was
     tools-bitmap-add-missing-bitmap_copy-implementation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools: bitmap: add missing bitmap_copy() implementation
Date: Fri, 20 Mar 2026 19:38:39 +0000

I need this for changes I am making to keep the VMA tests running
correctly.

Link: https://lkml.kernel.org/r/4dcb2fb959137e9fe58a23e21cebcea97de41a1f.1774034900.git.ljs@kernel.org
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

 tools/include/linux/bitmap.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/include/linux/bitmap.h~tools-bitmap-add-missing-bitmap_copy-implementation
+++ a/tools/include/linux/bitmap.h
@@ -55,6 +55,17 @@ static inline void bitmap_fill(unsigned
 	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
+static __always_inline
+void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
+{
+	unsigned int len = bitmap_size(nbits);
+
+	if (small_const_nbits(nbits))
+		*dst = *src;
+	else
+		memcpy(dst, src, len);
+}
+
 static inline bool bitmap_empty(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

