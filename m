Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38454433AD
	for <mm-commits@vger.kernel.org>; Fri, 17 Jan 2025 02:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080821; cv=none; b=i3BIEKXsPyE96amcvC3/XtORiUjh0OsyGm77L8UzucNX36Z4OeJVZ0H+alyFa5oTHqwyJVqN2sAXa1zclblZO8DAudGxCJKoF9hybCZC6GM9ikS3+cKUbDr2er+LXsxoTWY/iIogmISR9qaaEL5MMBQ/PqXLvrMzzC/tjuSzzqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080821; c=relaxed/simple;
	bh=xd0LhuD3Mn+XCTJDo25MLP9qE/e1bbBrDNtV35nDxGc=;
	h=Date:To:From:Subject:Message-Id; b=LPDJvlQIurXOM7Wi4QHjtRVkIq/Kko4Hq7VjHz3YfZpbW35vYh0wFmPrBhhzUdWbmy2HmV9AQWHxGh4w75MwzmweKv/u5eEs4IFOGkTJrpEur3JtEXxIHy+1s+yaWkWwZM9DOBMisySvIhXnKmwUJeXOJRQZ+KqFcNEzj0jzrms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/bf3/gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/bf3/gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3550C4CED6;
	Fri, 17 Jan 2025 02:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737080820;
	bh=xd0LhuD3Mn+XCTJDo25MLP9qE/e1bbBrDNtV35nDxGc=;
	h=Date:To:From:Subject:From;
	b=E/bf3/gR1MnNB/S6WoSfGmWCBM8d29VtC/EcGzhO3Rh4mV9l+MKHntN9haj0MsvDo
	 S3rSTM4jq+0xuuA2MdkreFJK+2sNgeWVbsq2c7iKdkGS2qQQiAoechcm4HMgWezOu4
	 8/wdBwswVphHDdcI7vFgGpk12hBh8hPj8H/OncOk=
Date: Thu, 16 Jan 2025 18:27:00 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,jserv@ccns.ncku.edu.tw,corbet@lwn.net,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-mm-physical-memory-remove-zone_t.patch removed from -mm tree
Message-Id: <20250117022700.D3550C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: physical memory: Remove zone_t
has been removed from the -mm tree.  Its filename was
     docs-mm-physical-memory-remove-zone_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: docs/mm: physical memory: Remove zone_t
Date: Wed, 15 Jan 2025 15:03:55 +0800

"zone_t" doesn't exist in current code base anymore, remove the
description of it.

Link: https://lkml.kernel.org/r/20250115070355.41769-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/physical_memory.rst~docs-mm-physical-memory-remove-zone_t
+++ a/Documentation/mm/physical_memory.rst
@@ -33,7 +33,7 @@ The entire physical address space is par
 called zones which represent ranges within memory. These ranges are usually
 determined by architectural constraints for accessing the physical memory.
 The memory range within a node that corresponds to a particular zone is
-described by a ``struct zone``, typedeffed to ``zone_t``. Each zone has
+described by a ``struct zone``. Each zone has
 one of the types described below.
 
 * ``ZONE_DMA`` and ``ZONE_DMA32`` historically represented memory suitable for
_

Patches currently in -mm which might be from richard120310@gmail.com are


