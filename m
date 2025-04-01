Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3FC21D3CD
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545888; cv=none; b=MPau93mPaNpWlZdgxyqkcZmsZGGk9GqWNsf+X+u6noUNf8xcKf8D0lAG3lfnj4p19dVT0Pzo8GaxT52lwzduLIEXEC/lljefS8dDNgJcHMEqETebm7JHngJabZO2NN94MDJ69dBC5aircmV0RTIQV096vOfZOVctaJk4FPwste4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545888; c=relaxed/simple;
	bh=XZxXdqfR14y66c1NWLw9KkDeN5Y9Tkpamtfs6m3GMp8=;
	h=Date:To:From:Subject:Message-Id; b=r1D5q87Wx7AumrcqLpWzYRi6D777fHc8kc5fBFSl0QwSKq6vbQOmoTB+wQuCim7YiZnv+zIPnkwliqcJpGUpZ78Zv0AMbYOLaNsI3IosSzMd5H1WylO1msUr/xP489elaWW0fK2m2HEJF1Ca3LSgyNtcFiju4hHJk54yabWwjp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tm0vA9zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tm0vA9zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F5BC4CEE4;
	Tue,  1 Apr 2025 22:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545888;
	bh=XZxXdqfR14y66c1NWLw9KkDeN5Y9Tkpamtfs6m3GMp8=;
	h=Date:To:From:Subject:From;
	b=Tm0vA9zkRs9+x2ny/Rd5kW0SC2UXAILXYGemd2aQNWdkgX699rJLaK542GyJmgQB5
	 mLNsxWi56Od3UNc75BKbm+C6gapYVt2e5myVGjaz/ihbi/hj6NGbqyf+9aTghdSdhl
	 aqrUxPKk0tO51yEKV21Fus5ICpd9wqjcknAzUOZs=
Date: Tue, 01 Apr 2025 15:18:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-mm-add-entry-for-numa-memblocks-and-numa-emulation.patch removed from -mm tree
Message-Id: <20250401221808.65F5BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mm: add entry for numa memblocks and numa emulation
has been removed from the -mm tree.  Its filename was
     maintainers-mm-add-entry-for-numa-memblocks-and-numa-emulation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: mm: add entry for numa memblocks and numa emulation
Date: Wed, 26 Mar 2025 23:55:40 +0200

Link: https://lkml.kernel.org/r/20250326215541.1809379-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-mm-add-entry-for-numa-memblocks-and-numa-emulation
+++ a/MAINTAINERS
@@ -15505,6 +15505,16 @@ S:	Maintained
 F:	include/linux/execmem.h
 F:	mm/execmem.c
 
+MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/numa_memblks.h
+F:	mm/numa.c
+F:	mm/numa_emulation.c
+F:	mm/numa_memblks.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from rppt@kernel.org are


