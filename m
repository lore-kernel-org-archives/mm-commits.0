Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3DB1362
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 01:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750209371; cv=none; b=oRuUJnS7tEWbCPKjVFb8k0Rg1/1sMGzh1xgPgC4UMSCKkR2WY7keUJ9s8DX24QAX/Mz6Kma9Xr99oLSwWAg+D2mgnmVCHN1VXS9kUraq7xmjRV8GNCPTkay85B3HP7Qne3+DK/TtfI078saSFTqvulSKmtp6YgWUajlrcvJGZDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750209371; c=relaxed/simple;
	bh=FwDi/gWbuVkadYHdntlNG1q4HpKYwKshKujNB6kNIaI=;
	h=Date:To:From:Subject:Message-Id; b=qIaUaWtoOiwwBvLOIE1y9+AD/d2+yRotf/szS+t8UDtHUMcBP5lpQI5hoCEhzIjF6LjLduamMy1AWHMyTXBrSx0yAD8bWOksqD3G+bUb5xr7/xG2f7Fz6xfKtIH3jbzvcLPuSUYXd3AhCLSgWthUXSOAO6vsciynD36LBxLWtdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XD7cAKOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XD7cAKOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360E8C4CEE3;
	Wed, 18 Jun 2025 01:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750209371;
	bh=FwDi/gWbuVkadYHdntlNG1q4HpKYwKshKujNB6kNIaI=;
	h=Date:To:From:Subject:From;
	b=XD7cAKORw/8+PpvnAV7JuYZe9AfocDC2pSOhW5uGy+S5R67e7+U/73oJd4NKIV9eu
	 uKktAcVNSxKXTc0AD3xHa507NZm6c7spoaxcOhGkf4izsPsnlde5FlFmnICJ/X0w9J
	 mkA2CPCN6SPOOPHr4LmpvSjtL35Vp9DNT/rVF7O4=
Date: Tue, 17 Jun 2025 18:16:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch added to mm-hotfixes-unstable branch
Message-Id: <20250618011611.360E8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
Date: Tue Jun 17 06:15:31 PM PDT 2025

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#32: FILE: MAINTAINERS:15860:
 F:	mm/oom_kill.c
+F:	include/linux/oom.h

Cc: David Rientjes <rientjes@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
+++ a/MAINTAINERS
@@ -15856,10 +15856,10 @@ R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	mm/oom_kill.c
 F:	include/linux/oom.h
 F:	include/trace/events/oom.h
 F:	include/uapi/linux/oom.h
+F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch

