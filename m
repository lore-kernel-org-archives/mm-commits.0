Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971DC23394D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788055055; cv=none; b=GxXY4Ff8JPK0aKfeJqHdYCg80a2u27c4p2yjbSxCh4kdcOKXRT2IZQfX2Usjgo4E4jkgZg168qDQDkZQeBxAFVAzJQIiktqY+Xpj+MQLSlMMqf+YQz+iyK27ixDtF/hxZpUDjzUbCSrBHXamRNobusPQv8dAd1WiZ0c3JO6ZbhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788055055; c=relaxed/simple;
	bh=XHi43ufEBx4lZiOeFUp7Xh6qVVpSTePMNmW1zkTApQQ=;
	h=Date:To:From:Subject:Message-Id; b=A5y1ttGOG+1hF3ITWZggJcw80EZvdvhnTxc8g0cL8mdBqbSLS7jjLU9ooxWSN3TT2RpevsW7Wen+i6rhCXTVQL2ZEFvo7V3yENDas6aG/mmCPA02FwdqKnBPvXrAdr3eTOFln9k9sH1+2Y3JHe+fukpPxRV0yuYcSXl8aXcoAz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEPsGN+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEPsGN+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAC41F000E9;
	Sun, 30 Aug 2026 01:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788055052;
	bh=Sms1cP1LWKsZMYlLbsXC4w6w6wXo8uWGqhEx9oVU5Bk=;
	h=Date:To:From:Subject;
	b=ZEPsGN+aEJWgtyjUGflWa8vW+XAWmMnctMpLoEZq3zX36pqptmoWJBkYVGtAZNYrv
	 aIRx7futCJ9kssaWBpxk/8HRTec2AfQ9wTCot51PxkYG1gz8/aS1+5RQLfTu6+SoFh
	 KvaafaV+SeMsYITXRFFyL1jWBIKDKBW4AvdmM+Ck=
Date: Sat, 29 Aug 2026 18:57:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,dsahern@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binder-remove-mmap_lock-fallback.patch added to mm-new branch
Message-Id: <20260830015732.4CAC41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: binder: remove mmap_lock fallback
has been added to the -mm mm-new branch.  Its filename is
     binder-remove-mmap_lock-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/binder-remove-mmap_lock-fallback.patch

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: binder: remove mmap_lock fallback
Date: Thu, 13 Aug 2026 12:34:32 -0700

Previously, the per-VMA locking could fail in the face of writers which
necessitate a fallback to mmap_lock.  The new vma_start_read_unlocked()
will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

Link: https://lore.kernel.org/20260813193433.3318288-5-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder/page_range.rs |   19 ++---------------
 drivers/android/binder_alloc.c       |   17 ++++-----------
 rust/kernel/mm.rs                    |   27 +++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 28 deletions(-)

--- a/drivers/android/binder_alloc.c~binder-remove-mmap_lock-fallback
+++ a/drivers/android/binder_alloc.c
@@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
 	struct vm_area_struct *vma;
 	int ret = -ESRCH;
 
-	/* attempt per-vma lock first */
-	vma = lock_vma_under_rcu(mm, addr);
-	if (vma) {
-		if (binder_alloc_is_mapped(alloc))
-			ret = vm_insert_page(vma, addr, page);
-		vma_end_read(vma);
+	vma = vma_start_read_unlocked(mm, addr);
+	if (!vma)
 		return ret;
-	}
 
-	/* fall back to mmap_lock */
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, addr);
-	if (vma && binder_alloc_is_mapped(alloc))
+	if (binder_alloc_is_mapped(alloc))
 		ret = vm_insert_page(vma, addr, page);
-	mmap_read_unlock(mm);
+
+	vma_end_read(vma);
 
 	return ret;
 }
--- a/drivers/android/binder/page_range.rs~binder-remove-mmap_lock-fallback
+++ a/drivers/android/binder/page_range.rs
@@ -439,22 +439,9 @@ impl ShrinkablePageRange {
         // workqueue.
         let mm = MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?);
         {
-            let vma_read;
-            let mmap_read;
-            let vma = if let Some(ret) = mm.lock_vma_under_rcu(vma_addr) {
-                vma_read = ret;
-                check_vma(&vma_read, self)
-            } else {
-                mmap_read = mm.mmap_read_lock();
-                mmap_read
-                    .vma_lookup(vma_addr)
-                    .and_then(|vma| check_vma(vma, self))
-            };
-
-            match vma {
-                Some(vma) => vma.vm_insert_page(user_page_addr, &new_page)?,
-                None => return Err(ESRCH),
-            }
+            let vma_read_guard = mm.vma_start_read_unlocked(vma_addr).ok_or(ESRCH)?;
+            let vma = check_vma(&vma_read_guard, self).ok_or(ESRCH)?;
+            vma.vm_insert_page(user_page_addr, &new_page)?;
         }
 
         let inner = self.lock.lock();
--- a/rust/kernel/mm.rs~binder-remove-mmap_lock-fallback
+++ a/rust/kernel/mm.rs
@@ -186,6 +186,33 @@ impl MmWithUser {
         })
     }
 
+    /// Find the VMA covering 'address' and read-lock it.
+    ///
+    /// The fast path does not take mmap_lock. Waits for writers to finish if the
+    /// VMA is being modified by taking mmap_lock.
+    /// Use when mmap_lock is not held, otherwise use vma_start_read_locked().
+    /// Nothing prevents VMAs being unmapped/mapped before or after the VMA is
+    /// looked up, if a stronger guarantee is required, take an mmap_lock.
+    ///
+    /// Return: If a VMA exists which spans @address, return that VMA, read-locked.
+    /// If no VMA is mapped there or, very unlikely, a reference count overflow
+    /// occurred, return NULL.
+    #[inline]
+    pub fn vma_start_read_unlocked(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
+        // SAFETY: We may invoke `vma_start_read_unlocked` because we know this `mm` has non-zero
+        // `mm_users`.
+        let vma = unsafe { bindings::vma_start_read_unlocked(self.as_raw(), vma_addr) };
+        if vma.is_null() {
+            return None;
+        }
+        Some(VmaReadGuard {
+            // SAFETY: If `vma_start_read_unlocked` returns a non-null ptr, then it points at a
+            // valid vma. The vma is stable for as long as the vma read lock is held.
+            vma: unsafe { VmaRef::from_raw(vma) },
+            _nts: NotThreadSafe,
+        })
+    }
+
     /// Lock the mmap read lock.
     #[inline]
     pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-make-per-vma-locks-available-universally.patch
binder-make-shrinker-rely-solely-on-per-vma-lock.patch
mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch
binder-remove-mmap_lock-fallback.patch
tcp-remove-mmap_lock-fallback-path.patch

