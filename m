Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED3F35F5E9
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632738; cv=none; b=dl8maUYoTmkdnI6ln0yPe1j3w6LwE35hVx8/yso0rFVqjLjMRBOy3/+xJHhulO6QSL7ShZ98tFVgsRkM6ZNbnMW/POWWxB/oUhoYGlXuZfpdjJeJ765kwI8p2Y37S41R7qmmD5UPcwHXP08po+QYFs079641zuNWcBgdtLJMPDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632738; c=relaxed/simple;
	bh=VNrFQKAU9SWi/ZdklsxfwBeg/q/PFFrPmYerVQ7Ya3U=;
	h=Date:To:From:Subject:Message-Id; b=OupNPaBO7euEtO6zM5lsHbScRB30qusOk++enTbszIdnAkI+f83CnHUetIa2LOAoRsy7P37H4djEnKCZacGFVI/5Rra6vggwY7dkEfsZ0E9siKQkARxYHs8erlMOpvv9MkRR98HyBGeRbtsYtICtUL0xNc8tZkzxVxR+yq37zbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yYLI7Bzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yYLI7Bzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37724C19423;
	Fri, 27 Mar 2026 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632738;
	bh=VNrFQKAU9SWi/ZdklsxfwBeg/q/PFFrPmYerVQ7Ya3U=;
	h=Date:To:From:Subject:From;
	b=yYLI7BzfxZEesB5dej+XYxWe96S4kSQi7CIBEviluXBItzmZ8RUT+Z+DhVVs3OOGI
	 00uX9LeoFW96xES3xpb1Ep6t7kkXT3VPf9QODUWDigUieXbJ3Q0F8xfbBDUnfnHZIQ
	 9cXHcseg0yrlw9HZm6lW9utsh3lWW+3FvbEwlDS8=
Date: Fri, 27 Mar 2026 10:32:17 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xor-add-a-better-public-api.patch removed from -mm tree
Message-Id: <20260327173218.37724C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xor: add a better public API
has been removed from the -mm tree.  Its filename was
     xor-add-a-better-public-api.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xor: add a better public API
Date: Tue, 24 Mar 2026 07:21:57 +0100

xor_blocks is very annoying to use, because it is limited to 4 + 1
sources / destinations, has an odd argument order and is completely
undocumented.

Lift the code that loops around it from btrfs and async_tx/async_xor into
common code under the name xor_gen and properly document it.

Link: https://lkml.kernel.org/r/20260324062211.3216301-22-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
Cc: David Sterba <dsterba@suse.com>
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

 include/linux/raid/xor.h |    2 ++
 lib/raid/xor/xor-core.c  |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/raid/xor.h~xor-add-a-better-public-api
+++ a/include/linux/raid/xor.h
@@ -7,4 +7,6 @@
 extern void xor_blocks(unsigned int count, unsigned int bytes,
 	void *dest, void **srcs);
 
+void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes);
+
 #endif /* _XOR_H */
--- a/lib/raid/xor/xor-core.c~xor-add-a-better-public-api
+++ a/lib/raid/xor/xor-core.c
@@ -46,6 +46,38 @@ xor_blocks(unsigned int src_count, unsig
 }
 EXPORT_SYMBOL(xor_blocks);
 
+/**
+ * xor_gen - generate RAID-style XOR information
+ * @dest:	destination vector
+ * @srcs:	source vectors
+ * @src_cnt:	number of source vectors
+ * @bytes:	length in bytes of each vector
+ *
+ * Performs bit-wise XOR operation into @dest for each of the @src_cnt vectors
+ * in @srcs for a length of @bytes bytes.  @src_count must be non-zero, and the
+ * memory pointed to by @dest and each member of @srcs must be at least 64-byte
+ * aligned.  @bytes must be non-zero and a multiple of 512.
+ *
+ * Note: for typical RAID uses, @dest either needs to be zeroed, or filled with
+ * the first disk, which then needs to be removed from @srcs.
+ */
+void xor_gen(void *dest, void **srcs, unsigned int src_cnt, unsigned int bytes)
+{
+	unsigned int src_off = 0;
+
+	WARN_ON_ONCE(bytes & 511);
+
+	while (src_cnt > 0) {
+		unsigned int this_cnt = min(src_cnt, MAX_XOR_BLOCKS);
+
+		xor_blocks(this_cnt, bytes, dest, srcs + src_off);
+
+		src_cnt -= this_cnt;
+		src_off += this_cnt;
+	}
+}
+EXPORT_SYMBOL(xor_gen);
+
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
 static bool __initdata xor_forced = false;
_

Patches currently in -mm which might be from hch@lst.de are

async_xor-use-xor_gen.patch
btrfs-use-xor_gen.patch
xor-pass-the-entire-operation-to-the-low-level-ops.patch
xor-use-static_call-for-xor_gen.patch
xor-add-a-kunit-test-case.patch

