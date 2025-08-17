Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EC920485B
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456884; cv=none; b=tyE9HVV68naOOaSLEcECjqUmmMV4Xg4CFllVrP1vyXZNYXQUxQn7oONNs+M39wlaAcX5PWIUE9dSgiBFyiZBJuSixFHZt7gfTJ7mXtr8ReiG84+i7gcYZORj8YAP4H7tFjTqFafsEUPp36lAfeSprOU1yQD2DGcamgR/1klSEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456884; c=relaxed/simple;
	bh=7vkk2xk63KDKokgxYSmaNhzpUj8Duy/9hO3Qapqh4fc=;
	h=Date:To:From:Subject:Message-Id; b=Z/0Sn9Iv46LWzhTp9QS3Jdq7vtIrBabx1CN1+QBPAQvnnrFzBwGcAlTTjakOr9MTKGrOT0gJ7OHmIwsvaJVh+qfZSbmm6ihJzNCT6+ecIQ+vzdLqLufthrYdTStuFjjUyQTVPM3ZHrfMC0lqqwz0M6mfUUD0rg85w9Ozr5+BP6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7OSmBZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7OSmBZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B778C4CEEB;
	Sun, 17 Aug 2025 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456883;
	bh=7vkk2xk63KDKokgxYSmaNhzpUj8Duy/9hO3Qapqh4fc=;
	h=Date:To:From:Subject:From;
	b=U7OSmBZo8ZYBCzWqFtJPxGF6I7xTO/6WyHO8hJgJ0vAcyeVHLMCWm9yvV50s+zcG3
	 Erpyjmcm+YU2K87tTf2UBbRkxbsOdMJvvXsg3cIe97BSLcstTGuB3tSlMMrQvxWE1w
	 qt9d+MC1J6IiKBsfqPbbK5cqY9+J8Umw97C2TVAA=
Date: Sun, 17 Aug 2025 11:54:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slab-use-memdesc_nid.patch added to mm-new branch
Message-Id: <20250817185443.6B778C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slab: use memdesc_nid()
has been added to the -mm mm-new branch.  Its filename is
     slab-use-memdesc_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slab-use-memdesc_nid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slab: use memdesc_nid()
Date: Tue, 5 Aug 2025 18:22:56 +0100

We no longer need to convert from slab to folio to get the nid, we can ask
memdesc_nid() for the nid directly.

Link: https://lkml.kernel.org/r/20250805172307.1302730-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab.h~slab-use-memdesc_nid
+++ a/mm/slab.h
@@ -174,12 +174,12 @@ static inline void *slab_address(const s
 
 static inline int slab_nid(const struct slab *slab)
 {
-	return folio_nid(slab_folio(slab));
+	return memdesc_nid(slab->flags);
 }
 
 static inline pg_data_t *slab_pgdat(const struct slab *slab)
 {
-	return folio_pgdat(slab_folio(slab));
+	return NODE_DATA(slab_nid(slab));
 }
 
 static inline struct slab *virt_to_slab(const void *addr)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch

