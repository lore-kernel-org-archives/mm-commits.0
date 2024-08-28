Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3165F182B3
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806944; cv=none; b=hpORMxfMLZ3+l/b7avy4RZe3cj8E/7DhtLz2uVEicpzyVOKOrdfCPZllggDi8YJh57QPzuVQsM/MgwA69f4O0ExuJXnvV/D/iMJ0A13ZDiuEk4XTEChfdWVxxwbch3ek3vnv7K+WRaQBPwakZLw/V/iz2vN9/ZTOfatAfm+UuFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806944; c=relaxed/simple;
	bh=jQxbHI/feW3TS6CpGeeB2hgVdwHttM5fNdHlEyLW5jQ=;
	h=Date:To:From:Subject:Message-Id; b=JcLZ34gy8fkIarinO59tuYs7G9DbiktmWCM1wbIChuNLeKlNlTqFNMlHb98y0rKxk+nePN3L5VejWDpyXAoHPnJ4z9tr698ARoXDBq4ExukJjk5/kBGg+saWH0pHUpQMIdmQiTIBw+NDBlj4lHTFXVtKbwcjLs912bc4Dt2z0+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQsjauxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQsjauxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA164C4AF0F;
	Wed, 28 Aug 2024 01:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724806943;
	bh=jQxbHI/feW3TS6CpGeeB2hgVdwHttM5fNdHlEyLW5jQ=;
	h=Date:To:From:Subject:From;
	b=aQsjauxPjSU3kmh7yxc+1XJTO3/IVDNELpKMMJ7e2pZinDdDKTdvr6LC55ZRlQkSM
	 AM1drDqkzoyMUFA5W15IKu9erOdtvkETIcdqAEShshBIbOt2gFbQway8/KSbAGC2aw
	 u8L3ujSVKu5KrYRW9SWyj1dxApqqxannn0/PszO4=
Date: Tue, 27 Aug 2024 18:02:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanshuai@oppo.com,v-songbaohua@oppo.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,ioworker0@gmail.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-count-the-number-of-anonymous-thps-per-size-fix.patch added to mm-unstable branch
Message-Id: <20240828010223.AA164C4AF0F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-count-the-number-of-anonymous-thps-per-size-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-count-the-number-of-anonymous-thps-per-size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-count-the-number-of-anonymous-thps-per-size-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-count-the-number-of-anonymous-thps-per-size-fix
Date: Tue Aug 27 06:00:44 PM PDT 2024

documentation fixups, per David

Link: https://lkml.kernel.org/r/3e8add35-e26b-443b-8a04-1078f4bc78f6@redhat.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-count-the-number-of-anonymous-thps-per-size-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -552,9 +552,9 @@ split_deferred
         be split under memory pressure, if splitting is possible.
 
 nr_anon
-       the number of transparent anon huge pages we have in the whole system.
-       These huge pages could be entirely mapped or have partially
-       unmapped/unused subpages.
+       the number of anonymous THP we have in the whole system. These THPs
+       might be currently entirely mapped or have partially unmapped/unused
+       subpages.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

