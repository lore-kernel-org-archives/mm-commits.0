Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832535;
	b=W8HUNqRfqwnOPRmChS54YhjxQe6Y0VrCfXO7NqG013QMoX9ejA8gwzpvhP65rsMs9uoj
	 rU9T9TbFvaKGcLVb6tJ5MipR+WS3TSK1vjbu+oV7SkpmimOGGCnGu3qbBEBfN5HJ9eh5w
	 q+yKQnpLY31HKAbhAeeAOr0ZCh7GKmDdEVH+deEQOQqb8CZ7qmjKXfYr1jMDxJ4r/ES01
	 5MVwN3ytM/oNpdaiS0Ul+IKOFUqH+IOfhbJmQpvO2l76gWyC4J2jD7Go/hi6b9Dt1Jkkn
	 ZXJJ3H9ntm+Igw3OaTYpACBK2Sd6TZQR4vjOfmTsUdFzySmbl8q9pndh1IiEWnbsgww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832535;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1LtA8pr93j8P7KqKsav2OQgRY6SqlXaOOB05KK0ZYjA=;
	b=22pdcyk3mj7rv6+SP37uGwpju+ME/l8HY12QARToRAN2hszgqu5ZfRkrB/JbAcXFlcN3
	 d50/QFZP56e0lTtP3vaHaUp9CKNWXoErfA+jBIg+BoQPDSAxuJOY3uu4aG3R4s8LtL6eQ
	 Y8dty5LV00WP1HdxZx7glvNh2eLM55K93qao6JdQBFla8vPa7r55E7j5tuD8iGTEMjsro
	 kLI8HlCPwhNLPnBlSG0euYkGdHJ6oybvQDm54N9r2uptMQmgt/3vJIVdh6g1Vi/opSSkp
	 qhMCPiwUt0e8xBxd8oeE1waGxznpYkwUoL7KYbBesFX+GVWXg0o+GM5eTD2xIJLqA/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n++8zO9T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6877606A31A;
	Sat, 24 Oct 2026 09:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=n++8zO9T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B01F01828;
	Sat, 24 Oct 2026 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832534;
	bh=1LtA8pr93j8P7KqKsav2OQgRY6SqlXaOOB05KK0ZYjA=;
	h=Date:To:From:Subject;
	b=n++8zO9TWHsUiBgPeNt4YFmbH+KiXPOXa20Zp6Xzf3+kALPxiYONa2pck8poPWDMn
	 8il/Y4qULJD4jMpR657Ms0ZvLq3pP3wNibXuarMILhxwDSrKG/sYSJvYmskXGc6oDh
	 xkFAWH7cNuzEHufj4VGQIlSrHaEZoIvpOq68bNwg=
Date: Sat, 24 Oct 2026 02:02:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,liam@infradead.org,jannh@google.com,bgeffon@google.com,0x7f454c46@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch removed from -mm tree
Message-Id: <20261024090214.A08B01F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mremap: correctly uncharge accountable VMAs in error path
has been removed from the -mm tree.  Its filename was
     mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: correctly uncharge accountable VMAs in error path
Date: Mon, 19 Oct 2026 16:57:48 +0100

The mremap error path is a fragile and unwieldy beast - it reverses the
page table move then updates vma_remap_struct state to swap VMA, length and
address between old and new VMAs in copy_vma_and_data().

If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
than the old one.

For accountable VMAs when MREMAP_DONTUNMAP is not specified,
unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
only the delta of a VMA expansion is charged (performed by
vrm_calc_charge() earlier).

Therefore nothing uncharges the expanded VMA size, and there is a permanent
leak in global Committed_AS.

Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.

Link: https://lore.kernel.org/20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/mremap.c~mm-mremap-correctly-uncharge-accountable-vmas-in-error-path
+++ a/mm/mremap.c
@@ -1339,6 +1339,20 @@ static int copy_vma_and_data(struct vma_
 		pmc_revert.need_rmap_locks = true;
 		move_page_tables(&pmc_revert);
 
+		/*
+		 * When copy_vma_and_data() returns, the new VMA will be
+		 * unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified, so only do so if the
+		 * latter is true.
+		 */
+		if (!(vrm->flags & MREMAP_DONTUNMAP))
+			vrm_uncharge(vrm);
+
 		vrm->vma = new_vma;
 		vrm->old_len = vrm->new_len;
 		vrm->addr = vrm->new_addr;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

