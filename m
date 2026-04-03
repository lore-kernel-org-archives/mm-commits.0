Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECAA359A62
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198533; cv=none; b=YH9h/x7K9Eco9XBn+a0WuiaW9nRu7RKCAJUV8T1ptwZUqDIPDl2sfl43bUOWA+XdpfdesmGk5yR9pnZziEhnyU7gHBGLubawLtBwFEbKOKonYSvYAhSfqiUdU/GTPjRmav23EEEKbwcg3CuIGVI1e9Ukxzd5nlrg4PGjrEiPQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198533; c=relaxed/simple;
	bh=1a2hThQZrjTIj/v6Su5gzjMsYeWk5t8L5//Aj2DEl5g=;
	h=Date:To:From:Subject:Message-Id; b=jXLuyRX4CGOQ/L+MI4hp2W3UvbFquiY/AfFhcLX9WFZ44KNPi5XvuvpOB75DoyeSog9l5GtE4Vr3RGbb4+SxgjjxFC87Tbi9nkXg05YIoOJkwqG2cOHoCa5fTwXan9/B8lomlYa81xoYGjDirWj5EEsalACfmCngVsEMQp24/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XFTDCbJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XFTDCbJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00501C4CEF7;
	Fri,  3 Apr 2026 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198533;
	bh=1a2hThQZrjTIj/v6Su5gzjMsYeWk5t8L5//Aj2DEl5g=;
	h=Date:To:From:Subject:From;
	b=XFTDCbJpmyh0IggqChQphcsv3Sn/hBb5o8N5jPBf6NF9iYPgzxEa/gusDijEYFiT4
	 uJmjIE4OP3ICwyAI7NZUBevK05bv3hY3sil+TEWscn/w4s7mS5wo9RGy5ASMp44emS
	 IpN7ad4Qs5pdbMRAOwBXxU+KsY/Ty4Fh7B+jc0mo=
Date: Thu, 02 Apr 2026 23:42:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tytso@mit.edu,svens@linux.ibm.com,song@kernel.org,richard@nod.at,richard.henderson@linaro.org,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,linux@armlinux.org.uk,linmag7@gmail.com,linan122@huawei.com,kernel@xen0n.name,johannes@sipsolutions.net,jason@zx2c4.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,ebiggers@kernel.org,dsterba@suse.com,davem@davemloft.net,dan.j.williams@intel.com,clm@fb.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,alex@ghiti.fr,agordeev@linux.ibm.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] btrfs-use-xor_gen.patch removed from -mm tree
Message-Id: <20260403064213.00501C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: btrfs: use xor_gen
has been removed from the -mm tree.  Its filename was
     btrfs-use-xor_gen.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: btrfs: use xor_gen
Date: Fri, 27 Mar 2026 07:16:57 +0100

Use the new xor_gen helper instead of open coding the loop around
xor_blocks.  This helper is very similar to the existing run_xor helper in
btrfs, except that the destination buffer is passed explicitly.

Link: https://lkml.kernel.org/r/20260327061704.3707577-26-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
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


