Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B87378800
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773529185; cv=none; b=KIeH7QJpIaee9UsSTcu333efptcsB3j7WUzAQ2Yi9qCyfP1y/AMxgNHeBaToIPajmTlCbzU8MRw6bsRjP7rzYF9SUDAG7/0MEIiO/CoHP+BC/UnpltOXKoNCjcvxE+Xc2kje8DGj+dqnKJcTD+2ERwwSk8uYwQuncnKX3xalKWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773529185; c=relaxed/simple;
	bh=4BMRmEvAjCqPPMENOBQBqCx332ijHQZg6KUG5lQJBFI=;
	h=Date:To:From:Subject:Message-Id; b=omrwAW1hSq2aKBPMe6fwoidNmPN605yjgUCD2A501tjEjBACzRFqk1ZctjkraX7rprqjsYE3wCCVEFnKzNWVXd1nVp3N6Ip+vpTr676c00LE9CIiYDdgHarbOFn6J9nNFAAJND34ddL0Uy/EypIrwkTwVtfR8+qjnlp4rm0Gm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UNBjNbcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UNBjNbcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47EEC116C6;
	Sat, 14 Mar 2026 22:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773529184;
	bh=4BMRmEvAjCqPPMENOBQBqCx332ijHQZg6KUG5lQJBFI=;
	h=Date:To:From:Subject:From;
	b=UNBjNbcdOZipdCncLPoUJTZBNygVbvUcRBo/CAc7Lm/tq5VwtS1C82wgpiKhQZR3m
	 F8IdUdOV6PTbo8i6nWZY/t4U2bG53R8OUjDQ7JkpDJqKOi8GIl/nMmVwlS5poDF2H9
	 8if7fkfWu7xWEqi5NXr8X+HY76+5mRENd1Y85kaE=
Date: Sat, 14 Mar 2026 15:59:44 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix.patch added to mm-new branch
Message-Id: <20260314225944.B47EEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs: mmap_prepare: fix sphinx warnings and format
has been added to the -mm mm-new branch.  Its filename is
     mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: Docs: mmap_prepare: fix sphinx warnings and format

Fix 'make htmldocs' build warnings, headings style, and quoting
style.

Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included in any toctree [toc.not_included]
Documentation/filesystems/mmap_prepare.rst:60: WARNING: Pygments lexer name 'Cw' is not known [misc.highlighting_failure]
Documentation/filesystems/mmap_prepare.rst:132: ERROR: Anonymous hyperlink mismatch: 1 references but 0 targets.
See "backrefs" attribute for IDs. [docutils]

Link: https://lkml.kernel.org/r/f0e33b51-d465-462d-b0f6-98a1db66bb15@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/index.rst        |    1 
 Documentation/filesystems/mmap_prepare.rst |   74 +++++++++----------
 2 files changed, 38 insertions(+), 37 deletions(-)

--- a/Documentation/filesystems/index.rst~mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix
+++ a/Documentation/filesystems/index.rst
@@ -29,6 +29,7 @@ algorithms work.
    fiemap
    files
    locks
+   mmap_prepare
    multigrain-ts
    mount_api
    quota
--- a/Documentation/filesystems/mmap_prepare.rst~mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -5,19 +5,19 @@ mmap_prepare callback HOWTO
 ===========================
 
 Introduction
-############
+============
 
-The `struct file->f_op->mmap()` callback has been deprecated as it is both a
+The ``struct file->f_op->mmap()`` callback has been deprecated as it is both a
 stability and security risk, and doesn't always permit the merging of adjacent
 mappings resulting in unnecessary memory fragmentation.
 
-It has been replaced with the `file->f_op->mmap_prepare()` callback which solves
-these problems.
+It has been replaced with the ``file->f_op->mmap_prepare()`` callback which
+solves these problems.
 
 ## How To Use
 
-In your driver's `struct file_operations` struct, specify an `mmap_prepare`
-callback rather than an `mmap` one, e.g. for ext4:
+In your driver's struct file_operations struct, specify an ``mmap_prepare``
+callback rather than an ``mmap`` one, e.g. for ext4:
 
 
 .. code-block:: C
@@ -27,9 +27,9 @@ callback rather than an `mmap` one, e.g.
         .mmap_prepare    = ext4_file_mmap_prepare,
     };
 
-This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`.
+This has a signature of ``int (*mmap_prepare)(struct vm_area_desc *)``.
 
-Examining the `struct vm_area_desc` type:
+Examining the struct vm_area_desc type:
 
 .. code-block:: C
 
@@ -57,7 +57,7 @@ Examining the `struct vm_area_desc` type
 This is straightforward - you have all the fields you need to set up the
 mapping, and you can update the mutable and writable fields, for instance:
 
-.. code-block:: Cw
+.. code-block:: C
 
     static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
     {
@@ -78,54 +78,54 @@ mapping, and you can update the mutable
     }
 
 Importantly, you no longer have to dance around with reference counts or locks
-when updating these fields - __you can simply go ahead and change them__.
+when updating these fields - **you can simply go ahead and change them**.
 
 Everything is taken care of by the mapping code.
 
 VMA Flags
-=========
+---------
 
-Along with `mmap_prepare`, VMA flags have undergone an overhaul. Where before
-you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_flags_set()`,
-`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to have the
+Along with ``mmap_prepare``, VMA flags have undergone an overhaul. Where before
+you would invoke one of vm_flags_init(), vm_flags_reset(), vm_flags_set(),
+vm_flags_clear(), and vm_flags_mod() to modify flags (and to have the
 locking done correctly for you, this is no longer necessary.
 
-Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM_WRITE`,
-etc. - i.e. using a `VM_xxx` macro has changed too.
+Also, the legacy approach of specifying VMA flags via ``VM_READ``, ``VM_WRITE``,
+etc. - i.e. using a ``-VM_xxx``- macro has changed too.
 
-When implementing `mmap_prepare()`, reference flags by their bit number, defined
-as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc., and use one
-of (where `desc` is a pointer to `struct vma_area_desc`):
-
-* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list of flags you
-  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_flags(desc,
-  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are set,
-  otherwise `false`.
-* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags to set
+When implementing mmap_prepare(), reference flags by their bit number, defined
+as a ``VMA_xxx_BIT`` macro, e.g. ``VMA_READ_BIT``, ``VMA_WRITE_BIT`` etc.,
+and use one of (where ``desc`` is a pointer to struct vma_area_desc):
+
+* ``vma_desc_test_flags(desc, ...)`` - Specify a comma-separated list of flags
+  you wish to test for (whether _any_ are set), e.g. - ``vma_desc_test_flags(
+  desc, VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`` - returns ``true`` if either are set,
+  otherwise ``false``.
+* ``vma_desc_set_flags(desc, ...)`` - Update the VMA descriptor flags to set
   additional flags specified by a comma-separated list,
-  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
-* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flags to clear
-  flags specified by a comma-separated list, e.g. - `vma_desc_clear_flags(desc,
-  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
+  e.g. - ``vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)``.
+* ``vma_desc_clear_flags(desc, ...)`` - Update the VMA descriptor flags to clear
+  flags specified by a comma-separated list, e.g. - ``vma_desc_clear_flags(
+  desc, VMA_WRITE_BIT, VMA_MAYWRITE_BIT)``.
 
 Actions
 =======
 
 You can now very easily have actions be performed upon a mapping once set up by
-utilising simple helper functions invoked upon the `struct vm_area_desc`
+utilising simple helper functions invoked upon the struct vm_area_desc
 pointer. These are:
 
-* `mmap_action_remap()` - Remaps a range consisting only of PFNs for a specific
+* mmap_action_remap() - Remaps a range consisting only of PFNs for a specific
   range starting a virtual address and PFN number of a set size.
 
-* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only remaps the
-  entire mapping from `start_pfn` onward.
+* mmap_action_remap_full() - Same as mmap_action_remap(), only remaps the
+  entire mapping from ``start_pfn`` onward.
 
-* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only performs an I/O
+* mmap_action_ioremap() - Same as mmap_action_remap(), only performs an I/O
   remap.
 
-* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only remaps
-  the entire mapping from `start_pfn` onward.
+* mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
+  the entire mapping from ``start_pfn`` onward.
 
-**NOTE:** The 'action' field should never normally be manipulated directly,
+**NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-add-documentation-for-the-mmap_prepare-file-operation-callback-fix.patch

