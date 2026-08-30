Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BEE10F2
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788055195; cv=none; b=kOAt8ZxZ8TMis7khgreYH0vN1MpnCMi2ICgR4M8vlFiX9iEZRRl+ibAOY4RBfuCWvrXN9Xdn3mDlMAIMl6zBxLAqBaHEhj1XZJunyU8yZBBlUi21DuaTXht36IiDd7BvbIqHuW98hPsAbMEdsZDvGJiuU3/WDpyuRgXMXJo3rfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788055195; c=relaxed/simple;
	bh=g7RupAQBFurHf4NOG9uHb5b0phlgr68havDt7tvPg5E=;
	h=Date:To:From:Subject:Message-Id; b=IiKzrVV438IrO1MBe7nK3UtcpXv6DSixARrwhIbWC017xVbZ/NbfpClIoH+lpCVkrQW9qYALAazCO/pIVWGSSTM3biJL03GNwxe4QOYQLuP1G6MtSegN4bWrc8OXDCY4tgZ2Jk6REyGb/fI6HBByMRgd5Xz1Rjbacyze3wxA1b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uPzf2w6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uPzf2w6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479E31F000E9;
	Sun, 30 Aug 2026 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788055194;
	bh=6mea1FiQR9PrI1QvTs6SuSNud7JNMd53QA0N75N55Ds=;
	h=Date:To:From:Subject;
	b=uPzf2w6qbbBSdvjhudW9i+FWUh7kwBOyB6pyvZgcq7yXV3UHNubZGJGTDsZit5Rv+
	 mHggym2hHoNc7iN4039BZ4PbE/XC9P4iW4LvqWynJhaJe0N27Ebg7VrscF/U9Q4W9+
	 cHEUP/YGGSavvHfZO2aUoxDfvw7R1IvwHgc519EE=
Date: Sat, 29 Aug 2026 18:59:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,liam@infradead.org,gregkh@linuxfoundation.org,dsahern@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tcp-remove-mmap_lock-fallback-path.patch added to mm-new branch
Message-Id: <20260830015954.479E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tcp: remove mmap_lock fallback path
has been added to the -mm mm-new branch.  Its filename is
     tcp-remove-mmap_lock-fallback-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tcp-remove-mmap_lock-fallback-path.patch

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
Subject: tcp: remove mmap_lock fallback path
Date: Thu, 13 Aug 2026 12:34:33 -0700

Previously, the per-VMA locking could fail in the face of writers which
necessitates a fallback to mmap_lock.  The new vma_start_read_unlocked()
will wait for writers instead of failing.

Use the new helper.  Wait for writers.  Remove the fallback to mmap_lock. 
The fallback removal does not affect NOMMU case because TCP_ZEROCOPY is
gated on CONFIG_MMU.

This really is a nice cleanup.  It removes the need to pass the lock state
back and forth to find_tcp_vma().

Link: https://lore.kernel.org/20260813193433.3318288-6-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Liam R. Howlett <liam@infradead.org>
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

 net/ipv4/tcp.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/net/ipv4/tcp.c~tcp-remove-mmap_lock-fallback-path
+++ a/net/ipv4/tcp.c
@@ -2167,27 +2167,18 @@ static void tcp_zc_finalize_rx_tstamp(st
 }
 
 static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
-					   unsigned long address,
-					   bool *mmap_locked)
+					   unsigned long address)
 {
-	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
+	struct vm_area_struct *vma = vma_start_read_unlocked(mm, address);
 
-	if (vma) {
-		if (vma->vm_ops != &tcp_vm_ops) {
-			vma_end_read(vma);
-			return NULL;
-		}
-		*mmap_locked = false;
-		return vma;
-	}
+	if (!vma)
+		return NULL;
 
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, address);
-	if (!vma || vma->vm_ops != &tcp_vm_ops) {
-		mmap_read_unlock(mm);
+	if (vma->vm_ops != &tcp_vm_ops) {
+		vma_end_read(vma);
 		return NULL;
 	}
-	*mmap_locked = true;
+
 	return vma;
 }
 
@@ -2208,7 +2199,6 @@ static int tcp_zerocopy_receive(struct s
 	u32 seq = tp->copied_seq;
 	u32 total_bytes_to_map;
 	int inq = tcp_inq(sk);
-	bool mmap_locked;
 	int ret;
 
 	zc->copybuf_len = 0;
@@ -2233,7 +2223,7 @@ static int tcp_zerocopy_receive(struct s
 		return 0;
 	}
 
-	vma = find_tcp_vma(current->mm, address, &mmap_locked);
+	vma = find_tcp_vma(current->mm, address);
 	if (!vma)
 		return -EINVAL;
 
@@ -2315,10 +2305,7 @@ static int tcp_zerocopy_receive(struct s
 						   zc, total_bytes_to_map);
 	}
 out:
-	if (mmap_locked)
-		mmap_read_unlock(current->mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 	/* Try to copy straggler data. */
 	if (!ret)
 		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-make-per-vma-locks-available-universally.patch
binder-make-shrinker-rely-solely-on-per-vma-lock.patch
mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch
binder-remove-mmap_lock-fallback.patch
tcp-remove-mmap_lock-fallback-path.patch

