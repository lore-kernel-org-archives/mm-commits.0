Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BDA215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188316; cv=none; b=EN0zPggFv7lfhXjI7AjFJFyGbJmYA0gy00wwplyPhuB4YrxPpN8oa/TJphHKTt4vOef3O5WTOyh/iFHc6IQZ228S2b96M94rFEfTH52AQZV/+639CjZsPlIq3YW6g1Y7ShU1vRU+rVUHLwBCWkx9OYPJbUSPFqpF9terzteFMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188316; c=relaxed/simple;
	bh=DgA0BuI2DBrQaH31eL+VFKxrp4TKQBa2ve1jrAc1F4Q=;
	h=Date:To:From:Subject:Message-Id; b=PVspSqxKlsRnWgLf1i7eDV5t+BSMjVJ8gdj4T3W+YGOXAD30aEv3BEk7VWkWaoXGDu8ARhAAO35dIKfjdh53RQcu/buTMgNOnNzixCDQbJaDWH6CwpYVe1yxHIB3CGBoEg1EyhzWiHE+LePcEEjDDf9Iczf379VhO+UbjCHy+Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X7L+bZvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X7L+bZvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D04C4CEEC;
	Mon, 17 Mar 2025 05:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188315;
	bh=DgA0BuI2DBrQaH31eL+VFKxrp4TKQBa2ve1jrAc1F4Q=;
	h=Date:To:From:Subject:From;
	b=X7L+bZvb75TsCO5s5XaF7Qrje3H4AoGvUh4Suyj9CenM3Kv9egRF72ekSX+ra9k+W
	 3KGXSrPQOQzA2sStL3g9j2kpzmRrHJy5KFV3J9uaHASB9WZK7mGxvuwRugQGAXTmjR
	 bZC0clyzbmUv+dsYwLCe6OTHUSGZWiJCGKBec2zY=
Date: Sun, 16 Mar 2025 22:11:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch removed from -mm tree
Message-Id: <20250317051155.B1D04C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow vma_start_read_locked/vma_start_read_locked_nested to fail
has been removed from the -mm tree.  Its filename was
     mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: allow vma_start_read_locked/vma_start_read_locked_nested to fail
Date: Thu, 13 Feb 2025 14:46:44 -0800

With upcoming replacement of vm_lock with vm_refcnt, we need to handle a
possibility of vma_start_read_locked/vma_start_read_locked_nested failing
due to refcount overflow.  Prepare for such possibility by changing these
APIs and adjusting their users.

Link: https://lkml.kernel.org/r/20250213224655.1680278-8-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 mm/userfaultfd.c   |   30 +++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail
+++ a/include/linux/mm.h
@@ -747,10 +747,11 @@ static inline bool vma_start_read(struct
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  */
-static inline void vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
+static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
 {
 	mmap_assert_locked(vma->vm_mm);
 	down_read_nested(&vma->vm_lock.lock, subclass);
+	return true;
 }
 
 /*
@@ -759,10 +760,11 @@ static inline void vma_start_read_locked
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  */
-static inline void vma_start_read_locked(struct vm_area_struct *vma)
+static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
 	down_read(&vma->vm_lock.lock);
+	return true;
 }
 
 static inline void vma_end_read(struct vm_area_struct *vma)
--- a/mm/userfaultfd.c~mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail
+++ a/mm/userfaultfd.c
@@ -85,8 +85,12 @@ static struct vm_area_struct *uffd_lock_
 
 	mmap_read_lock(mm);
 	vma = find_vma_and_prepare_anon(mm, address);
-	if (!IS_ERR(vma))
-		vma_start_read_locked(vma);
+	if (!IS_ERR(vma)) {
+		bool locked = vma_start_read_locked(vma);
+
+		if (!locked)
+			vma = ERR_PTR(-EAGAIN);
+	}
 
 	mmap_read_unlock(mm);
 	return vma;
@@ -1555,12 +1559,24 @@ static int uffd_move_lock(struct mm_stru
 
 	mmap_read_lock(mm);
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
-	if (!err) {
-		vma_start_read_locked(*dst_vmap);
-		if (*dst_vmap != *src_vmap)
-			vma_start_read_locked_nested(*src_vmap,
-						SINGLE_DEPTH_NESTING);
+	if (err)
+		goto out;
+
+	if (!vma_start_read_locked(*dst_vmap)) {
+		err = -EAGAIN;
+		goto out;
 	}
+
+	/* Nothing further to do if both vmas are locked. */
+	if (*dst_vmap == *src_vmap)
+		goto out;
+
+	if (!vma_start_read_locked_nested(*src_vmap, SINGLE_DEPTH_NESTING)) {
+		/* Undo dst_vmap locking if src_vmap failed to lock */
+		vma_end_read(*dst_vmap);
+		err = -EAGAIN;
+	}
+out:
 	mmap_read_unlock(mm);
 	return err;
 }
_

Patches currently in -mm which might be from surenb@google.com are


