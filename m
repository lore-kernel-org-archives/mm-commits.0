Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3621CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567847; cv=none; b=GbtjPW9ZSwA5gwCqulTdmymaLfOzvjlsprzUmMM0xU7Ts0efvBlibJEA/lm7ReRVIPIbV5FkqT1CHUTR6l8p+GaK1M2uagY6d8VQew2EjlrFRaw9hDsnMEpstIlnuls+Bhuq4VEE1koI6KOxCqArJy1rE4RA1p8RB6flXCCmEdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567847; c=relaxed/simple;
	bh=9hVzvzsXl0kDDCkClRy6Zl5yX4luagyJZ7obR3LinMs=;
	h=Date:To:From:Subject:Message-Id; b=uBm0lMsuoVLVO2YdYsCapmawFabtn8gZtA65IMoqpuv+swX3mEWPhv9LgYsZxwDU22GG3j737hfNmWfs7qYY5aSu2LD+7tWmMLnNv04DIDFzRPGP2U4oTKqLsCA2CxCd79elyXd57XiWJLitbtpmjPUEogiZUVRIFG/c5aw/kLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dzsNUDea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dzsNUDea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FEAC4CEED;
	Sat, 26 Jul 2025 22:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567846;
	bh=9hVzvzsXl0kDDCkClRy6Zl5yX4luagyJZ7obR3LinMs=;
	h=Date:To:From:Subject:From;
	b=dzsNUDeaN/ZsAZfnJYqt6gLVr4nBlv0HCSxjRdPyPlV0+sCyMmP8ah2ww+agr/3st
	 mxEsnH8c/Qu2tdsmINxGFiVrO5xe+qfFqaxDlHjRLV9uQPp0TBVH2mH3M3jBpwMosL
	 QzAAdXlgHPg/ln45fBqyKBASbC3UlPh5ZuiycCv0=
Date: Sat, 26 Jul 2025 15:10:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-zsmalloc-file.patch removed from -mm tree
Message-Id: <20250726221046.B0FEAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing zsmalloc file
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-zsmalloc-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing zsmalloc file
Date: Tue, 22 Jul 2025 19:18:27 +0100

The mm/zpdesc.h file is only included by mm/zsmalloc.c so the zsmalloc
section seems the most appropriate place for this file.

Link: https://lkml.kernel.org/r/20250722181827.156035-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-zsmalloc-file
+++ a/MAINTAINERS
@@ -27465,6 +27465,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/zsmalloc.rst
 F:	include/linux/zsmalloc.h
+F:	mm/zpdesc.h
 F:	mm/zsmalloc.c
 
 ZSTD
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

