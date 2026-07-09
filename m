Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF83B14BB
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637400; cv=none; b=ExAep13HVOQXI4r7Q+E3m8O1UTrgRpeb76FWhNPreUkCIcd6MuNfulCGiSUlzR9HxSWSGbdyKKl3+BS8pB2O7IjnqSDH38ccUkoyJvMEOt7TA2gsOgsp+KLfTGlVqD0oMYWpNc9OlgaCO9p4Hohr7+zLSum7ipHV3FmDjOvHne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637400; c=relaxed/simple;
	bh=+S31NpWysLLZi/ZpO8rKJWgudh/Y256l2SBkrVTNXWk=;
	h=Date:To:From:Subject:Message-Id; b=IaIEXepV1+me94lE6xkpQTR8TRNFwfk08MQqSDU/1HoR25xPcGi6kQin2myaT4yFXEcrYLoXR5PPr9U/B4dGYpp5MM5qSs5mlPcYstnv6KPZ+NHxpjaRsLWq+ryBBJdLAnMbkW2Y4UXTeRLy6djjYoWy1JWLAbmmrUKjZ+K0DKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W0HEMkGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W0HEMkGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2931F000E9;
	Thu,  9 Jul 2026 22:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637399;
	bh=UJugW6d4nz4kjixfM+MhQ2IztIdN7yfQzfC6/VvZA7s=;
	h=Date:To:From:Subject;
	b=W0HEMkGgN2dnKsGUl3/9/E6A4cUC11/ErZsWWYT3d6W8J6xSWO5PbcyXrqSjRPB6u
	 spHpaodkUcOV8SsAwoYqgg5CWaOJQr91gJdEy04qDAY2c6DFN1YwYeJEt4QP7y7Ibq
	 Y6VppAMNBLtSEVOrA1nwDIqwN1hA5agt02wW8Hqs=
Date: Thu, 09 Jul 2026 15:49:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-usama-as-a-thp-reviewer.patch removed from -mm tree
Message-Id: <20260709224959.6F2931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Usama as a THP reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-usama-as-a-thp-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Usama as a THP reviewer
Date: Thu, 2 Jul 2026 22:02:57 +0800

Usama has been active around THP, really enjoys working on THPs, and tries
to review all the patches that come in.

Let's invite him to the THP party as a reviewer to help with the ongoing
THP review load.

Link: https://lore.kernel.org/20260702140257.44780-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-usama-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -17255,6 +17255,7 @@ R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
 R:	Lance Yang <lance.yang@linux.dev>
+R:	Usama Arif <usama.arif@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are


