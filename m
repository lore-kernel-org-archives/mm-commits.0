Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F81261B9B
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917733; cv=none; b=uHRDJMT5k0Yi2nhf0iz6F7Xt3fQH2xxjuLwkVSyn9q09sy1taLup3Jq66cEYwzcw4dINqkBRbvC8v1EE4mIBh47vuOqZyJAwpr2NGILpdoI0W0Y3pBqs1Pgb6+a+fhGCp45ZAXeVKXcOz4fNXWg1ZkVbmL6+DY0Nd7w/DnpBC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917733; c=relaxed/simple;
	bh=jCl3Eiv2LuxTiBJj8e/S580VHUHK8oYb3442tmy6eR0=;
	h=Date:To:From:Subject:Message-Id; b=fQLo+vfOTIDIDgPYmvnAGHwes7AbzHSflPCcz7NjmjzSpY89pBTo50SIQ1A8lYSQXjRa9Dh2H3BCfzAtkydzWeSWkB4X9kIrk4+u2CvyVuiCWfkNJBMxFnZ1+K4xyOaiZeYROuCjIN8rOXES3VTTIDdm7X37/9z6B+PGqvI3Ezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bduQ883U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bduQ883U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A7C4CEF7;
	Tue, 31 Mar 2026 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917733;
	bh=jCl3Eiv2LuxTiBJj8e/S580VHUHK8oYb3442tmy6eR0=;
	h=Date:To:From:Subject:From;
	b=bduQ883Um1/GVHKHd8aCI9Mat8yQBuu4J8kif4PFEMO2D+b2UAiwGXD6atGe/A5kq
	 rlts/lLEBUhTNd8KqTMplF8nn7jMyhPwu2VSjrLY8w8Lcgl4khslg3lrgYBXwWbIps
	 QkHiqD4bYXjZUPQXcsRY1vM9BIyoFdxxmrbY6viI=
Date: Mon, 30 Mar 2026 17:42:12 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-add-further-vma_flags_t-unions.patch removed from -mm tree
Message-Id: <20260331004212.DD1A7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add further vma_flags_t unions
has been removed from the -mm tree.  Its filename was
     mm-vma-add-further-vma_flags_t-unions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/vma: add further vma_flags_t unions
Date: Fri, 20 Mar 2026 19:38:20 +0000

In order to utilise the new vma_flags_t type, we currently place it in
union with legacy vm_flags fields of type vm_flags_t to make the
transition smoother.

Add vma_flags_t union entries for mm->def_flags and vmg->vm_flags -
mm->def_vma_flags and vmg->vma_flags respectively.

Once the conversion is complete, these will be replaced with vma_flags_t
entries alone.

Also update the VMA tests to reflect the change.

Link: https://lkml.kernel.org/r/d507d542c089ba132e9da53f2ff7f80ca117c3b4.1774034900.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h        |    6 +++++-
 mm/vma.h                        |    6 +++++-
 tools/testing/vma/include/dup.h |    5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~mm-vma-add-further-vma_flags_t-unions
+++ a/include/linux/mm_types.h
@@ -1249,7 +1249,11 @@ struct mm_struct {
 		unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 		unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 		unsigned long stack_vm;	   /* VM_STACK */
-		vm_flags_t def_flags;
+		union {
+			/* Temporary while VMA flags are being converted. */
+			vm_flags_t def_flags;
+			vma_flags_t def_vma_flags;
+		};
 
 		/**
 		 * @write_protect_seq: Locked when any thread is write
--- a/mm/vma.h~mm-vma-add-further-vma_flags_t-unions
+++ a/mm/vma.h
@@ -98,7 +98,11 @@ struct vma_merge_struct {
 	unsigned long end;
 	pgoff_t pgoff;
 
-	vm_flags_t vm_flags;
+	union {
+		/* Temporary while VMA flags are being converted. */
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	struct anon_vma *anon_vma;
 	struct mempolicy *policy;
--- a/tools/testing/vma/include/dup.h~mm-vma-add-further-vma_flags_t-unions
+++ a/tools/testing/vma/include/dup.h
@@ -33,7 +33,10 @@ struct mm_struct {
 	unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 	unsigned long stack_vm;	   /* VM_STACK */
 
-	unsigned long def_flags;
+	union {
+		vm_flags_t def_flags;
+		vma_flags_t def_vma_flags;
+	};
 
 	mm_flags_t flags; /* Must use mm_flags_* helpers to access */
 };
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

