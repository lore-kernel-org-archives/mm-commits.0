Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666CE1C84B8
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744760; cv=none; b=WJWoiDwZXAZl1t8QIo58jfX9x4YCffGn1Y/hKCqRKBkTN9Vrc0AEuO5i60gMG0Ji9exO05T4j3+tuIgchAkIKPrWA7+a5CCILDikLKaiBMZbMbamuHIorzVTFN7W7Py1N+vWRTnfqcA4lzLIOs7lJ7p0suQUFXtdam4HhFpr6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744760; c=relaxed/simple;
	bh=84eiX0SSY/lo6JW1fiDicdCpmpHFIbrnZSgvcv81mIM=;
	h=Date:To:From:Subject:Message-Id; b=EFILHncSJkeIIfJUdplo6XuDs8gtfPdXeMqsHlWOSPajgGjUqdAn5gSM+yZoWb1nC9TlZ3MyOD3LmncMs5xvjaI6FmIJAczwjljcQhiOBRC2UKV3W4JFsZbLu38EX1nAq+CI2YJVaFx8lC5Uaq3BwSXFiDjRv+rAZ8ZdxRxerGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=prRqIt+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="prRqIt+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C090C4CEF7;
	Sun, 29 Mar 2026 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744760;
	bh=84eiX0SSY/lo6JW1fiDicdCpmpHFIbrnZSgvcv81mIM=;
	h=Date:To:From:Subject:From;
	b=prRqIt+7Z5ZE8iuEVugybVOxB5LQqLP6tK+buE1xh0RVac6YnNmTMloS5Rf8VINV6
	 6UZxQ4eqm6cOh2SWk9/500YCA0DSyI8kstWbpM028hWtwKwc+ZyetOVOKMy7SrvsVI
	 hFiH+SNIdgmvgWfH6Ym4AYsUrwwP0n2wIrSOx3z8=
Date: Sat, 28 Mar 2026 17:39:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-zap_vma_pages-to-zap_vma.patch removed from -mm tree
Message-Id: <20260329003920.3C090C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename zap_vma_pages() to zap_vma()
has been removed from the -mm tree.  Its filename was
     mm-rename-zap_vma_pages-to-zap_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: rename zap_vma_pages() to zap_vma()
Date: Fri, 27 Feb 2026 21:08:43 +0100

Let's rename it to an even simpler name.  While at it, add some simplistic
kernel doc.

Link: https://lkml.kernel.org/r/20260227200848.114019-13-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/book3s/vas-api.c |    2 +-
 arch/powerpc/platforms/pseries/vas.c    |    2 +-
 include/linux/mm.h                      |    6 +++++-
 lib/vdso/datastore.c                    |    2 +-
 mm/page-writeback.c                     |    2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

--- a/arch/powerpc/platforms/book3s/vas-api.c~mm-rename-zap_vma_pages-to-zap_vma
+++ a/arch/powerpc/platforms/book3s/vas-api.c
@@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct
 	/*
 	 * When the LPAR lost credits due to core removal or during
 	 * migration, invalidate the existing mapping for the current
-	 * paste addresses and set windows in-active (zap_vma_pages in
+	 * paste addresses and set windows in-active (zap_vma() in
 	 * reconfig_close_windows()).
 	 * New mapping will be done later after migration or new credits
 	 * available. So continue to receive faults if the user space
--- a/arch/powerpc/platforms/pseries/vas.c~mm-rename-zap_vma_pages-to-zap_vma
+++ a/arch/powerpc/platforms/pseries/vas.c
@@ -807,7 +807,7 @@ static int reconfig_close_windows(struct
 		 * is done before the original mmap() and after the ioctl.
 		 */
 		if (vma)
-			zap_vma_pages(vma);
+			zap_vma(vma);
 
 		mutex_unlock(&task_ref->mmap_mutex);
 		mmap_write_unlock(task_ref->mm);
--- a/include/linux/mm.h~mm-rename-zap_vma_pages-to-zap_vma
+++ a/include/linux/mm.h
@@ -2806,7 +2806,11 @@ void zap_vma_ptes(struct vm_area_struct
 		  unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size);
-static inline void zap_vma_pages(struct vm_area_struct *vma)
+/**
+ * zap_vma - zap all page table entries in a vma
+ * @vma: The vma to zap.
+ */
+static inline void zap_vma(struct vm_area_struct *vma)
 {
 	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
--- a/lib/vdso/datastore.c~mm-rename-zap_vma_pages-to-zap_vma
+++ a/lib/vdso/datastore.c
@@ -121,7 +121,7 @@ int vdso_join_timens(struct task_struct
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
 		if (vma_is_special_mapping(vma, &vdso_vvar_mapping))
-			zap_vma_pages(vma);
+			zap_vma(vma);
 	}
 	mmap_read_unlock(mm);
 
--- a/mm/page-writeback.c~mm-rename-zap_vma_pages-to-zap_vma
+++ a/mm/page-writeback.c
@@ -2645,7 +2645,7 @@ void folio_account_cleaned(struct folio
  * while this function is in progress, although it may have been truncated
  * before this function is called.  Most callers have the folio locked.
  * A few have the folio blocked from truncation through other means (e.g.
- * zap_vma_pages() has it mapped and is holding the page table lock).
+ * zap_vma() has it mapped and is holding the page table lock).
  * When called from mark_buffer_dirty(), the filesystem should hold a
  * reference to the buffer_head that is being marked dirty, which causes
  * try_to_free_buffers() to fail.
_

Patches currently in -mm which might be from david@kernel.org are


