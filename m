Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB5D2C15BB
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755036168; cv=none; b=oTS8BWILOCD/9Bb9zrSG9tBPregArkb1oGtwqiYB3ddcAuUSphSQO49LIMGyAcOu0uzNN1/S9BIySle/rX3e35FbKAzCJGOyi57qzOhZ3HQsKYyQKZl8fAJy4DxkQGG8RavY53uWmF6rj6i9jCfILCZQsdQxNvDPCizlcA58J4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755036168; c=relaxed/simple;
	bh=HfrmtXxeEVAoO1BmdKwd4zuSSlutpiXWEez3owuw0BE=;
	h=Date:To:From:Subject:Message-Id; b=i1w34dwr/h4oKuYoHVu4Q3PIqIcAphcZYXoUCE4e7bYxtpbGwWVw4zfGtHOqH5eyVe1oU2wP2+Vd+lRXgBNpd375wfBK5HMds0Ae9uo+YBWi8/8155azYt7yV8nUbsgQ+CzTSt/mvnS5g/ZuWwDicY4T+Q8Cqw0dQe0o0tfSdmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ipu1zFdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipu1zFdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3F1C4CEF0;
	Tue, 12 Aug 2025 22:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755036168;
	bh=HfrmtXxeEVAoO1BmdKwd4zuSSlutpiXWEez3owuw0BE=;
	h=Date:To:From:Subject:From;
	b=ipu1zFdpwGbYCAhpI+iZiOZXTMs0+3nvkKZSGVSHqlLN70IakOgNgz+KdD45YKCfr
	 VMe5OpeupRnKJVBxFRDxudXp7BfAw1Ur13YTTtp2MUkRxfD2+JMx9BppW6/n3Gr0c5
	 9DB7n39ljCPa2HqDDPld78uqqcKlkIMK/R+rSvyo=
Date: Tue, 12 Aug 2025 15:02:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sstabellini@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,osalvador@suse.de,oleksandr_tyshchenko@epam.com,npiggin@gmail.com,npache@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jgross@suse.com,jannh@google.com,jack@suse.cz,hughd@google.com,dev.jain@arm.com,david.vrabel@citrix.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch added to mm-new branch
Message-Id: <20250812220248.0D3F1C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
has been added to the -mm mm-new branch.  Its filename is
     powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
Date: Mon, 11 Aug 2025 13:26:26 +0200

We want to make use of "pgtable_level" for an enum in core-mm. Other
architectures seem to call "struct pgtable_level" either:
* "struct pg_level" when not exposed in a header (riscv, arm)
* "struct ptdump_pg_level" when expose in a header (arm64)

So let's follow what arm64 does.

Link: https://lkml.kernel.org/r/20250811112631.759341-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/ptdump/8xx.c      |    2 +-
 arch/powerpc/mm/ptdump/book3s64.c |    2 +-
 arch/powerpc/mm/ptdump/ptdump.h   |    4 ++--
 arch/powerpc/mm/ptdump/shared.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/ptdump/8xx.c~powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel
+++ a/arch/powerpc/mm/ptdump/8xx.c
@@ -69,7 +69,7 @@ static const struct flag_info flag_array
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
--- a/arch/powerpc/mm/ptdump/book3s64.c~powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel
+++ a/arch/powerpc/mm/ptdump/book3s64.c
@@ -102,7 +102,7 @@ static const struct flag_info flag_array
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
--- a/arch/powerpc/mm/ptdump/ptdump.h~powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel
+++ a/arch/powerpc/mm/ptdump/ptdump.h
@@ -11,12 +11,12 @@ struct flag_info {
 	int		shift;
 };
 
-struct pgtable_level {
+struct ptdump_pg_level {
 	const struct flag_info *flag;
 	size_t num;
 	u64 mask;
 };
 
-extern struct pgtable_level pg_level[5];
+extern struct ptdump_pg_level pg_level[5];
 
 void pt_dump_size(struct seq_file *m, unsigned long delta);
--- a/arch/powerpc/mm/ptdump/shared.c~powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel
+++ a/arch/powerpc/mm/ptdump/shared.c
@@ -67,7 +67,7 @@ static const struct flag_info flag_array
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch

