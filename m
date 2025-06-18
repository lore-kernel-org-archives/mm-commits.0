Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79BB2F5319
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 00:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206708; cv=none; b=fSWPHwHS0P27hHDSC0Fyy6gwe//RcmOILPGMCEqQL3pge923o+ZyD6/8Lr4YbCEsJwD2uRthc2Mc0xV3pBYQX6MqRXsJMG+zymQt4SFCJy8jgj9+E+byLGPdQHwguCOvE5hkpjvwDEP7qCLcvn7CeMiSwtvul5yoAeV3HXFzZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206708; c=relaxed/simple;
	bh=EuZf4kIqBR4bO34YSGpTYIj8wQIlRfwZTCZwGfPETcM=;
	h=Date:To:From:Subject:Message-Id; b=sZgGfHZ4aBzbJ1tLpZYSjR56fiNFR5Uc/tJdecs8/i/hOtoyLBOwvtOhmQ7w+Moefj6dMYJr2aNFg53yWPQO1rt9+/pRt07gRkA6C6pIo+TbY9sZHEBxWub/i609wmqBDS48XKad5gh9FgKpDGkGAK2NBDO4QzJYHQ1s6nouv4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0R9RT8TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0R9RT8TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69328C4CEED;
	Wed, 18 Jun 2025 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750206707;
	bh=EuZf4kIqBR4bO34YSGpTYIj8wQIlRfwZTCZwGfPETcM=;
	h=Date:To:From:Subject:From;
	b=0R9RT8TJ5Q7oioeQS+2Fkk+yzsPZLnt6JlU6prjsg7TN+s8jOpva8yXOmaUqC2AYj
	 fQN6O36wpsd87XSo71xmgXS8fIzyxvzFcZ1kaDe7ixVGdp1KX2vJQRTIC9XmQji61Y
	 Xmyh4pEF7fgoPt1q5VbM+AycddVY10rD36G3qvwg=
Date: Tue, 17 Jun 2025 17:31:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-oom-killer-maintainer-structure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250618003147.69328C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add OOM killer maintainer structure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-oom-killer-maintainer-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-oom-killer-maintainer-structure.patch

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
From: Michal Hocko <mhocko@suse.com>
Subject: mm: add OOM killer maintainer structure
Date: Tue, 17 Jun 2025 10:58:19 +0200

Add MAINTAINERS info for the oom-killer.

Link: https://lkml.kernel.org/r/20250617085819.355838-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure
+++ a/MAINTAINERS
@@ -15850,6 +15850,14 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - OOM KILLER
+M:	Michal Hocko <mhocko@suse.com
+R:	David Rientjes <rientjes@google.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/oom_kill.c
+
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-add-oom-killer-maintainer-structure.patch

