Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832327;
	b=ZjMghp5Qe3yshNeH4oyppcFvdhAhO20CVB32lx3TJXL8/iNMGyF9LL2vsgMTRkpqNhcZ
	 g8C2viZVzD4BqR/uiMRR+gI0QRiMoshbH8E+49bOTbMkhCeU8PEoT08shhrjtJwx/nXXL
	 WZmOSj4TsP2hKyGXWcEgo1njXn3r8epboIFsBRe8C7QPp2JLpli6ELZEqsZrRH2KuReXK
	 FYFlL3BHcvqA/kPXNIGK78ufOpIOsLjiaPRX35xyMfpWz/uLCFzLbiH78DDJo4E8Pq+c1
	 nzfERnC3iuIj/OO8v74oSea5etadNSGlPKQ9jPw0QheEZUzujx4gs1EHXg8RexR5J+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832327;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KMAhjL6VoDpD5Up8HakzXixZPf8VBma0CjjBVPZ2R48=;
	b=dvXwYseUhe9g0ETvCOOWBXWxrLs8n/o/e05xSYHgTbIu+CSkfLm83RtwboaJwPBFA3HB
	 GYyu4cmTYPNcouKRcyqo3UxjiqTn5Ochrflx4RaVW5MpAqRCm2RtFv0HD7dQb5RwJwuea
	 k1NLjoqkv2T9+HMiGUQBGTF2GroGt1Gwi01VkkEb8b7Qj+B0p1CGfOo2J6uo9Y3u31e4M
	 blHEAH0W+s2+YiUPFqVaf1RzSY73a879MJ1gr/gMl/OtMe7OfbqSFztTXkCEvPtGwgwa8
	 J8hqk6WZaF1HK9RrTEyTKU9h9p70lpwpTxLtrfyjNaYsQnsUunZ0AsKVsPf/5/TVtEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mstlpoPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58982606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mstlpoPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DC81F01828;
	Sat, 24 Oct 2026 08:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832326;
	bh=KMAhjL6VoDpD5Up8HakzXixZPf8VBma0CjjBVPZ2R48=;
	h=Date:To:From:Subject;
	b=mstlpoPtZNWVhkrcNG6ibR2WyBniY6HAWbmpSpMJqubNPxg2p7Q0TfiBlP9VPTqgy
	 dOYYiIP/Z/jCbgO4LpdbzKl8wIKaaNdDn8wOazhVAs+bk/3xVtwJfKxxOw3LnfgXMz
	 cypsE5nEN45plltqIu6bGZ1EfGRR3tqAE2a9zt4k=
Date: Sat, 24 Oct 2026 01:58:46 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-drop-allocate_pgdat.patch removed from -mm tree
Message-Id: <20261024085846.C7DC81F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: mm: drop allocate_pgdat()
has been removed from the -mm tree.  Its filename was
     sh-mm-drop-allocate_pgdat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: mm: drop allocate_pgdat()
Date: Sun, 10 May 2026 16:55:39 +0300

allocate_pgdat() function used to allocate the node data structure and
initialize its node_start_pfn and node_spanned_pages fields.

Without CONFIG_NUMA there is no need to allocate the node data and setting
node_start_pfn and node_spanned_pages are redundant because they are
anyway overwritten later by core MM.

Remove allocate_pgdat() function.

Link: https://lore.kernel.org/20260510135546.13554-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/mm/init.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/arch/sh/mm/init.c~sh-mm-drop-allocate_pgdat
+++ a/arch/sh/mm/init.c
@@ -201,20 +201,6 @@ void __init page_table_range_init(unsign
 }
 #endif	/* CONFIG_MMU */
 
-void __init allocate_pgdat(unsigned int nid)
-{
-	unsigned long start_pfn, end_pfn;
-
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-
-#ifdef CONFIG_NUMA
-	alloc_node_data(nid);
-#endif
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-}
-
 static void __init do_init_bootmem(void)
 {
 	unsigned long start_pfn, end_pfn;
@@ -224,8 +210,6 @@ static void __init do_init_bootmem(void)
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL)
 		__add_active_range(0, start_pfn, end_pfn);
 
-	/* All of system RAM sits in node 0 for the non-NUMA case */
-	allocate_pgdat(0);
 	node_set_online(0);
 
 	plat_mem_setup();
_

Patches currently in -mm which might be from rppt@kernel.org are


