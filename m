Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50F829ACC3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489865; cv=none; b=exquZh0vDk6BkosLJ5NwYA5gTJ+Qo5c7LYbcBLbZuXFQKSkeMgjO4HG7h8C5p+D9h/Y52gjfdkRoaQctl8k02QFOVUDm3JxcS5S2FxrSCwJnwN7kkr8HYpEUQsq82Tl2sCsRmOhdBQ3kuLpHb6FL/N7r1Z7Ly3B+R64wIktrpNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489865; c=relaxed/simple;
	bh=MQNcKHcc8+tmcGvOA+GFipCAb18nV6NXTQs3BbElCM4=;
	h=Date:To:From:Subject:Message-Id; b=Dnn8uirHM6G4cJNaQE9P3/6xdS5xh1Ar/5M1YNJXPaGLkE5tjWRXOsUwII0kSqkor8PVDo/Is+ZFPZKgqFIZmyKSBsY/KC3QrkGYJTg1mGLVRcu3LgUTcBx6miPkx4H5wMGjq75tI0EH85I3FeqRWI9BRMQ5Gl9TQBMzvDMDxbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKjT8LdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKjT8LdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56DEC4CEE7;
	Sun, 21 Sep 2025 21:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489865;
	bh=MQNcKHcc8+tmcGvOA+GFipCAb18nV6NXTQs3BbElCM4=;
	h=Date:To:From:Subject:From;
	b=nKjT8LdUPoGxILi7fDX/Prq+T5G0r2VpRcZrLsqKlUK1SDl6FfDdjo3gz/WGQpFS9
	 EPRRYHHX1kegy959nuQYEugACnbo9JBXjTV2E1vStJW6EOzfh9kixvBwE5tPu+AVf5
	 9X7NZGzrmJGc1lmLvtwgaya+1HJdc8HpomtjWWkk=
Date: Sun, 21 Sep 2025 14:24:25 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-shmem-related-test-functions-for-improved-const-correctness.patch removed from -mm tree
Message-Id: <20250921212425.A56DEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify shmem related test functions for improved const-correctness
has been removed from the -mm tree.  Its filename was
     mm-constify-shmem-related-test-functions-for-improved-const-correctness.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Max Kellermann <max.kellermann@ionos.com>
Subject: mm: constify shmem related test functions for improved const-correctness
Date: Mon, 1 Sep 2025 22:50:10 +0200

Patch series "mm: establish const-correctness for pointer parameters", v6.

This series is to improved const-correctness in the low-level
memory-management subsystem, which provides a basis for further
constification further up the call stack (e.g.  filesystems).

I started this work when I tried to constify the Ceph filesystem code, but
found that to be impossible because many "mm" functions accept non-const
pointers, even though they modify nothing.


This patch (of 12):

We select certain test functions which either invoke each other, functions
that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which provides a
basis for further const-ification further up the call stack.

Link: https://lkml.kernel.org/r/20250901205021.3573313-1-max.kellermann@ionos.com
Link: https://lkml.kernel.org/r/20250901205021.3573313-2-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Nysal Jan K.A" <nysal@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    8 ++++----
 include/linux/shmem_fs.h |    4 ++--
 mm/shmem.c               |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-constify-shmem-related-test-functions-for-improved-const-correctness
+++ a/include/linux/mm.h
@@ -995,11 +995,11 @@ static inline void vma_iter_set(struct v
  * The vma_is_shmem is not inline because it is used only by slow
  * paths in userfault.
  */
-bool vma_is_shmem(struct vm_area_struct *vma);
-bool vma_is_anon_shmem(struct vm_area_struct *vma);
+bool vma_is_shmem(const struct vm_area_struct *vma);
+bool vma_is_anon_shmem(const struct vm_area_struct *vma);
 #else
-static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
-static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
--- a/include/linux/shmem_fs.h~mm-constify-shmem-related-test-functions-for-improved-const-correctness
+++ a/include/linux/shmem_fs.h
@@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
+bool shmem_mapping(const struct address_space *mapping);
 #else
-static inline bool shmem_mapping(struct address_space *mapping)
+static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
 }
--- a/mm/shmem.c~mm-constify-shmem-related-test-functions-for-improved-const-correctness
+++ a/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are


