Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B431B85D3;
	Thu,  2 Jan 2025 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735855838; cv=none; b=n9Ylljtci8N1VJOwOg7WjZTYdvR5ikrWNFQSbW/viI0uO2fXW0v6XJAwdpvgcvQ50FrzPJcySDTqNyY1JHWG5gQTD6eAgo5GtmtCQdBsziwIv3b2EYkk3su+QHnot/ZL/beIRMP/SwZvnxrqx1ox4s/rHcwaMukPhRW4nOeuPOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735855838; c=relaxed/simple;
	bh=u77SrFDG2FUwtHUkecETXYGCZ8vA8MhoTEj0emRtF78=;
	h=Date:To:From:Subject:Message-Id; b=TvTea0JLHjZvtAkPX2Zzo5QDgmkp//4Qdy8BsXcTImdR+v5vBQfZRUnv2rq+mQKUl0AlRZNFMPYQE0pZkfcN6K1P78byrU3p1h5F6yXFONI5l4TAAxcK26kaGj0D31MSP8x8aKmvQwvkedzkod4Wl2g5SQxMl1k2M+nfqTRe/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gH/ulqOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gH/ulqOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE4CC4CED0;
	Thu,  2 Jan 2025 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735855838;
	bh=u77SrFDG2FUwtHUkecETXYGCZ8vA8MhoTEj0emRtF78=;
	h=Date:To:From:Subject:From;
	b=gH/ulqOaoaYVCDBWzx9LzXc7p3k/dqwERtvGJxPOcp2Cua8BxYEcaNTBekaXduSaI
	 sNSkPwURH1M7HUHL2UevGe9DIqh5hh3QMV/BP0/bNxlowANY4uA9pdN04LmBzzeU5S
	 P7tu67ns/dBSIzqX3/iFoib9MhxrBtR+sKjn4Vn8=
Date: Thu, 02 Jan 2025 14:10:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,marco.nelissen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-avoid-truncating-64-bit-offset-to-32-bits.patch added to mm-hotfixes-unstable branch
Message-Id: <20250102221038.2CE4CC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: avoid truncating 64-bit offset to 32 bits
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     filemap-avoid-truncating-64-bit-offset-to-32-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-avoid-truncating-64-bit-offset-to-32-bits.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Marco Nelissen <marco.nelissen@gmail.com>
Subject: filemap: avoid truncating 64-bit offset to 32 bits
Date: Thu, 2 Jan 2025 11:04:11 -0800

On 32-bit kernels, folio_seek_hole_data() was inadvertently truncating a
64-bit value to 32 bits, leading to a possible infinite loop when writing
to an xfs filesystem.

Link: https://lkml.kernel.org/r/20250102190540.1356838-1-marco.nelissen@gmail.com
Fixes: 54fa39ac2e00b ("iomap: use mapping_seek_hole_data")
Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-avoid-truncating-64-bit-offset-to-32-bits
+++ a/mm/filemap.c
@@ -2996,7 +2996,7 @@ static inline loff_t folio_seek_hole_dat
 		if (ops->is_partially_uptodate(folio, offset, bsz) ==
 							seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < folio_size(folio));
 unlock:
_

Patches currently in -mm which might be from marco.nelissen@gmail.com are

filemap-avoid-truncating-64-bit-offset-to-32-bits.patch

