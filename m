Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138004A3F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714170069; cv=none; b=kDb5uPBxEAFUBxcWwqephYIqKSyFmK0xAdLNcNYcibUh11Znz8YecmTz9tiRRf9Va+oJxJjO7Aqw3fKZXP6Xq5hOB8o2tM2f6Qox3GbOYujqh2q7Zh1WaPVfMrWSghSlxIjuiCVktJFsa4+Y3g1R9pVPz/kSBYo31L1qoED9SS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714170069; c=relaxed/simple;
	bh=hpheE2WW6n+0jIDIRJKEQcNHzRc042YcZULzcvPdLFM=;
	h=Date:To:From:Subject:Message-Id; b=hZ/BV8Hh/3oSrSiVQmtyN7Qp1xC2TaiG43Zs4BEx57iafAPAEk7EixHke8svepOBhgpTP9APq3LjQ5Sa0SqMthtVwbNVWN/hc+YDbiFztJu1WgGtgxzKIlwg/tWNfUjzJgzXUPaOcfY4pBP/F5Tuuyuldr9Umn8CokUlQpyOg8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j2WiC/9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j2WiC/9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89EC113CD;
	Fri, 26 Apr 2024 22:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714170069;
	bh=hpheE2WW6n+0jIDIRJKEQcNHzRc042YcZULzcvPdLFM=;
	h=Date:To:From:Subject:From;
	b=j2WiC/9rjg2wurDWLwPwzN+rgL9PT1ZzcSRGjKD9hiNNtKraerBqHQmq69zfgNR0c
	 fjfIIPFSuTXX32RbV6JfSLIy6/Ux19AowYhZRTHa8kjwDk9nvJDJ0vZX3mU2SsGwnO
	 /aCTBKJr5k8TBag0fj/OgUiZSkTcLbNvLtgRFThw=
Date: Fri, 26 Apr 2024 15:21:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,21cnbao@gmail.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix.patch added to mm-unstable branch
Message-Id: <20240426222108.DC89EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix
Date: Fri, 26 Apr 2024 15:20:42 -0400

simplify boolean expression, per David

Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix
+++ a/mm/rmap.c
@@ -1516,7 +1516,7 @@ static __always_inline void __folio_remo
 			}
 		} while (page++, --nr_pages > 0);
 
-		partially_mapped = !!nr && !!atomic_read(mapped);
+		partially_mapped = nr && atomic_read(mapped);
 		break;
 	case RMAP_LEVEL_PMD:
 		atomic_dec(&folio->_large_mapcount);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list.patch
mm-rmap-do-not-add-fully-unmapped-large-folio-to-deferred-split-list-fix.patch

