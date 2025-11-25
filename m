Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D5F1F30A9
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090258; cv=none; b=ByAFViBQPIOxR7r5rMFQxf4dvvgTQgF9soDD+2E4tYziavQLfoLbHAEuVU2YVLcKqgFapwniloXI+jxSWTPBnyXyx4aW//8zOZWWxV221DzHe1mkTVYHd/gQG0g0rZBbvXl91GN9F4kp1TnTX23FgpVT8G339UcqKgBst2ufZnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090258; c=relaxed/simple;
	bh=DYNfu6TMSP4vsZLomevrnpRduUTTeuEYVrLl2gq5qoI=;
	h=Date:To:From:Subject:Message-Id; b=BpP2CB26j5QVfYJwxszxESlvwxOARedOv+mD+vub9r9r30c4uHjKIj2vsP277a7cz/661n4qGx4haPOnFH2AqGRB7lZKat/FHwaAl32WkJUmHLSrpltDYGiTvbhWcDfqfUCuBS2jY1H0zEv+dnuLnyinXT2xMKFIAFIhBADdeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HyKLaKgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HyKLaKgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DADC4CEF1;
	Tue, 25 Nov 2025 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764090257;
	bh=DYNfu6TMSP4vsZLomevrnpRduUTTeuEYVrLl2gq5qoI=;
	h=Date:To:From:Subject:From;
	b=HyKLaKgpMK7W9fNhAzkcTVZaUhPWTSs++bCbm/QJTJZEMuXuMw8/VkoOheVc1R1KI
	 tZMGagHC+JJJNliF6TsfPlyNyxn9dcyuhC84PIL+kVD0ttnTdNSEU3zVfqqNZXWo4R
	 zaA/8OxkAzO6BXZeyMDSiooNC+qiu3szZy2Qd6TQ=
Date: Tue, 25 Nov 2025 09:04:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch added to mm-hotfixes-unstable branch
Message-Id: <20251125170417.30DADC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd
Date: Tue, 25 Nov 2025 15:29:08 +0200

Link: https://lkml.kernel.org/r/20251125132908.847055-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd
+++ a/MAINTAINERS
@@ -16547,6 +16547,7 @@ F:	tools/testing/selftests/mm/transhuge-
 
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch
kho-drop-notifiers.patch

