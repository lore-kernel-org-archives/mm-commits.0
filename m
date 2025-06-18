Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D01F510
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206709; cv=none; b=pv/1TPy4js5K+qjsampey4PTZCLuYR9/W7oUvv1Tk9EKMFRtAJOKd7mIb0Lpvwr9/HNcCf3uhTykptjIkCK1oYROEKlH6vN5BB5GusCJlHPAf+yvvQuRgL0h+3zOwmo7TL68xDURUS7n+pyKdpXuMCFCLyJl31buR8otViBfEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206709; c=relaxed/simple;
	bh=nPlSKnG9Y5aj0Wq+ElYS6T1mwaIRiNbBiVpkdSLvmFE=;
	h=Date:To:From:Subject:Message-Id; b=Nw7dfo0XhjLrNje6fb7K5HFfnwVt+bezzKR5UpwQO0ATpUvriyXAqCAywapIwy1Pf7t65DGBhaBxlmS5MyEHU7y3txSdeCoBcNjlkDJOBoM4iMWe/JZI9sF06bXL+rM/mpcYRbaZdxDBFNWQNfaeNEzMI9/V22QXGCgHts3S3J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u+nPqIzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u+nPqIzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52386C4CEE3;
	Wed, 18 Jun 2025 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750206709;
	bh=nPlSKnG9Y5aj0Wq+ElYS6T1mwaIRiNbBiVpkdSLvmFE=;
	h=Date:To:From:Subject:From;
	b=u+nPqIzXtC5B2WeyHobvirrrHst6WqQgEfqt6aCgADWhNn7hs4VBjvZ87X0mAWnx6
	 iRkEY8fxV+gHsW/3J1o4e2vokxZ4z7Gx6SLHN8scAHph1VYnPX/P+77wlXjOCLdaUu
	 1dwobgKpNYRBDmbv+g7d2tkAzLBhdqz2Mz/ht9s4=
Date: Tue, 17 Jun 2025 17:31:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-oom-killer-maintainer-structure-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250618003149.52386C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-oom-killer-maintainer-structure-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-oom-killer-maintainer-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-oom-killer-maintainer-structure-fix.patch

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
Subject: mm-add-oom-killer-maintainer-structure-fix
Date: Tue Jun 17 05:26:51 PM PDT 2025

fix mhocko email address (SeongJae), add files (Lorenzo)

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure-fix
+++ a/MAINTAINERS
@@ -15851,12 +15851,15 @@ F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
 MEMORY MANAGEMENT - OOM KILLER
-M:	Michal Hocko <mhocko@suse.com
+M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/oom_kill.c
+F:	include/linux/oom.h
+F:	include/trace/events/oom.h
+F:	include/uapi/linux/oom.h
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch

