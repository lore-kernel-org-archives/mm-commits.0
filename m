Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76BA22F767
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753484926; cv=none; b=AFJdg496mza4pEttMIdUKMxmhFdwJZMZ8ME/zkPH6iHEewREbr+LLlvkImQg3OZ/DTK1YeLboYAI7o2WFMmcj2IfSXLdR0/uGgxer3mdywKCfohzvV7wqZFUDXL6lH+q8qEVqfOr3ssiPDw8vAE18jJ4vi91OvJXaCDHkJDNLmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753484926; c=relaxed/simple;
	bh=KslozR+fzgXjq4kINvUOeIYSeQxtjDzvuG7huot1EwQ=;
	h=Date:To:From:Subject:Message-Id; b=OySXiY6g1P/u5vNsGseYzFQhKTkgAQdDMmW88iLwJbLCRfReDILQhtovw9ce4HRlT4/8sXswYkSHSqG/AfrdcDmmEacazWbwDxZyRQH5HmeL/W3JmXQnjgtOYbskEod2bmHHLROBWNcq+1SZf6SRrxoCMDWf7Wn+6/HUvTEq/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=01V8NLMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="01V8NLMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0B3C4CEE7;
	Fri, 25 Jul 2025 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753484926;
	bh=KslozR+fzgXjq4kINvUOeIYSeQxtjDzvuG7huot1EwQ=;
	h=Date:To:From:Subject:From;
	b=01V8NLMvSlxFB2dbLJrK3LTvQqnJEe++eobzUXCo4XUksMV7aZIyfOCSAebTkBXCj
	 DohQRLBaY9lu98rRuzFPyhJprL0KWGRFhrpd14onC+dDB8FhThvddpylz2Wxg4lzlD
	 OfH/SyQXyteIV/mMBLrwS1hcufaleI03woB0WFaU=
Date: Fri, 25 Jul 2025 16:08:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-headers-to-mempory-policy-migration-section.patch added to mm-unstable branch
Message-Id: <20250725230846.1C0B3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing headers to mempory policy & migration section
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-missing-headers-to-mempory-policy-migration-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-headers-to-mempory-policy-migration-section.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: MAINTAINERS: add missing headers to mempory policy & migration section
Date: Fri, 25 Jul 2025 10:56:15 -0700

These two files currently do not belong to any section.
The memory policy & migration section seems to be a good home for them!

Link: https://lkml.kernel.org/r/20250725175616.2397031-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-headers-to-mempory-policy-migration-section
+++ a/MAINTAINERS
@@ -15850,7 +15850,9 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
 F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

maintainers-add-missing-headers-to-mempory-policy-migration-section.patch

