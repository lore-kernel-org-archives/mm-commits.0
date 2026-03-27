Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4893FADEB
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632742; cv=none; b=E8+AlX1JiOpS3kmhNvLsciwwa2n758fEvXREe3OHzHl7rw2Pk8ffSRwsCbpH9M+AG1TdjBH0xjhCxaR9sFl0qZWUxDXPGlT2gmgpbD2LfsTP6Jxknyu+YF57DarQJ1mko3OybkYZmdI5me99lg1HcEMu3Y00Up1Fdkw4+eqKb4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632742; c=relaxed/simple;
	bh=WYSpR4H7OzT8MDyLyxgVmeflmDBxQscw+WtnHauKG1g=;
	h=Date:To:From:Subject:Message-Id; b=aTOyVLcsHL2fg/wFxEbMyhJwEreLo4yzaUval0RoQG58hRi6U0i2rmss6U1RhIz6DWY+He9J0HPEuAaeBj8w5l/wElYVfumLu4XXffkYYtEKvw+lmm6Cyoeop+js0Ux8GK01wIPsG7O0wI80PWknUOmr79nvyYBQ50IhvPbrrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FCMUKUR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FCMUKUR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C59C19423;
	Fri, 27 Mar 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632742;
	bh=WYSpR4H7OzT8MDyLyxgVmeflmDBxQscw+WtnHauKG1g=;
	h=Date:To:From:Subject:From;
	b=FCMUKUR00iQtsUFTzu7JeJdD15h+zU50/MEzCG5xdk4f3YXeTdqXGVxTW/pCdnPxC
	 uH2TXVp+Zg8jhGUmVZOvGOOK21QouVSuFNHfWPGvMYYVktgwzkNLTyBx83RAWgXt3L
	 lP8ORIzB3ewGiOiKbC8zcUzkdrziKV2pxRie2l3A=
Date: Fri, 27 Mar 2026 10:32:21 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] btrfs-use-xor_gen.patch removed from -mm tree
Message-Id: <20260327173222.18C59C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: btrfs: use xor_gen
has been removed from the -mm tree.  Its filename was
     btrfs-use-xor_gen.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: btrfs: use xor_gen
Date: Tue, 24 Mar 2026 07:21:59 +0100

Use the new xor_gen helper instead of open coding the loop around
xor_blocks.  This helper is very similar to the existing run_xor helper
in btrfs, except that the destination buffer is passed explicitly.

Link: https://lkml.kernel.org/r/20260324062211.3216301-24-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Li Nan <linan122@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/raid56.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/fs/btrfs/raid56.c~btrfs-use-xor_gen
+++ a/fs/btrfs/raid56.c
@@ -618,26 +618,6 @@ static void cache_rbio(struct btrfs_raid
 }
 
 /*
- * helper function to run the xor_blocks api.  It is only
- * able to do MAX_XOR_BLOCKS at a time, so we need to
- * loop through.
- */
-static void run_xor(void **pages, int src_cnt, ssize_t len)
-{
-	int src_off = 0;
-	int xor_src_cnt = 0;
-	void *dest = pages[src_cnt];
-
-	while(src_cnt > 0) {
-		xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
-		xor_blocks(xor_src_cnt, len, dest, pages + src_off);
-
-		src_cnt -= xor_src_cnt;
-		src_off += xor_src_cnt;
-	}
-}
-
-/*
  * Returns true if the bio list inside this rbio covers an entire stripe (no
  * rmw required).
  */
@@ -1434,7 +1414,8 @@ static void generate_pq_vertical_step(st
 	} else {
 		/* raid5 */
 		memcpy(pointers[rbio->nr_data], pointers[0], step);
-		run_xor(pointers + 1, rbio->nr_data - 1, step);
+		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
+				step);
 	}
 	for (stripe = stripe - 1; stripe >= 0; stripe--)
 		kunmap_local(pointers[stripe]);
@@ -2034,7 +2015,7 @@ pstripe:
 		pointers[rbio->nr_data - 1] = p;
 
 		/* Xor in the rest */
-		run_xor(pointers, rbio->nr_data - 1, step);
+		xor_gen(p, pointers, rbio->nr_data - 1, step);
 	}
 
 cleanup:
@@ -2672,7 +2653,7 @@ static bool verify_one_parity_step(struc
 	} else {
 		/* RAID5. */
 		memcpy(pointers[nr_data], pointers[0], step);
-		run_xor(pointers + 1, nr_data - 1, step);
+		xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
 	}
 
 	/* Check scrubbing parity and repair it. */
_

Patches currently in -mm which might be from hch@lst.de are

xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

