Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA41EEE6
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538240; cv=none; b=p9/Wz8VnPIAf3aMGDMRCU/60nJL3TC7U9gfWirePf3lDhjpKqEoPFFmTC6VKXj5oZIMs1R5DgeLKt2JN9p7svrgR0H/VVzyWreIkV+RJRfitZTDNmcmp/hNAIqCbk5idNlvxVYMGR0qKRKAjge/fA4IlcC14zPjy1WyohN07rq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538240; c=relaxed/simple;
	bh=fIZtsRPgYF45/iMNRJgyWREHL73Gn4SlhOiVEJmA19k=;
	h=Date:To:From:Subject:Message-Id; b=qyNUzu23qbHwIKYi71oJWyACTyTnwOdQCwJdElK/DSmKguylFV+uaf07Ly5e3PRd+9IptGtN5sRM3ykf1VtQ6QBdBDYb2EJvA33JSZBObES/8UHdSLJxWEhYgFGCgz7JuMEiwetLA9D8DR9HRruWPq6wrk8V+SC7iC5m/1lctrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbsIdUmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbsIdUmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C911C4CEF7;
	Sun,  8 Feb 2026 08:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538240;
	bh=fIZtsRPgYF45/iMNRJgyWREHL73Gn4SlhOiVEJmA19k=;
	h=Date:To:From:Subject:From;
	b=vbsIdUmnbO6vhZ6ehC4ZzFVdLo85CdOG6V8QXSHVdY/iBU5PJ2wO2UsVmbP2zCuF+
	 ykPzACJIj2k3eD/b26PZLwm/nV4PmzVMiI/AJoIwVT6MTfCI4C4DifNXky3tO66eiU
	 1+ewoW5LSkNJCVHCZqbkCIZJSdbjZGtsjTzffPKY=
Date: Sun, 08 Feb 2026 00:10:39 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,david@kernel.org,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch removed from -mm tree
Message-Id: <20260208081040.5C911C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
has been removed from the -mm tree.  Its filename was
     mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3.patch

This patch was dropped because it was folded into mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
Date: Fri, 6 Feb 2026 14:38:01 -0800

remove unneeded cast, per David

Link: https://lkml.kernel.org/r/20260206223801.2617497-1-ankur.a.arora@oracle.com
Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-folio_zero_user-open-code-range-computation-in-folio_zero_user-v3
+++ a/mm/memory.c
@@ -7340,7 +7340,7 @@ void folio_zero_user(struct folio *folio
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
-			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
+			clear_contig_highpages(page, addr, nr_pages);
 	}
 }
 
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-folio_zero_user-open-code-range-computation-in-folio_zero_user.patch

