Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246354;
	b=FO4sIAliRj2ctVRV3vxgk89eakc8FbNUwiz+UB7wnADYl4ZAHg+yQVzRFRK8g+33BQ0G
	 H293aBGXwPlBeJBGpnpMaQ0s0QfB6d0loCHHTUuodVEVXQJHCDebQloj9i6NxJOr5A/zg
	 s1Tm6jsRUKN8g4I+1MihyQas7konopklNPwF8YiFgAQtH9dYvy0Kh/TGxmsWlF9bmdkYu
	 WAHa/l60V9N+eVB6lyLjBJYpJ7maPy09SIvKyI1SZFYKIHsw+5+zo2OCjtFR0otZX2T5C
	 A1TWild1biYsUJQPkufTSI2Zq7Kh81zcPFxeny4Gh6lGoO0Ltqw+6IHQADTEloqniig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246354;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=tnPqpmiDB8oCkSMtGspKn4/AcfxoonYozNYFBBign1w=;
	b=OrKpnzujB2mc0VsFM35isIKlko450b/eV4EzSChBUVtVTGqTx+iHZJ5WJPXSFZyYboZv
	 kmyMKwAWkU8fRo0JKL8fAoiqu8gMfmV1TNz88gtl2TOJKuNdyjfklIg71Fqtjrf0owA9L
	 SAZb6BK1291sve3U1mXK6Ld2ekoV5ajs6DA4bYRj6ybcZNAuM3r7njdy4Vpqv/8IC9RB7
	 NNLDXg5oy4M+nw3Pf5Wa6CqxuC1Y/a01i8e0+9p3SnvbhlgBYlYnf+iSf1gHv4To+lmql
	 XpUVjDL3YGJyp3rCAL0gCtp3RU9MdmHUR0dxdLL3djWTzvr3/Okk57UpJPYh30Wl5tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iitKX14J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF05A606A339
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iitKX14J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762221F008A1;
	Mon,  9 Nov 2026 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246353;
	bh=tnPqpmiDB8oCkSMtGspKn4/AcfxoonYozNYFBBign1w=;
	h=Date:To:Cc:From:Subject;
	b=iitKX14JTNfDJXRUHKaHY0ukIrUczlXxPmXW4Wd811X/msQPITk3r1rO6gEuRf0YQ
	 GQlUUwGxASU0dqWLB73vCS6B8FE1lH2OFpamVyeUP3vlr2UdaG/BKor7wDkdrJgsFu
	 kbHAUV0FFOQP4+KNC/PmCpQNQZ3gr13uqFMOygsM=
Date: Mon, 09 Nov 2026 09:45:53 -0800
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch removed from -mm tree
Message-Id: <20261109174553.762221F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
Date: Fri Nov  6 07:58:08 AM PST 2026

make random_read const, per Lorenzo

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
+++ a/mm/filemap.c
@@ -3409,7 +3409,7 @@ static struct file *do_sync_mmap_readahe
 
 	if (force_thp_readahead) {
 		unsigned long folio_nr_pages = 1UL << thp_order;
-		bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
+		const bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
 
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

