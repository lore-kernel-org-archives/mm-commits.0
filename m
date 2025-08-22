Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AAD27602E
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 22:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755903407; cv=none; b=UO95MWvrB4xsPHQiexkTj4UeusiEoOjeQebAXdlBQWOwTJJOgeixo7N66XbwGX6lbNOLrwWwT5ltfqwkCz5PSWw3O4hk98plyJgr9krkPJ/3PkA55y0x5YpfZvl3DInDI3+1qO0Jw037fAMZyKj+KycNqb2YkA6u2hUTtcHDzF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755903407; c=relaxed/simple;
	bh=gSuBaWeClff2UrYWTh/AJTnERspTLXXPoRXOnz8C3T4=;
	h=Date:To:From:Subject:Message-Id; b=bFkazKk26M724e2CfNDj6unxAFC0QZSQX0E3xIHZQuNO6anH4w0B6/Xfib0K4uZGz459lbdRp0EdUUJIUeasq16I9iVbanJUVJfD3y3UXcBOobn0IiJb1SAfCtOOJ2RLjHPWxZ9fojWzTJLVYLKEpeAvnCixnvJo5J52/5gJA8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p+VHMlD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p+VHMlD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB8BC4CEED;
	Fri, 22 Aug 2025 22:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755903407;
	bh=gSuBaWeClff2UrYWTh/AJTnERspTLXXPoRXOnz8C3T4=;
	h=Date:To:From:Subject:From;
	b=p+VHMlD/jeZwssTHano7t8Lo8TOmhM+KA5Sok5SB+XPS7AgqSmZdofy2vTW9ugkbK
	 5dcXKnqZsWCeG0VH6s5lyCiN8njMGDn+dZKloAqHDlFVNoRc9tNlv++wzHmoknWIEO
	 DCRdXwPhFIxznc1TlK9ngY+gC9Ki8PqnGnP4g3tA=
Date: Fri, 22 Aug 2025 15:56:46 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,flintglass@gmail.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baohua@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch added to mm-unstable branch
Message-Id: <20250822225646.DEB8BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-store-page_size-compression-failed-page-as-is-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm-zswap-store-page_size-compression-failed-page-as-is-v5
Date: Fri, 22 Aug 2025 12:08:17 -0700

- Restore reject_compress_poor code path.
- Remove crypto_compress_fail debugfs file.

Link: https://lkml.kernel.org/r/20250822190817.49287-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Takero Funaki <flintglass@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-store-page_size-compression-failed-page-as-is-v5
+++ a/mm/zswap.c
@@ -62,8 +62,6 @@ static u64 zswap_written_back_pages;
 static u64 zswap_reject_reclaim_fail;
 /* Store failed due to compression algorithm failure */
 static u64 zswap_reject_compress_fail;
-/* Compression failed by the crypto library */
-static u64 zswap_crypto_compress_fail;
 /* Compressed page was too big for the allocator to (optimally) store */
 static u64 zswap_reject_compress_poor;
 /* Load or writeback failed due to decompression failure */
@@ -990,14 +988,12 @@ static bool zswap_compress(struct page *
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen) {
-		zswap_crypto_compress_fail++;
+	if (comp_ret || !dlen)
 		dlen = PAGE_SIZE;
-	}
 	if (dlen >= PAGE_SIZE) {
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
-			comp_ret = -EINVAL;
+			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
 		comp_ret = 0;
@@ -1855,8 +1851,6 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_kmemcache_fail);
 	debugfs_create_u64("reject_compress_fail", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_fail);
-	debugfs_create_u64("crypto_compress_fail", 0444,
-			   zswap_debugfs_root, &zswap_crypto_compress_fail);
 	debugfs_create_u64("reject_compress_poor", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("decompress_fail", 0444,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch

