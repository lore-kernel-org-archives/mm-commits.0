Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8392EEE61
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334272; cv=none; b=rPiN8ZAjrirwEnhU3mZeBky+gUZT/j3vs3zzqhZEVRfx1HTV3qU4Ms7RTWEjliOHzUe1bqdNQfCb2piUXAvWHa/3BJhi3HdeOAE1bUG5bcWTzb95YlfTTIH31DffMrOFbsJ8z63M+DPqzZE7qaspzEnOFMj91HN52CtyKwCVb0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334272; c=relaxed/simple;
	bh=4OKh7efvuOhRJHCzqRvQAe77iZMBgoy2GbVeBqqvXXw=;
	h=Date:To:From:Subject:Message-Id; b=cq+NYJATkFr+UFAc9Ai7/Fng38IOE7SXNzbeGveGcAca8W1Y6UCJyVbrxu7fiH5Im586teP+FbqIGOEwl9mfQnuttm1NlcPS2LL9v6GIOnidf0vx4ZGgHj+5izr+Xf7orUGywS/1Jbt+X5ku71EQIELGv3k2l69KgAxOgGYZC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJawqAwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJawqAwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91291F0089C;
	Wed,  7 Oct 2026 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334270;
	bh=4u9YPWMlcaWTOQORj/dRAbYDrnnRXSwF2ik4wtiipo4=;
	h=Date:To:From:Subject;
	b=nJawqAwXtY3BhzGDLw52DZG/IO44ZwHzhWBBF5EQbiMPijRRJPxPGmu9lC0KIPW86
	 CRyxwkiKtckbhfz5seNT/wpYCUlwBrZg1nWiCsOUokji3+U9O8iD76e0mJnkzkFeUJ
	 8dhDWn63jtTpB2NEKFUd20n1u1o54SWH1HnEAkTs=
Date: Tue, 06 Oct 2026 17:51:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,syzbot@syzkaller.appspotmail.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,liam@infradead.org,gregkh@linuxfoundation.org,dsahern@kernel.org,david@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tcp-remove-mmap_lock-fallback-path.patch removed from -mm tree
Message-Id: <20261007005110.D91291F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tcp: remove mmap_lock fallback path
has been removed from the -mm tree.  Its filename was
     tcp-remove-mmap_lock-fallback-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: tcp: remove mmap_lock fallback path
Date: Mon, 31 Aug 2026 13:30:56 -0700

Previously, the per-VMA locking could fail in the face of writers
which necessitates a fallback to mmap_lock. The new
vma_start_read_unlocked() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
The fallback removal does not affect NOMMU case because TCP_ZEROCOPY
is gated on CONFIG_MMU.

This really is a nice cleanup. It removes the need to pass the lock
state back and forth to find_tcp_vma().

Link: https://lore.kernel.org/20260831203056.838265-6-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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


