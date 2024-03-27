Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7278D12E1F1
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561038; cv=none; b=bUmGZN20F1RbOzTtK7zMElEWB23YlpAKd4k60PRGWUBdtuwJvo9xbkpzDSd0kvShtzPp4LHmaNxSuigvsezh/4D32hylwzOM070IbUssz74yLfunOjHKYuTvAg+UCjwE6DvDPUa8A0jDl0G1MN1VN4yk8Pl8dNEIbZuWJTs2fyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561038; c=relaxed/simple;
	bh=9/spQg40u+/P+AnxBXbkZWaI+8JJwp6BiN0quPFgVq0=;
	h=Date:To:From:Subject:Message-Id; b=r1wdDBoW4mu4uokSFtvTXogVq4+UbJlH7nAJTQWYN7i9lcETLfpQkliz+LHXTx1/y+CCkfCObwM6yoowImaCDYMrXoEJQyxJntTM91Pg16qepDtlv61UzLGRgbdUaNzgeRDckztWzte1uMaAb+OSCos2SiwWvc85mMWhPeeQhhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PByhYrkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PByhYrkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD18DC433C7;
	Wed, 27 Mar 2024 17:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711561037;
	bh=9/spQg40u+/P+AnxBXbkZWaI+8JJwp6BiN0quPFgVq0=;
	h=Date:To:From:Subject:From;
	b=PByhYrkvQF5i6z9B5Eqr3gpjGHU6Kq/1kYOfza72vuhL1ib9KpIlHO+Ir4db0+7Wm
	 aWV4fsfRFGE/Oa6uUvX13VmKDpCKjyGKfxhUs5mapv4SAE8WML5ffTMjaUGFbqkkxp
	 qhvBouoti9bHZLikI7o7HlDs5HgIVJDUa2kmQVEc=
Date: Wed, 27 Mar 2024 10:37:17 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch added to mm-unstable branch
Message-Id: <20240327173717.DD18DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
Date: Wed Mar 27 10:36:28 AM PDT 2024

remove unused local

Cc: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix
+++ a/mm/page_alloc.c
@@ -5285,7 +5285,7 @@ static void setup_min_slab_ratio(void);
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int node, local_node;
+	int local_node;
 	struct zoneref *zonerefs;
 	int nr_zones;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-fix.patch

