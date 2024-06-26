Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457418EFFB
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719428524; cv=none; b=gEncjd3LF894pG6ayeAZbi2NHIXQX1557O4CSbn8F9SmgpBmiURxapav+NQWsX3n+r/l5FFcivBY4pglZs2sYi5vCXjwQ2Z2DtyicVgj862E1n0tl0KYcsylpgiU2b/gOHnckFGQuKvNiyu5EJPpl2KmKuT7dnL+kMbTHK+QJfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719428524; c=relaxed/simple;
	bh=j8asqZGkxmTAd4VVBd0qE7seapTb+BzYsnkFGkabcCU=;
	h=Date:To:From:Subject:Message-Id; b=l4RAMoCL4fGo4G+/WcrqQO4Wpw8ge+D9wisyLzNZ1PRQ/R0nzJU5JxMsdGbf+Swq+HpvHcysokrxf3lcU0jDWFeUNh4J0KsBAvcLFDow+GeAxm4HkUL4LLBqvUCiXMyNAOXZvHTcHqzYPKE05AaTA1+Zu5xqmJN/2tdObtNuiBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o2EIChis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o2EIChis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D3EC116B1;
	Wed, 26 Jun 2024 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719428523;
	bh=j8asqZGkxmTAd4VVBd0qE7seapTb+BzYsnkFGkabcCU=;
	h=Date:To:From:Subject:From;
	b=o2EIChisAhYZaBSCSjBMef0QOXqkWH2aKbnjejjr6kqDeGF8eXUMGfSIlU1JtAjIe
	 /T/Z2gaSOXuHT4RbPplgaUtCrVIp8kBkwuDOPE6BIRtdWCUGjg9v9xKbomGWqC9IJM
	 xHMm+dhti3lgBu5fL0PHQQFw+hOj4TFNctpoJsrY=
Date: Wed, 26 Jun 2024 12:02:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch added to mm-unstable branch
Message-Id: <20240626190203.98D3EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix
Date: Wed, 26 Jun 2024 18:00:22 +0000

better config option description provided by Michal

Link: https://lkml.kernel.org/r/ZnxXNtvqllc9CDoo@google.com
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/init/Kconfig~mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix
+++ a/init/Kconfig
@@ -970,11 +970,19 @@ config MEMCG
 	  Provides control over the memory footprint of tasks in a cgroup.
 
 config MEMCG_V1
-	bool "Legacy memory controller"
+	bool "Legacy cgroup v1 memory controller"
 	depends on MEMCG
 	default n
 	help
-	  Legacy cgroup v1 memory controller.
+	  Legacy cgroup v1 memory controller which has been deprecated by
+	  cgroup v2 implementation. The v1 is there for legacy applications
+	  which haven't migrated to the new cgroup v2 interface yet. If you
+	  do not have any such application then you are completely fine leaving
+	  this option disabled.
+
+	  Please note that feature set of the legacy memory controller is likely
+	  going to shrink due to deprecation process. New deployments with v1
+	  controller are highly discouraged.
 
 	  San N is unsure.
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

