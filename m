Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37C6391518
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489376; cv=none; b=HXmqpo4J92oDqRS7DFvr9g4jTksruKUOHHVdm0WGzkR5eUsenFxtGAMqqTYi9DgLP19rMYp6sYzRGcEPnnUesRedh151uJ5jMr5tUYtvK6BURrMSgDc4HT/VhcIEU0q4nXyJFvtKo5PrBwx6T1/Mhj5wioG4GA7eyBEKbttyuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489376; c=relaxed/simple;
	bh=IWSErgLBF5+GwAEkVrtYFfCk3wB3l4p+ISwgMEvka/4=;
	h=Date:To:From:Subject:Message-Id; b=Z2WBKUI26IoK7z0ANbSFRwwHbcTCxnjbh3AQY7zkH20wX3l7PB/tWDJRSchuiTbxwcAqVPnXpY9SkZ95ClzfgLGCanZysKBY13mXtTMqIhmld33IqR6emzCzkxsT6zDGQJofS1W9clhDKEhuMYrD2D1RCo8og2iVTD1EnucyDvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mvGnOI33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mvGnOI33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F7FC2BCB1;
	Thu, 26 Mar 2026 01:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774489375;
	bh=IWSErgLBF5+GwAEkVrtYFfCk3wB3l4p+ISwgMEvka/4=;
	h=Date:To:From:Subject:From;
	b=mvGnOI33n/8lq2HM8j15MV2Y/eLC+SVdDuaVEy90XxuYO+cDjX2OGBEEKjJ1K2hT1
	 a8NxCpLGNBDD8hAHI47ncRLtKhBgj3APCtIBXVo2pTkWYI8Pum3xvcYqmbOovbY9hI
	 RPTusp1pWNyO+Nk7tqjl6TaIJWDSCjigSX9euBqc=
Date: Wed, 25 Mar 2026 18:42:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,adam.bratschikaye@dfinity.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch removed from -mm tree
Message-Id: <20260326014255.87F7FC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix.patch

This patch was dropped because it was folded into selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
Date: Fri, 20 Mar 2026 13:56:04 -0400

update .gitignore, per Lorenzo

Link: https://lkml.kernel.org/r/D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org
Cc: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Bas van Dijk <bas@dfinity.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -61,3 +61,4 @@ guard-regions
 merge
 prctl_thp_disable
 rmap
+folio_split_race_test
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-add-folio_split-and-filemap_get_entry-race-test.patch
selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix-2.patch

