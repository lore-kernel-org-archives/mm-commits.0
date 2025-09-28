Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331D219F40B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085302; cv=none; b=cX7KO6A3H/or0iw/+fOJe5JP63IRSRI70pA/RRRRxObxrY6n+h6BKhq5/PdEpfzhK2ArKN0iw9MPBRjnOEqeSD/kSRCJwuoutApjv45d7JcFNUy03iVzoQbPNQNypC1T3to/ItU5wdvQrqEqQppLiCmL8o2sBWvipl7CdwkyT90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085302; c=relaxed/simple;
	bh=NfyV/pu+zy4HwPVvMG9Z9/pTqHfgTOLVvJP2AvVmM44=;
	h=Date:To:From:Subject:Message-Id; b=ZwMwJZCG2WMhjfGEpaO0yDP1hPbWC2mHRVIEdrtDGkOsxy8SOaz8dmRFk6AO1Z7H2r58jHaMhqFCVip1MDQMRlECpT1y9HPTapiF5jkkEOA4D2BfV7V/qKD2x03VIfqQQLnIde1/ROju5ooXmMi0H6J6OL++0JT5jq6UIg/C/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e3RFgWD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e3RFgWD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B17C4CEF0;
	Sun, 28 Sep 2025 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085300;
	bh=NfyV/pu+zy4HwPVvMG9Z9/pTqHfgTOLVvJP2AvVmM44=;
	h=Date:To:From:Subject:From;
	b=e3RFgWD7YYI7397Ua1kRnZJsZtuIGun7FddTf5UllzTPgLKvp9nt5DLLFheHunIPw
	 Zn/Hvo8u+Mj3nqSAlLqUNW2hhn0JZrOxlt2XWh+cbTt8juseGvA+I9QYOAwbgP5eKy
	 7bryF7jWExZZ7ho8Zk3qkmGjNXPBkEE3tGHFicWg=
Date: Sun, 28 Sep 2025 11:48:20 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch removed from -mm tree
Message-Id: <20250928184820.A4B17C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch

This patch was dropped because it was folded into mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix
Date: Tue Sep 23 02:28:21 PM PDT 2025

s/CROSSSED/CROSSED/

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix
+++ a/mm/rmap.c
@@ -870,7 +870,7 @@ static bool folio_referenced_one(struct
 			 * If page table boundary has been cross, current ptl
 			 * only protect part of ptes.
 			 */
-			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+			if (pvmw.flags & PVMW_PGTABLE_CROSSED)
 				continue;
 
 			/* Restore the mlock which got missed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

