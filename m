Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B5A2E2F14
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939836; cv=none; b=r0OaECZ4DtXUWaB+P1XP79wPJPsY9BzjK02YMHo4JX/Wye54iSJdcgrWCDrP9wEbJwjFyZCKewusuyXqtxKAcDt+76CXUlKwxqhlJYpC2yOEDiSoYQ9N3QzMvTEo5CAToQicJVj9nJ603YVcNxlatmqz4VGxetQcsJ1l+628CG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939836; c=relaxed/simple;
	bh=mSMjg6A4Msaoe8nX1l/7JNp88hHlMgXxWGDGQCLbPXs=;
	h=Date:To:From:Subject:Message-Id; b=DvKJBVBu+BRdstIpWuuBv4XrNtFQI2KROinAR+5lWfHO3RUcdViRd7yp+SAxK9sDFXxkAAaiTkubQTkn7M6Uo+HIEFOuIDXeIx2lkiaBFmUfQCncA98wUHAP8nCG5aGNNlhqwAzLmeoscvMDwp+HXA7iziFRcimKxKIE5mP9Adw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFzf98Bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFzf98Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A72C4CEF7;
	Thu, 12 Feb 2026 23:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939836;
	bh=mSMjg6A4Msaoe8nX1l/7JNp88hHlMgXxWGDGQCLbPXs=;
	h=Date:To:From:Subject:From;
	b=tFzf98Bc7RQdM66BE3QQS2hd5N6UK1pa1wq0ygWqEclIe/NHrL+Kt5bV+AroJDEuc
	 2PN1tVLsYSHFX/vXC9zdV+EC739nmY5juAJcesj1KIq+BUEV++SoeFHbGPd5w4Z5Le
	 wmB/72/tsS9z+yXNrytdpJDgnIc6f3FwJxDz5Qb0=
Date: Thu, 12 Feb 2026 15:43:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch removed from -mm tree
Message-Id: <20260212234356.59A72C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove __private sparse decoration from vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: remove __private sparse decoration from vma_flags_t
Date: Thu, 22 Jan 2026 16:06:10 +0000

Patch series "mm: add bitmap VMA flag helpers and convert all mmap_prepare
to use them", v2.

We introduced the bitmap VMA type vma_flags_t in the aptly named commit
9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
future growth in VMA flags and to prevent the asinine requirement that VMA
flags be available to 64-bit kernels only if they happened to use a bit
number about 32-bits.

This is a long-term project as there are very many users of VMA flags
within the kernel that need to be updated in order to utilise this new
type.

In order to further this aim, this series adds a number of helper
functions to enable ordinary interactions with VMA flags - that is
testing, setting and clearing them.

In order to make working with VMA bit numbers less cumbersome this series
introduces the mk_vma_flags() helper macro which generates a vma_flags_t
from a variadic parameter list, e.g.:

	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
					 VMA_EXEC_BIT);

It turns out that the compiler optimises this very well to the point that
this is just as efficient as using VM_xxx pre-computed bitmap values.

This series then introduces the following functions:

	bool vma_flags_test_mask(vma_flags_t flags, vma_flags_t to_test);
	bool vma_flags_test_all_mask(vma_flags_t flags, vma_flags_t to_test);
	void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set);
	void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t to_clear);

Providing means of testing any flag, testing all flags, setting, and
clearing a specific vma_flags_t mask.

For convenience, helper macros are provided - vma_flags_test(),
vma_flags_set() and vma_flags_clear(), each of which utilise
mk_vma_flags() to make these operations easier, as well as an
EMPTY_VMA_FLAGS macro to make initialisation of an empty vma_flags_t value
easier, e.g.:

	vma_flags_t flags = EMPTY_VMA_FLAGS;

	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
	...
	if (vma_flags_test(flags, VMA_READ_BIT)) {
		...
	}
	...
	if (vma_flags_test_all_mask(flags, VMA_REMAP_FLAGS)) {
		...
	}
	...
	vma_flags_clear(&flags, VMA_READ_BIT);

Since callers are often dealing with a vm_area_struct (VMA) or
vm_area_desc (VMA descriptor as used in .mmap_prepare) object, this series
further provides helpers for these - firstly vma_set_flags_mask() and
vma_set_flags() for a VMA:

	vma_flags_t flags = EMPTY_VMA_FLAGS:

	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
	...
	vma_set_flags_mask(&vma, flags);
	...
	vma_set_flags(&vma, VMA_DONTDUMP_BIT);

Note that these do NOT ensure appropriate locks are taken and assume the
callers takes care of this.

For VMA descriptors this series adds vma_desc_[test, set,
clear]_flags_mask() and vma_desc_[test, set, clear]_flags() for a VMA
descriptor, e.g.:

	static int foo_mmap_prepare(struct vm_area_desc *desc)
	{
		...
		vma_desc_set_flags(desc, VMA_SEQ_READ_BIT);
		vma_desc_clear_flags(desc, VMA_RAND_READ_BIT);
		...
		if (vma_desc_test_flags(desc, VMA_SHARED_BIT) {
			...
		}
		...
	}

With these helpers introduced, this series then updates all mmap_prepare
users to make use of the vma_flags_t vm_area_desc->vma_flags field rather
than the legacy vm_flags_t vm_area_desc->vm_flags field.

In order to do so, several other related functions need to be updated,
with separate patches for larger changes in hugetlbfs, secretmem and shmem
before finally removing vm_area_desc->vm_flags altogether.

This lays the foundations for future elimination of vm_flags_t and
associated defines and functionality altogether in the long run, and
elimination of the use of vm_flags_t in f_op->mmap() hooks in the near
term as mmap_prepare replaces these.

There is a useful synergy between the VMA flags and mmap_prepare work here
as with this change in place, converting f_op->mmap() to
f_op->mmap_prepare naturally also converts use of vm_flags_t to
vma_flags_t in all drivers which declare mmap handlers.

This accounts for the majority of the users of the legacy vm_flags_*()
helpers and thus a large number of drivers which need to interact with VMA
flags in general.

This series also updates the userland VMA tests to account for the change,
and adds unit tests for these helper functions to assert that they behave
as expected.

In order to faciliate this change in a sensible way, the series also
separates out the VMA unit tests into - code that is duplicated from the
kernel that should be kept in sync, code that is customised for test
purposes and code that is stubbed out.

We also separate out the VMA userland tests into separate files to make it
easier to manage and to provide a sensible baseline for adding the
userland tests for these helpers.


This patch (of 13):

We need to pass around these values and access them in a way that sparse
does not allow, as __private implies noderef, i.e.  disallowing
dereference of the value, which manifests as sparse warnings even when
passed around benignly.

Link: https://lkml.kernel.org/r/cover.1769097829.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/64fa89f416f22a60ae74cfff8fd565e7677be192.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    4 ++--
 include/linux/mm_types.h |   14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-vma-remove-__private-sparse-decoration-from-vma_flags_t
+++ a/include/linux/mm.h
@@ -943,7 +943,7 @@ static inline void vm_flags_reset_once(s
 	 * system word.
 	 */
 	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
+		unsigned long *bitmap = vma->flags.__vma_flags;
 
 		bitmap_zero(&bitmap[1], NUM_VMA_FLAG_BITS - BITS_PER_LONG);
 	}
@@ -1006,7 +1006,7 @@ static inline bool __vma_flag_atomic_val
 static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 				       vma_flag_t bit)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
+	unsigned long *bitmap = vma->flags.__vma_flags;
 
 	vma_assert_stabilised(vma);
 	if (__vma_flag_atomic_valid(vma, bit))
--- a/include/linux/mm_types.h~mm-vma-remove-__private-sparse-decoration-from-vma_flags_t
+++ a/include/linux/mm_types.h
@@ -866,7 +866,7 @@ struct mmap_action {
 #define NUM_VMA_FLAG_BITS BITS_PER_LONG
 typedef struct {
 	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
-} __private vma_flags_t;
+} vma_flags_t;
 
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
@@ -1059,7 +1059,7 @@ struct vm_area_struct {
 /* Clears all bits in the VMA flags bitmap, non-atomically. */
 static inline void vma_flags_clear_all(vma_flags_t *flags)
 {
-	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
+	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
 
 /*
@@ -1070,7 +1070,9 @@ static inline void vma_flags_clear_all(v
  */
 static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
 {
-	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+	unsigned long *bitmap = flags->__vma_flags;
+
+	bitmap[0] = value;
 }
 
 /*
@@ -1081,7 +1083,7 @@ static inline void vma_flags_overwrite_w
  */
 static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	WRITE_ONCE(*bitmap, value);
 }
@@ -1089,7 +1091,7 @@ static inline void vma_flags_overwrite_w
 /* Update the first system word of VMA flags setting bits, non-atomically. */
 static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap |= value;
 }
@@ -1097,7 +1099,7 @@ static inline void vma_flags_set_word(vm
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
 static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap &= ~value;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


