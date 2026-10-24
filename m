Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832435;
	b=yJG69EOJmtKHxVUlBMXTFbTzOAW8JNdnU8dGOMWIX8KhUPRYM7X35sMloCbByLSNEZ49
	 O0HlY3LZDrvIPiF+jzT+uLeZ97eq2beqE9L0x7t7LISqU9GAY22YlsiDVJJV3IJAyINSB
	 fRPk36GsqgLQqsCEQtXaZQ2HRXA9/r9a0pqP4ymgCdv3CkYH84Y/Ea2Bv0TAS6sz4jpKZ
	 28UGniFBSj+IZEGzcN8mJU+3JUb+bugZ9B0wDEjh2iFm3wJ0PNogZA/pIhY4TKghBIA3e
	 /PodoymT6vgvIrozDZET7eR0hLI9YGaAbka8RQqOXUAlAaSZj7LSlWYMgSj4Z5lqBOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832435;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ajn54ao5CIjcWx6I0TSMxHjWP5Rs2RdbBwVTvItKKuA=;
	b=Q1eZV+vmaNOnzyGt2idiTrFY2YHYe0FlTK6GUNkZk26UeNMqhGe/i12yzpOF/uotntMm
	 8rhETJTnjdcytwNylHzTmc2uJvsuzZtcg5cUh2Vmksx6kPY4buyJuUBVMPmhFTvV/TS6F
	 m5x/2KkeTYPqlilkWPMn8O3hpkkkzrPDrrh6UekknOuDk+AsqltADzyrZ4KOFBrSfuSud
	 uF5OvQiQ9cFTTl8+qfPbi7TDX88//57PlsHlpe30rKKqHeipjwMTmDV315p4stc2lEey5
	 Dy/Q/fWOagupTeh+EpFPYAruxy1dQ3j2UB83h8hU8uLvcQiItyU6n46T+Q4kvLQGSwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WDKYXIn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06660606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WDKYXIn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD25C1F01828;
	Sat, 24 Oct 2026 09:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832434;
	bh=ajn54ao5CIjcWx6I0TSMxHjWP5Rs2RdbBwVTvItKKuA=;
	h=Date:To:From:Subject;
	b=WDKYXIn0YIEdCo0ypFaPFaYBeFMDWg2V4CdOZLpBGccXWkMFvjmgVVn3s1j5pWoZZ
	 xf0RhHYy7fZrFr9N3DZu12U9orecWs8TEJIL9P2S8zKC9wcFShkKiKJqV1TPI4dcB5
	 dKGfwIMITkScuT350ADKGQ3UiFCqrSAKqdeo7s00=
Date: Sat, 24 Oct 2026 02:00:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,vbabka@kernel.org,trintaeoitogc@gmail.com,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch removed from -mm tree
Message-Id: <20261024090034.BD25C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: const-ify vma_assert_stabilised() and associated functions
has been removed from the -mm tree.  Its filename was
     mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: const-ify vma_assert_stabilised() and associated functions
Date: Thu, 17 Sep 2026 20:47:41 +0100

Patch series "mm: implement and use vma_has_anon_rmap(), silence KCSAN".

Provide a function to abstract the common task of checking whether a VMA
has an anonymous reverse mapping associated with it.

In the first patch, const-ify vma_assert_stabilised() and related
functions so that vma_has_anon_rmap() can reference a const vma pointer.

In the second patch, introduce vma_has_anon_rmap().

Finally in the third patch, update comments referencing anon_vma to
instead reference the anon rmap to abstract this conceptually to avoid
confusion.

There are still other functions which reference anon_vma directly, those
can be addressed in a follow up.


This patch (of 3):

The vma pointers are not modified in any of these functions so make it
official by const-ify them.

Propagate this throughout the call stack.

No functional change intended.

Link: https://lore.kernel.org/20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org
Link: https://lore.kernel.org/20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de> 
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
---

 include/linux/mmap_lock.h       |   12 ++++++------
 tools/testing/vma/include/dup.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-const-ify-vma_assert_stabilised-and-associated-functions
+++ a/include/linux/mmap_lock.h
@@ -273,7 +273,7 @@ static inline void vma_end_read(struct v
 	vma_refcount_put(vma);
 }
 
-static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
+static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
 {
 	const struct mm_struct *mm = vma->vm_mm;
 
@@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_
  *
  * Returns true if write-locked, otherwise false.
  */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
 {
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
@@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_a
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
@@ -359,7 +359,7 @@ static inline void vma_assert_write_lock
  * lock and is not detached.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
@@ -410,7 +410,7 @@ static inline void vma_assert_locked(str
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
  */
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
@@ -445,7 +445,7 @@ static inline void vma_assert_stabilised
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
--- a/tools/testing/vma/include/dup.h~mm-vma-const-ify-vma_assert_stabilised-and-associated-functions
+++ a/tools/testing/vma/include/dup.h
@@ -1178,7 +1178,7 @@ static inline struct vm_area_struct *vma
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

