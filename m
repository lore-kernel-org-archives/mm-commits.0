Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BA5313E0D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780431066; cv=none; b=gnVEjFiXm8gbK15SaENnjvMT5eNtOVkPtEMnvrCb2ITr/telRnTf5jnzLBeMqVjMHgPIdcXPakw51mT4fgjmDRzLasp8phmffpaU3j8TM+oz0OUv8vDctuQ6iVxOIVQwBtkhrpmfJWFG/kGTd05HbfADzXVXuG17W9JOtuENuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780431066; c=relaxed/simple;
	bh=EtHn2+GFgm/h/vvWvIkss0n5ourw9PYEvQFLWWxBB9o=;
	h=Date:To:From:Subject:Message-Id; b=m8HofS+bVU/dO7BcT7xmhvltgEpoaOuyznfc+0BhR4zlsNuT+RYuTRuuSfMmk6aOuvfj3n7i0aGpevF5gjpAOYW2jkHkcb2gYiWlQ1ZPsvc2nvJNaUPF5Ub4gBhubsr5PlISimbXzonrV4y7D3O6BRsez0pjIR0ZzQuWTfxCG+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SHnkrPJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SHnkrPJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24B71F00893;
	Tue,  2 Jun 2026 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780431064;
	bh=Xh2htim0GUetCUP9SFzOjDaczKaKC9V6MQWMQ1fWsTQ=;
	h=Date:To:From:Subject;
	b=SHnkrPJrjd6AuEtY/EMu6CWf5gOwqo5hOnWj8fdqx89Atz6zi0DCduI6bilVONOJy
	 y+FFEIF84nwephwhCJMWnoFfQHJnoywTmDOS8eia+QtJsy2c3MGkEZcEY/H9EGxK6j
	 bE3qfUJ8Ra4VqTgFHf50KD1j6anJtyjwglHrd/c4=
Date: Tue, 02 Jun 2026 13:11:04 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch added to mm-unstable branch
Message-Id: <20260602201104.C24B71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/char/mem: eliminate unnecessary use of success_hook
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: drivers/char/mem: eliminate unnecessary use of success_hook
Date: Tue, 2 Jun 2026 12:06:25 +0100

Patch series "remove mmap_action success, error hooks", v3.

The mmap_action->success_hook was a strange beast added to enable code
which appeared to absolutely require access to a VMA pointer to work
correctly.

Primarily this was for hugetlb, however a different approach will be taken
there, as clearly more work is required to figure out a sensible way of
converting hugetlb to use mmap_prepare.

The other user was the memory char driver, specifically /dev/zero which
has the unusual property of explicitly setting file-backed VMAs anonymous.

Providing the success hook was always foolish, as it allowed drivers a way
to workaround the restriction that they should not access a pointer to a
not-yet-correctly-initialised VMA - which defeats the purpose of the
mmap_prepare work.

We can achieve the same thing in memory char driver without needing the
success hook, so this series removes that, then removes the success hook
altogether.

The error hook is also unnecessary - the motivation for this was for
functions which need to override the error code when performing an mmap
action in order to avoid breaking userspace.

We can achieve this by just providing a field for the error code.  Doing
this means we don't have to worry about the hook doing anything odd.

We also add a check to ensure the error code is in fact valid.

Again the memory char driver is the only current user of this, so this
series updates it to use that.

After this change mmap_action has no custom hooks at all, which seems
rather more cromulent than before.


This patch (of 3):

/dev/zero, uniquely, marks memory mapped there as anonymous.  This is
currently achieved using the mmap_action->success_hook.

However this hook circumvents the abstraction of VMA initialisation so
it's preferable to do things a different way.

To achieve this, this patch firstly defaults the VMA descriptor's vm_ops
field to the dummy VMA operations, which is what file-backed VMAs default
this field to.

That way, we can detect whether a driver sets this field to NULL in order
to mark it anonymous.

We then introduce vma_desc_set_anonymous() to do this explicitly, and
invoke it in mmap_zero_prepare().

This way, any driver which does not explicitly set desc->vm_ops, retains
the dummy vm_ops as they would previously.

We also update set_vma_user_defined_fields() to make clear that we are
either setting vma->vm_ops to what is provided by the driver (or
defaulting to dummy_vm_ops if not set), or setting the VMA anonymous.

This lays the groundwork for removing the success hook.

Link: https://lore.kernel.org/cover.1780397980.git.ljs@kernel.org
Link: https://lore.kernel.org/010579cca6787cf7bb057ab1f7228978b10601c8.1780397980.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c              |   17 +++++------------
 include/linux/mm.h              |    5 +++++
 mm/util.c                       |    1 +
 mm/vma.c                        |    3 +++
 tools/testing/vma/include/dup.h |    1 +
 5 files changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/char/mem.c~drivers-char-mem-eliminate-unnecessary-use-of-success_hook
+++ a/drivers/char/mem.c
@@ -504,17 +504,6 @@ static ssize_t read_zero(struct file *fi
 	return cleared;
 }
 
-static int mmap_zero_private_success(const struct vm_area_struct *vma)
-{
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_set_anonymous((struct vm_area_struct *)vma);
-
-	return 0;
-}
-
 static int mmap_zero_prepare(struct vm_area_desc *desc)
 {
 #ifndef CONFIG_MMU
@@ -523,7 +512,11 @@ static int mmap_zero_prepare(struct vm_a
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	desc->action.success_hook = mmap_zero_private_success;
+	/*
+	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
+	 * of /dev/zero anonymous, despite it not being.
+	 */
+	vma_desc_set_anonymous(desc);
 	return 0;
 }
 
--- a/include/linux/mm.h~drivers-char-mem-eliminate-unnecessary-use-of-success_hook
+++ a/include/linux/mm.h
@@ -1489,6 +1489,11 @@ static inline void vma_set_anonymous(str
 	vma->vm_ops = NULL;
 }
 
+static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
+{
+	desc->vm_ops = NULL;
+}
+
 static inline bool vma_is_anonymous(struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
--- a/mm/util.c~drivers-char-mem-eliminate-unnecessary-use-of-success_hook
+++ a/mm/util.c
@@ -1192,6 +1192,7 @@ void compat_set_desc_from_vma(struct vm_
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
--- a/mm/vma.c~drivers-char-mem-eliminate-unnecessary-use-of-success_hook
+++ a/mm/vma.c
@@ -2697,6 +2697,8 @@ static void set_vma_user_defined_fields(
 {
 	if (map->vm_ops)
 		vma->vm_ops = map->vm_ops;
+	else	/* Only /dev/zero should do this. */
+		vma_set_anonymous(vma);
 	vma->vm_private_data = map->vm_private_data;
 }
 
@@ -2744,6 +2746,7 @@ static unsigned long __mmap_region(struc
 		.action = {
 			.type = MMAP_NOTHING, /* Default to no further action. */
 		},
+		.vm_ops = &vma_dummy_vm_ops,
 	};
 	bool allocated_new = false;
 	int error;
--- a/tools/testing/vma/include/dup.h~drivers-char-mem-eliminate-unnecessary-use-of-success_hook
+++ a/tools/testing/vma/include/dup.h
@@ -1303,6 +1303,7 @@ static inline void compat_set_desc_from_
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch
drivers-char-mem-eliminate-unnecessary-use-of-success_hook.patch
mm-vma-remove-mmap_action-success_hook.patch
mm-vma-eliminate-mmap_action-error_hook-introduce-error_override.patch

