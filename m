Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E914378D72
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788215200; cv=none; b=Ot58fyTSzsaAyNam3PGGFLWrnknmA7pCrx3TCo/WRBqwXRyH/BrCHPl4RfMT511cpXO9BT/VYu49FX04NDprKHEeRXusjRwnjeuc70a6Rbp9vv4PKOSam47Kj1jC+qZ0P8HirABl0A2Fle9nuui/iEm6GjHf73cdpidPQ5g2yuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788215200; c=relaxed/simple;
	bh=2HL3btKFTLv4xdMHEaOSnxvRCCMKYtoR2NY+A+kbdvY=;
	h=Date:To:From:Subject:Message-Id; b=Jpc7V8gDzmS5foODHwMy6PMfdz4hFvWbcqCgIRbrGLfsZxYBsTXcCINU6LE0HwY2L94m7ahNjsQJDMZDaCDkpX3OSjX+faXZdXFFaDBHxygi+IbHqbO50c/Mznki9F8lUDAnEQkVO3RoLv026H2Fcsvh4BwTiVNOkMSlor0FvWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuuKM9Ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuuKM9Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC31F00A3D;
	Mon, 31 Aug 2026 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788215199;
	bh=D7luRKIxqc0/VTfLvbCwIwhB4sNweqhavlsxQYdnvNQ=;
	h=Date:To:From:Subject;
	b=HuuKM9Edh9NQgBEmxRgKyVGRrYvWJwPoI9FiXmZyD6GhxMX094YXHTC0nH9cVateK
	 nDdWRIkbpwLNxasVLpPyGztZOI8GlvQB894hKbp8Jiz3jqcN/HEPL8Le5dwyFsZH33
	 rOGVuiHdtjw37BuP3mTi6WxBGdWWQhCghhvtxT3o=
Date: Mon, 31 Aug 2026 15:26:38 -0700
To: mm-commits@vger.kernel.org,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tcp-remove-mmap_lock-fallback-path.patch removed from -mm tree
Message-Id: <20260831222639.12CC31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tcp: remove mmap_lock fallback path
has been removed from the -mm tree.  Its filename was
     tcp-remove-mmap_lock-fallback-path.patch

This patch was dropped because an updated version will be issued

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


