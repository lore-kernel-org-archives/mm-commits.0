Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C03202963
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761452606; cv=none; b=OEXZrlJKl39CfWhG88WRR5BbPhj4x82HTrjp68mOEpQ0Q4xDcywI17AGyJlj6e4sS0ho16YrYzX1u1nKZiZIcjghJ1mT6AFHksbhxGWQU/zi+H8wBShnlk3kOZoJzIHS9LLRjSLJJKtZgNssj33yScTKiVQV3nGfChGzGTg03Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761452606; c=relaxed/simple;
	bh=97qmtDGSrVxrOC2BxAcQ5nCn10mOnDqKGQLqs8RgXt0=;
	h=Date:To:From:Subject:Message-Id; b=sBkLe/p03aBKBCZ+TYH5s64bpyykfAR/THFUmnc0KDI/21UG1dPHhI1AQcDg9UMyBJE99ThFGsdGnLZ2DxwxrHmaCct5PBeiXwhPB6Zl9LzszZDAEv7CVrAHNwso7uwJNITepP/vqGOPNiK7Iabs28SgSFg8s/KsOraK5y1sgpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KarORtji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KarORtji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C508DC4CEE7;
	Sun, 26 Oct 2025 04:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761452605;
	bh=97qmtDGSrVxrOC2BxAcQ5nCn10mOnDqKGQLqs8RgXt0=;
	h=Date:To:From:Subject:From;
	b=KarORtji5mrFjJ9g62wDov+rZPKjHQA7wVuGQ1Xmw+x4qZ0oc9r4OY0DME0LoEgPA
	 YxogcxrEekjPa/IkMGeRJkIa+eaebtCfHzYecdU/pVGX40S6diTrMD7ZhKgAxGYDU2
	 DQi7uZkwAuYqnP09HUypVCJojxMes6weCM1tahxI=
Date: Sat, 25 Oct 2025 21:23:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-include-linux-pgalloch-to-mm-core-section.patch added to mm-new branch
Message-Id: <20251026042325.C508DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-include-linux-pgalloch-to-mm-core-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-include-linux-pgalloch-to-mm-core-section.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Harry Yoo <harry.yoo@oracle.com>
Subject: MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
Date: Fri, 24 Oct 2025 20:30:46 +0900

Patch series "mm: MISC follow-up patches for linux/pgalloc.h", v2.

This is a follow-up patch series for the patch series named: "[PATCH V5
mm-hotfixes 0/3] mm, x86: fix crash due to missing page table sync and
make it harder to miss".


This patch (of 2):

Since include/linux/pgtable.h is already listed in the MM CORE section,
add it to the section as well to keep it maintained by the appropriate
maintainers.

Link: https://lkml.kernel.org/r/20251024113047.119058-1-harry.yoo@oracle.com
Link: https://lkml.kernel.org/r/20251024113047.119058-2-harry.yoo@oracle.com
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-include-linux-pgalloch-to-mm-core-section
+++ a/MAINTAINERS
@@ -16248,6 +16248,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

maintainers-add-include-linux-pgalloch-to-mm-core-section.patch
treewide-include-linux-pgalloch-instead-of-asm-pgalloch.patch

