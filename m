Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9BD63A1
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709757279; cv=none; b=WR5hzEYn8l7UAjiMFogLBHMM9ru6BpV0BNXgXeNjheGiwGiW8VihjB3YvEpgxiyqz/LdiWsMXS81Rtipas5pvj74DWT/rx9+pdgBI8iJ8weNmQ1XTkgjpHNFKzah3YSV9VTgozWRdbERaiqC/21ZagKABLfcfqlzHaiiSYWBL/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709757279; c=relaxed/simple;
	bh=WDbkB+Bd8BC/JEHNUclG9WSrl1iV1fWXC7JTmjOQBc0=;
	h=Date:To:From:Subject:Message-Id; b=bWQe+buWeW82me3UImXtgxxagK61hZBFFDxBgxrLV7FCUB/UYf+Q8zg0REuKr2UZqtucNCubIZg68Szg5GLCzlrZ28W4UTEUWQKfO+Z6BrlTPui05e5xin4LFG1FrmzwyN3r8+ZltN+im10NbItkryKhhR261G9xc0lq2Rwo6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=svRTtlpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="svRTtlpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396F7C43394;
	Wed,  6 Mar 2024 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709757279;
	bh=WDbkB+Bd8BC/JEHNUclG9WSrl1iV1fWXC7JTmjOQBc0=;
	h=Date:To:From:Subject:From;
	b=svRTtlpgkWo0A8gdxEkcEbD7d74pFHff0Vz3fN8x0SwNLUxLbGVyqzju3JOP7VOxh
	 HR3OQPqQIvKku7mNNznrcPU5hJGq7/zDQRIDlGzkajAoToUey0Lw2qVj4JDe757xKA
	 0bSlab+DS+dlrnT3dhHPiMWwGCZaF6QZqnY1kVgo=
Date: Wed, 06 Mar 2024 12:34:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-drop-unnecesary-check.patch added to mm-unstable branch
Message-Id: <20240306203439.396F7C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: drop unnecesary check
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-drop-unnecesary-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-drop-unnecesary-check.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: drop unnecesary check
Date: Wed, 6 Mar 2024 13:32:17 +0100

stackdepot only saves stack_records which size is greather than 0,
so we cannot possibly have empty stack_records.
Drop the check.

Link: https://lkml.kernel.org/r/20240306123217.29774-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-drop-unnecesary-check
+++ a/mm/page_owner.c
@@ -865,8 +865,7 @@ static int stack_print(struct seq_file *
 	entries = stack_record->entries;
 	stack_count = refcount_read(&stack_record->count) - 1;
 
-	if (!nr_entries || nr_entries < 0 || stack_count < 1 ||
-	    stack_count < page_owner_stack_threshold)
+	if (stack_count < 1 || stack_count < page_owner_stack_threshold)
 		return 0;
 
 	for (i = 0; i < nr_entries; i++)
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-check-for-null-stack_record-before-bumping-its-refcount.patch
mmpage_owner-drop-unnecesary-check.patch

