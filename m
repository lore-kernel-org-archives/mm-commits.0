Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E421A38D0
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723586673; cv=none; b=JZ7jO2qCNKhbXXWytO5e5E/3OZ7+PPZp2ear3k+/aV0tpzCaS/RiND7+MzSDF919Msw1RE3RHg1P9R3SwecDYftz4WGBR9ac1OS+6laJ6jqckp0Z7c4bO+IU/ukx9iTICA5KYQ0BOQlgiM31I62t4MKWPX0DUeku0ur9C9R26aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723586673; c=relaxed/simple;
	bh=hQeOWs/v8SY6kBnyp1tg+di7VKmtBiX4mgdQpUU0VgM=;
	h=Date:To:From:Subject:Message-Id; b=Hd7XOFJF6TcIAa5dKbs3OFAJqiDGar1GILlcMDvVBN6iMPQeOFdE96zOgG/cgux/Ky82bdN+SbgihvoRTcOlqUZFue+gsuUWn9Q7NTWE+m+72gPHWOvGBLpdhR4DWTGuJggbLoaBj1iMmzKvibkY+Ojbh/R6L3hywb50MkGFiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLqZPHCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLqZPHCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3711EC32782;
	Tue, 13 Aug 2024 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723586672;
	bh=hQeOWs/v8SY6kBnyp1tg+di7VKmtBiX4mgdQpUU0VgM=;
	h=Date:To:From:Subject:From;
	b=yLqZPHCUoZ254FRLlPwhcVTiI/WleMhf2DB6NXbf9QUzdA8ou3Z8AEkZ+PBC2nz8H
	 Cfn5ZrqlorxlLY+Bz4g+h1QOeoi97GPmtSmXWv0h8I9JyysvVPdNDDZbKgsgI2BtG9
	 cvZ2ewA2lVo3MqNsd4xO2AH1Ym/fU/1Is4YNhnhE=
Date: Tue, 13 Aug 2024 15:04:31 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-optional-close-to-struct-vm_special_mapping.patch added to mm-unstable branch
Message-Id: <20240813220432.3711EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add optional close() to struct vm_special_mapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-optional-close-to-struct-vm_special_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-optional-close-to-struct-vm_special_mapping.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: mm: add optional close() to struct vm_special_mapping
Date: Mon, 12 Aug 2024 18:26:02 +1000

Add an optional close() callback to struct vm_special_mapping.  It will be
used, by powerpc at least, to handle unmapping of the VDSO.

Although support for unmapping the VDSO was initially added for CRIU[1],
it is not desirable to guard that support behind
CONFIG_CHECKPOINT_RESTORE.

There are other known users of unmapping the VDSO which are not related to
CRIU, eg.  Valgrind [2] and void-ship [3].

The powerpc arch_unmap() hook has been in place for ~9 years, with no
ifdef, so there may be other unknown users that have come to rely on
unmapping the VDSO.  Even if the code was behind an ifdef, major distros
enable CHECKPOINT_RESTORE so users may not realise unmapping the VDSO
depends on that configuration option.

It's also undesirable to have such core mm behaviour behind a relatively
obscure CONFIG option.

Longer term the unmap behaviour should be standardised across
architectures, however that is complicated by the fact the VDSO pointer is
stored differently across architectures.  There was a previous attempt to
unify that handling [4], which could be revived.

See [5] for further discussion.

[1]: commit 83d3f0e90c6c ("powerpc/mm: tracking vDSO remap")
[2]: https://sourceware.org/git/?p=valgrind.git;a=commit;h=3a004915a2cbdcdebafc1612427576bf3321eef5
[3]: https://github.com/insanitybit/void-ship
[4]: https://lore.kernel.org/lkml/20210611180242.711399-17-dima@arista.com/
[5]: https://lore.kernel.org/linuxppc-dev/shiq5v3jrmyi6ncwke7wgl76ojysgbhrchsk32q4lbx2hadqqc@kzyy2igem256

Link: https://lkml.kernel.org/r/20240812082605.743814-1-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 mm/mmap.c                |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/include/linux/mm_types.h~mm-add-optional-close-to-struct-vm_special_mapping
+++ a/include/linux/mm_types.h
@@ -1324,6 +1324,9 @@ struct vm_special_mapping {
 
 	int (*mremap)(const struct vm_special_mapping *sm,
 		     struct vm_area_struct *new_vma);
+
+	void (*close)(const struct vm_special_mapping *sm,
+		      struct vm_area_struct *vma);
 };
 
 enum tlb_flush_reason {
--- a/mm/mmap.c~mm-add-optional-close-to-struct-vm_special_mapping
+++ a/mm/mmap.c
@@ -2045,10 +2045,16 @@ void vm_stat_account(struct mm_struct *m
 static vm_fault_t special_mapping_fault(struct vm_fault *vmf);
 
 /*
+ * Close hook, called for unmap() and on the old vma for mremap().
+ *
  * Having a close hook prevents vma merging regardless of flags.
  */
 static void special_mapping_close(struct vm_area_struct *vma)
 {
+	const struct vm_special_mapping *sm = vma->vm_private_data;
+
+	if (sm->close)
+		sm->close(sm, vma);
 }
 
 static const char *special_mapping_name(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

mm-add-optional-close-to-struct-vm_special_mapping.patch
powerpc-mm-handle-vdso-unmapping-via-close-rather-than-arch_unmap.patch
mm-remove-arch_unmap.patch
powerpc-vdso-refactor-error-handling.patch

