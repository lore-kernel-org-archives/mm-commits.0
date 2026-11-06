Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926594;
	b=UcmEs+rKgk3Yyi0hBy+doPxjNaLacx/x295+8jaJu6ITBCAxWXCQn2DiUv5+VZRerRpO
	 beQR7WuI0xzcw2ZaJiZzL6sNeXCYuiagtHOnKtwYBoOcBW7CvHzT6jFtvuHOQYAjfO/xZ
	 9vdFVwKSIaPJp6F2pwisycEFZcynW4cZMsft2pZCca9XHScjiDJbBFRpZTZhg6n26HBSo
	 wv/+gojkDarIt6t+6+R91F68sZ9bNSDbnhXtOfhUa0KpEG7zHPt5Mm3D78XLBHjqPcdfW
	 V6AZ2DegGBI5YXzGLCJC6P3VNf19NjU3PNbYtoT2WmRyx9Z0i5WmfLcGjKY/ftGJLxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926594;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EKWa2TMCCz3OL2O52vHTa8wSAka2bAVG/T551beGLN8=;
	b=bGxw209QrjpmIFTXbrh2duk9STkoZD4xYuc9GPrELc6+6SXJxobiOybO/yvE+CCz4GfP
	 9sCJ+gzR6K36fykYETco1BGpQSSEkJateE3TzoNNm2NIZUbrKWQQefM9psByEp56FgFz5
	 HHmM1OFNxj0L9wm7Iy4h4r/CD2AfTGir0FTJmYaSnwODUanM+yFjOGZU25B59OOAfjeC1
	 5hudCiO4yv4Bdwcs2s0pncJIwUzY2IdIZSf/O9apITAjQ4ZaSuFVcA2WUlJB+O1p28VmL
	 2EuDoBlHpwNHzbuFI2samiG9UWX4bb5S4GBfW0/T+7C1yBDw3t11t1wGL5sSgZBuDcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YU66+k4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB012606A31B;
	Fri,  6 Nov 2026 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YU66+k4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3751F0089F;
	Fri,  6 Nov 2026 00:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793926593;
	bh=EKWa2TMCCz3OL2O52vHTa8wSAka2bAVG/T551beGLN8=;
	h=Date:To:From:Subject;
	b=YU66+k4V46VecmFCwH4NCQ95aNoWN3uvElLN0CtUNsx3lpdCozltn+ES12KfTil4I
	 dOKb3C0MRTDc13Fln15fo2qej3efoCIj2daJmMWFLGr17VAB5P7y5JHTbLFP8LtbYW
	 hC6St9A1KClRVMcQ2FU8lnnC3GdQOkNGkpkpUO/I=
Date: Thu, 05 Nov 2026 16:56:32 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,
	usama.arif@linux.dev,stable@vger.kernel.org,ryan.roberts@arm.com,
	nico.pache@linux.dev,mason@kernel.org,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch added to mm-hotfixes-unstable branch
Message-Id: <20261106005633.2F3751F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
Date: Thu, 05 Nov 2026 19:16:44 +0100

madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
uptodate.  For example, shmem fallocate() can put such folios into the
page cache.

collapse_file() already refuses to proceed with folios that are not
uptodate.  Let's just do the same in try_collapse_pte_mapped_thp() and
skip such folios, leaving handling to the page faults.

Note that collapse_file() effectively clears shmem folios through
shmem_get_folio(); let's keep this fix simple and simply let the page
fault path deal with that.

Link: https://lore.kernel.org/20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse
+++ a/mm/khugepaged.c
@@ -1888,6 +1888,12 @@ static enum scan_result try_collapse_pte
 		goto drop_folio;
 	}
 
+	/* Leave any uninitialized folios to the page fault path. */
+	if (!folio_test_uptodate(folio)) {
+		result = SCAN_FAIL;
+		goto drop_folio;
+	}
+
 	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	switch (result) {
 	case SCAN_SUCCEED:
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch

