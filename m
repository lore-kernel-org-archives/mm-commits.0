Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB3FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645188; cv=none; b=SlFXK8tFXZmMRDeRkXixXSZQqlVfa5TZpaRNlc7zUV2D7c1Ai63fdAAaImz1jmTvI8M9zM013CHXYE9rW+7CCatDj61taHVg3VVor7SUk0WWRcgoT+UiOVGh9qt+x/uO1ivOFTDsbGSMTEoZT6sS+5+hDt17mFwmWEKUJT+CxaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645188; c=relaxed/simple;
	bh=4vKyTTtMXXpP5EkCEQy54uuRKlctSDHBpwKfpE0+obI=;
	h=Date:To:From:Subject:Message-Id; b=lUAIihHGIRhTIbxtc36/KzM1y1mKn+IQTo8aNtAQVw9oovJ0Oq9otcmWP0B0Oe0yufrnzIVLflYtXejb9JO2JQChgjOK+mrCcVm2jnLA8fTp651K07xg6TzVuFpYv/SZAirDJho7jYu7COQ9CylsowIxHB+xWlojWNFmFIJoyTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcCPMTS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcCPMTS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0080AC43394;
	Thu, 22 Feb 2024 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645188;
	bh=4vKyTTtMXXpP5EkCEQy54uuRKlctSDHBpwKfpE0+obI=;
	h=Date:To:From:Subject:From;
	b=fcCPMTS8vmLMMXAs0L8mOEB7Gd+bvdCp+cRJCYTgYPxnobvGimKlr1hr0LG9mDFbm
	 +ypKHHkLXkTDK7qPkWx43udEFSkpKgmiuX3svnaQ5orGDbHXsCuo2+/YJEJVIQON5F
	 qjNvCW7w3LAva2Y1I0iwxRMioJjE8LpV786JkqcM=
Date: Thu, 22 Feb 2024 15:39:47 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-convert-segment-buffer-to-use-kmap_local.patch removed from -mm tree
Message-Id: <20240222233948.0080AC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert segment buffer to use kmap_local
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-segment-buffer-to-use-kmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert segment buffer to use kmap_local
Date: Mon, 22 Jan 2024 23:01:49 +0900

In the segment buffer code used for log writing, a CRC calculation routine
uses the deprecated kmap_atomic(), so convert it to use kmap_local.

Link: https://lkml.kernel.org/r/20240122140202.6950-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segbuf.c~nilfs2-convert-segment-buffer-to-use-kmap_local
+++ a/fs/nilfs2/segbuf.c
@@ -220,9 +220,9 @@ static void nilfs_segbuf_fill_in_data_cr
 		crc = crc32_le(crc, bh->b_data, bh->b_size);
 	}
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		kaddr = kmap_atomic(bh->b_page);
+		kaddr = kmap_local_page(bh->b_page);
 		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 	}
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


