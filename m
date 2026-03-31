Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CCD257827
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917768; cv=none; b=GzZ10GYP3Hxf66SR+D7BuVdLsXxocVjgM7Ki7qST2PbkKOnxw6ZnvhloepFuw2evH4g0u0IwP4+uB+wgZQfIIBDqPz/tIqNZcVLK5objRG5FJ7DldUp7LEEJAsek2LufkLNIsfd2/5jWNPRn6zE5oDz92KSOqbQT9zl4e3aqaag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917768; c=relaxed/simple;
	bh=takP5/nT2cPtC0SznG/smvS9o1vypSkWPsdN5t1+67U=;
	h=Date:To:From:Subject:Message-Id; b=M3EXftHvauZFFdRIB9UaNJdl0LYfYuYoogFbY0z9RLPAyTV6t8BiYhsCtJMMXxLqPrk0U6pkSlOt5ynVis+OVxl/O8Dj49qdrpjVQKnhMaC0VkcIg1M0UGVGpbngLbjqi17INOlK++xxPSJpOUwbHS85KrnG+W1iiifeb+H5EWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2u2bwWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2u2bwWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE0CC4CEF7;
	Tue, 31 Mar 2026 00:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917768;
	bh=takP5/nT2cPtC0SznG/smvS9o1vypSkWPsdN5t1+67U=;
	h=Date:To:From:Subject:From;
	b=x2u2bwWYpPPEUb1vwKuIK3XPf7tChBabnH3jwgmm8oJ8WNr9X+VRAqmfUyiWoYmbI
	 5LUmvJWkIwkIzXXxnxRL/FAoc9WeIL3gZNbon6CfY5tOGBMxKjcLiWOHGT0WRrTbAl
	 8BcQvhwcDrXZ4mEVpPXtTAD39MEGLY3WsCzO/rAc=
Date: Mon, 30 Mar 2026 17:42:48 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch removed from -mm tree
Message-Id: <20260331004248.7FE0CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
Date: Fri, 20 Mar 2026 19:38:37 +0000

The tests have existing flag clearing logic, so simply expand this to use
the new VMA-specific flag clearing helpers.

Also correct some trivial formatting issue in a macro define.

Link: https://lkml.kernel.org/r/f5da681d3c33039dd4a838188385796eb8d58373.1774034900.git.ljs@kernel.org
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

 tools/testing/vma/tests/vma.c |   33 ++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-update-vma-tests-to-test-vma_clear_flags
+++ a/tools/testing/vma/tests/vma.c
@@ -347,19 +347,20 @@ static bool test_vma_flags_clear(void)
 					, 64
 #endif
 		);
-	struct vm_area_struct vma;
-	struct vm_area_desc desc;
-
-	vma.flags = flags;
-	desc.vma_flags = flags;
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 	/* Cursory check of _mask() variant, as the helper macros imply. */
 	vma_flags_clear_mask(&flags, mask);
-	vma_flags_clear_mask(&vma.flags, mask);
+	vma_clear_flags_mask(&vma, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
 #if NUM_VMA_FLAG_BITS > 64
 	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_test_any(&vma, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
 	/* Reset. */
 	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
@@ -371,15 +372,15 @@ static bool test_vma_flags_clear(void)
 	 * Clear the flags and assert clear worked, then reset flags back to
 	 * include specified flags.
 	 */
-#define do_test_and_reset(...)					\
-	vma_flags_clear(&flags, __VA_ARGS__);			\
-	vma_flags_clear(&vma.flags, __VA_ARGS__);		\
-	vma_desc_clear_flags(&desc, __VA_ARGS__);		\
-	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_flags_test_any(&vma.flags, __VA_ARGS__));	\
-	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));	\
-	vma_flags_set(&flags, __VA_ARGS__);			\
-	vma_set_flags(&vma, __VA_ARGS__);			\
+#define do_test_and_reset(...)						\
+	vma_flags_clear(&flags, __VA_ARGS__);				\
+	vma_clear_flags(&vma, __VA_ARGS__);				\
+	vma_desc_clear_flags(&desc, __VA_ARGS__);			\
+	ASSERT_FALSE(vma_flags_test_any(&flags, __VA_ARGS__));		\
+	ASSERT_FALSE(vma_test_any(&vma, __VA_ARGS__));			\
+	ASSERT_FALSE(vma_desc_test_any(&desc, __VA_ARGS__));		\
+	vma_flags_set(&flags, __VA_ARGS__);				\
+	vma_set_flags(&vma, __VA_ARGS__);				\
 	vma_desc_set_flags(&desc, __VA_ARGS__)
 
 	/* Single flags. */
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

