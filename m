Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F39215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188347; cv=none; b=bJQDFzBKPl57SPUWjA7WO1ExXII72CfIAnMpx13ehpr0yEHqHYGQOwaXOBY9wETzKEG+FNxcGv+xYBZk8lNroJU/kRMBIrqKOwxRw/PZKnAjuwXIXJ/4pWMvPVsvyxfGBF6jdNe1vk1Q6k8z85bEIqxQIJ4ZHSZ9W+JBKF6lSxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188347; c=relaxed/simple;
	bh=k7SKHp+orzP1ut+AhrrKQhjgC9zMbnlt3NKSImtEEVE=;
	h=Date:To:From:Subject:Message-Id; b=Aiz5A3YIT9D240yZz16qhq7J39fYdqP8twKPEgM8et/UwQ4vb6lQbgoHVVpFnUFg8hpxO3tSE2BsV6b50MA4eqTsFgDYIauzeY2xII3eRXtwUuQbHbBZDCEU7TghRvG3uCPPGOIw9HJS3zNArWSqIOxwe73v/IuKkdGvUlLYvwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sjOmoCCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sjOmoCCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DD6C4CEEC;
	Mon, 17 Mar 2025 05:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188347;
	bh=k7SKHp+orzP1ut+AhrrKQhjgC9zMbnlt3NKSImtEEVE=;
	h=Date:To:From:Subject:From;
	b=sjOmoCCE45ifcJ641/S2aZYwVDKV2V38b8cnv2omZKDpEt1SQTo0Ts41N9I3vDwNS
	 AAfIoNrSvIaCO1YDCEfJievJzIPRDTN0obWPEXhukIgwYtfIIDM7csgSbmVsSMtjSU
	 fiYNdqVJ+3nZkapKh79p0JOfmonQBgwj7+F/Owfc=
Date: Sun, 16 Mar 2025 22:12:26 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,suchitkarunakaran@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-fix-spelling-mistake.patch removed from -mm tree
Message-Id: <20250317051226.F2DD6C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/mm: fix spelling mistake
has been removed from the -mm tree.  Its filename was
     documentation-mm-fix-spelling-mistake.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suchit K <suchitkarunakaran@gmail.com>
Subject: Documentation/mm: fix spelling mistake
Date: Sat, 15 Feb 2025 22:30:42 +0530

The word watermark was misspelled as "watemark".

Link: https://lkml.kernel.org/r/CAO9wTFhe4sf1eVVgijt2cdLPPsUHBj7B=HN-380_JSpve5KbvQ@mail.gmail.com
Signed-off-by: Suchit <suchitkarunakaran@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/balance.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/balance.rst~documentation-mm-fix-spelling-mistake
+++ a/Documentation/mm/balance.rst
@@ -81,7 +81,7 @@ Page stealing from process memory and sh
 alleviate memory pressure on any zone in the page's node that has fallen below
 its watermark.
 
-watemark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
+watermark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
 are per-zone fields, used to determine when a zone needs to be balanced. When
 the number of pages falls below watermark[WMARK_MIN], the hysteric field
 low_on_memory gets set. This stays set till the number of free pages becomes
_

Patches currently in -mm which might be from suchitkarunakaran@gmail.com are


