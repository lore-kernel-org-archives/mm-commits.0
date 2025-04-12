Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0CDE56A
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417776; cv=none; b=AuoSa8hKgko8tgS4Z/w5CO8VuCE8eE910sJOPKy+WzadYsz5KFzxVrkhudXrHSWcndAUKVUm/3im5VCbTCauXMl0A+MuYUL5+KsOboZtBGfnqHrcj6Za9kDvIFskVvgyI8IOivOrp8LNehkKlsVa1pK1CnJEXm5hsYKhj4dLaZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417776; c=relaxed/simple;
	bh=Iwmea6XYCuUdg+PmgnF+n1UORJkr/7U8wO0VP3dFqLw=;
	h=Date:To:From:Subject:Message-Id; b=WpjAuB0GXXTpDXEPRd9tMyLmSDC4MxVDtd7dQzRp8cvzz98BwyVw1rlgWbicbwBGIc3JPWVZPVizN+0Fw2x1GWnalSLypQA7kB7J0Z1j3a3FH1Z7w3caUI8v19nNuERiDkjn3csuRF/QRvu7qqB4fCXyeGqYsLeUaYLbEOnLR9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j7sj9XvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j7sj9XvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B150C4CEE2;
	Sat, 12 Apr 2025 00:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417775;
	bh=Iwmea6XYCuUdg+PmgnF+n1UORJkr/7U8wO0VP3dFqLw=;
	h=Date:To:From:Subject:From;
	b=j7sj9XvG00cciqLe78vcUBRoIfvCIupXelV8uaRWGxwTeQbkfjkISENm9HL6mrmVa
	 tliQPB6TEnAFgQtlpx6+R43mMqFCr+JYTkp1/hhOUuZX/5f3O2YgskyNMrWN6SNeA0
	 ImNsBcW6763HNAXvDHh3Bz2ctPUphzQiaV/Jj7U4=
Date: Fri, 11 Apr 2025 17:29:34 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,geert@linux-m68k.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-cma-report-base-address-of-single-range-correctly-v2.patch removed from -mm tree
Message-Id: <20250412002935.7B150C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-cma-report-base-address-of-single-range-correctly-v2
has been removed from the -mm tree.  Its filename was
     mm-cma-report-base-address-of-single-range-correctly-v2.patch

This patch was dropped because it was folded into mm-cma-report-base-address-of-single-range-correctly.patch

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm-cma-report-base-address-of-single-range-correctly-v2
Date: Tue, 8 Apr 2025 16:40:00 +0000

Link: https://lkml.kernel.org/r/20250408164000.3215690-1-fvdl@google.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdVWviQ7O9yBFE3f=ev0eVb1CnsQvR6SKtEROBbM6z7g3w@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/cma.c~mm-cma-report-base-address-of-single-range-correctly-v2
+++ a/mm/cma.c
@@ -722,14 +722,15 @@ static int __init __cma_declare_contiguo
 	}
 
 	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
-	if (ret)
+	if (ret) {
 		memblock_phys_free(base, size);
-	else {
-		(*res_cma)->nid = nid;
-		*basep = base;
+		return ret;
 	}
 
-	return ret;
+	(*res_cma)->nid = nid;
+	*basep = base;
+
+	return 0;
 }
 
 static void cma_debug_show_areas(struct cma *cma)
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-report-base-address-of-single-range-correctly.patch
mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

