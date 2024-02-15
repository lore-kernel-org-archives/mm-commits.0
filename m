Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A09A1386B3
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708024168; cv=none; b=eODYqj2y1HZBJ1XWWCCu/IwpAA5A1pe1r7hy7Z32kBcfC6el0tMgHqIPxKZj3+5RzD4dUs8HVsc7HtC456LkrCiNf8elJJhW+FnvXiSLLIeV17iATEzH81jo3d0K6MtO8nuLhMkeEHG3Id7M72M2+Q3hSR/eejUXxv7gX31BhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708024168; c=relaxed/simple;
	bh=Nl/+xuD7HthZCgFTvkqIS1j9NdhzhOfEUg8wTtFPUt8=;
	h=Date:To:From:Subject:Message-Id; b=qSRuTO6I7L5ebd76rd1bDfL/gKEhwTp4xtlL6EKVb9iJUE6VDXaSqxG018rUVaxvl0BcVeFwQAbsB/qw3vDiUXV8SK+wQeWFzDaXzlz+CB1XT3NgVQTcQmVQF8Z8LphoWwS/FOQjrxxGlgZnxWeW7nr4o48Ade35RqNTGYSlQo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KrcvIaPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KrcvIaPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E313CC433C7;
	Thu, 15 Feb 2024 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708024168;
	bh=Nl/+xuD7HthZCgFTvkqIS1j9NdhzhOfEUg8wTtFPUt8=;
	h=Date:To:From:Subject:From;
	b=KrcvIaPmi0d2658O8mG/MfW+wuTJ7DvS4yYE6EIp1LHTlzZa1QN+emFNi9IbdYfu1
	 eyX0D3bmF9++XxL0XQvLH7aAaQiB95naU5oRKdbmtOkhAHPVbHjiqeCVsfOThMoZyo
	 Rj6wxMeOKON1Gc5xe19hgA7jig2hAKQVkTT4DxhY=
Date: Thu, 15 Feb 2024 11:09:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch added to mm-unstable branch
Message-Id: <20240215190927.E313CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch

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
Subject: lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
Date: Thu, 15 Feb 2024 09:22:39 +0100

undo errant commant change

Link: https://lkml.kernel.org/r/Zc3Jz_eJaZ8MdnWV@localhost.localdomain
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
+++ a/lib/stackdepot.c
@@ -37,7 +37,7 @@
 #include <linux/kasan-enabled.h>
 
 #define DEPOT_POOLS_CAP 8192
-/* The pool_index is offset by 1 so the first record does not have a 0 handle */
+/* The pool_index is offset by 1 so the first record does not have a 0 handle. */
 #define DEPOT_MAX_POOLS \
 	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
 	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

