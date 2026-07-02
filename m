Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEABB3CFF4C
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783032013; cv=none; b=M70aHBhhs/OguNVmNOJMkxMENKL5IiZPhjcOW0W97NDGJ31pzJjXHW+cCowtTJadS82X0QfUPMfeZeDyWiLPNMEaL/Hv1gOxm00bEd0AOBOL3Mu4QnLzZiCPHFkKt8Ve9UqWzzjNmqGJU3MtkUG8W/EXRQCJotBD+m2FZKzbm8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783032013; c=relaxed/simple;
	bh=Wv7sD5W8PEjwetp2FPG0o2HpVWd1iqh1e5+SCZWFfGM=;
	h=Date:To:From:Subject:Message-Id; b=P/VxkhRxo+CSJXROENjBTvRXHgdq1ONiji5bhKVoa5QHaGOj7j+JDf31AIEHSVWKOUeF3nIU2uoNMbGeQBkjsw2EA+urHP/vX57z25Sn5AT8540FU5tLMgn1vktO20d9ObjXP84yHVPJ+T4f+THG6XFRODw05Xlnmz7nv7UIXDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vklFCPdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vklFCPdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C89D1F000E9;
	Thu,  2 Jul 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783032005;
	bh=+J3I03J9MS8TPKcRZEH9qqYLVnVlmH4/ZHKbhmeITLE=;
	h=Date:To:From:Subject;
	b=vklFCPdr4Q/80OkLU/M+M3/6M9tfVl1RtANO+2D9XOFwsDKPB5SfL0BtM/xANVfhr
	 AgBSfbPm14l5R0ppp8kEoYyR0AYkd8bhUHtc+XMNZ/DS1ecHfNoy5186OPbEjpuMsb
	 5U5udjscWD3vFOPIvT5cey7cEMHODyhIFvXCuNtg=
Date: Thu, 02 Jul 2026 15:40:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-usama-as-a-thp-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260702224005.0C89D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Usama as a THP reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-usama-as-a-thp-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-usama-as-a-thp-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
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

maintainers-add-usama-as-a-thp-reviewer.patch

