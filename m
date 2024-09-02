Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB772D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247813; cv=none; b=ftDICC+/8APuq3LNkm7Cw8blz+c1DfbCMXBTViF45+S4uPalRGKmhI7K6fdMZCcLxsqsxqHG4HyEdrKtYpyo6kJgNDrvvrPKUAbl0tdmiaNm8aS1xE89d/qdb08/M3fKeRbyexA2My9/ELKa7qZ+FDR1HtbTJ2Veo28kxgpNiwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247813; c=relaxed/simple;
	bh=AgCua0dymRcO7XAt4CNj34/TvxONwOdyXvaEOEbKoXY=;
	h=Date:To:From:Subject:Message-Id; b=gYTFBUSidolbSLalFOHUT6ApTfe4MnwigQENQNY8zHwThshG9OchrpymGqJ5NZvKQGSUxsCSLG59wobX+wJNrogGV57IOD6vrQmE/SQNOdfQlgIw7f7FmcWZJ5UraQHOUAglhEGXQIB4v3S7z03SHwDuYTDqvVTXUNk8HXTO89E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LW2Hn6/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LW2Hn6/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B6AC4CEC2;
	Mon,  2 Sep 2024 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247813;
	bh=AgCua0dymRcO7XAt4CNj34/TvxONwOdyXvaEOEbKoXY=;
	h=Date:To:From:Subject:From;
	b=LW2Hn6/LgN366D8uWGOyAaWFsN918NfebjxvRwfuM3uRxM0XW/bImiYUhVCg8CNt8
	 mRS0aUpoW25A6h7O7x/7AkeoHSlL0hkzIh0Kn6Tlmj9ygsMecDN+NiCdN0KVzOr8oY
	 29kDkjwifJqI2T4xLFKUbm/Wrn6nNfwQhuaOJWZQ=
Date: Sun, 01 Sep 2024 20:30:12 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,pedro.falcato@gmail.com,npiggin@gmail.com,Liam.Howlett@oracle.com,jeffxu@google.com,david@redhat.com,christophe.leroy@csgroup.eu,mpe@ellerman.id.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-optional-close-to-struct-vm_special_mapping.patch removed from -mm tree
Message-Id: <20240902033013.02B6AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add optional close() to struct vm_special_mapping
has been removed from the -mm tree.  Its filename was
     mm-add-optional-close-to-struct-vm_special_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


