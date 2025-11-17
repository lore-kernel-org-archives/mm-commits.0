Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF42367BA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343264; cv=none; b=BYLE6lEZQoFH4wJErcAxW4ekUc52MytcVs1yZ5A2M2RLCT2gu2bakCcslyUhH4ckJVOWqD+6Bnejl2q62M2X+0i3NkFj/X6ZJ4NYPZBlrH85+/yW3okagnx5GP6Nuw1tI1p7P75gjccvBjNncojo63llPcWp6o3G6A03iC4C8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343264; c=relaxed/simple;
	bh=pf4PGFKdRNSITuq1/guIOiDvD/yuS7agTs1cJcqIAhE=;
	h=Date:To:From:Subject:Message-Id; b=uf50kp+aLQKXn3AYCG0VO3ByVbyHzDWd6gRSR/Tmj7/MfLnLZGT+cfqDr8A2GXEBomYaGLIY7KJ4+uBJu/f93yc3tp16ieXuTuliAx8QvXyY8OVuY3wgtzZipEFp2UQ5/kJyRJ4IS4af4Bkn8/30ybIGMAEAYCpG6ESum3YNx7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJMcOuMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJMcOuMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87045C113D0;
	Mon, 17 Nov 2025 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343264;
	bh=pf4PGFKdRNSITuq1/guIOiDvD/yuS7agTs1cJcqIAhE=;
	h=Date:To:From:Subject:From;
	b=MJMcOuMCW5ZYstIf1db5AcK+1SysJwKjm4JXK65ucxWcz0XrUmjijCslXutt46vOu
	 DuuvKIoIYEoAk250xeaT/M68tl3Kun9DDWRf5eKHcawIYT2fL9c/Wggr9ZKNV2+hDu
	 MdO0C1gB/bj4Owi6C0Rw6aLnA3vQEXxsfUBzecbw=
Date: Sun, 16 Nov 2025 17:34:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-include-linux-pgalloch-to-mm-core-section.patch removed from -mm tree
Message-Id: <20251117013424.87045C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
has been removed from the -mm tree.  Its filename was
     maintainers-add-include-linux-pgalloch-to-mm-core-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -16266,6 +16266,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
_

Patches currently in -mm which might be from harry.yoo@oracle.com are


