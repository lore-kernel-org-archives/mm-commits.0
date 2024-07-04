Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978B71755B
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136748; cv=none; b=smbmeg5aBI6tDlV00iaMP34zhFoL/Skiv4QxNLrFmN9KFXo7jQQDrF8Lf1Cj29GbecbdpEGgwMc3E2gSvW4B6Y2yNofYLPw4B7PG0zPo0aGb1gXCV/jdYhvD/PkEwRVug9iHPPOcaZLG83iILvScN9SRbTO9dLbD3xqUlp2ech4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136748; c=relaxed/simple;
	bh=4wvnhuAXCU+DOLEEFCKUdzHjEDKyzpcL6+yy1Tok1tY=;
	h=Date:To:From:Subject:Message-Id; b=ntQL8rUjBDUhyqM9TqrYfjasIyWVcB62xvYqvEmqxmcJ44vQi7cBUrfea31eFfA7bpqWKRvfRuCCSuduJXT3kqn6neWnKHTzq2MPRn6KJg3YanxfEouxHhpLVcKBQBj5/SVxyHFrYDafrU1UiTWMVdwPpUM34A9P+rl9VD74mHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HrmhZcTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HrmhZcTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E63C3277B;
	Thu,  4 Jul 2024 23:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136748;
	bh=4wvnhuAXCU+DOLEEFCKUdzHjEDKyzpcL6+yy1Tok1tY=;
	h=Date:To:From:Subject:From;
	b=HrmhZcTxw9BXRJHDi9Wn9Rwz2v1uV7EzkvPA1+/AcMYSGqFr2R+CbgIr1kDRaHSP1
	 Nj1MzxbiwtIVBbJd1LTnDdYrGbw/BRynOfyrXHwQ9TwkHlzb4gXUTAPfEZy2xV8pJZ
	 HYNfhBnaGCJWJpdxdlLWIerkR71Np4KcBVqtn7IA=
Date: Thu, 04 Jul 2024 16:45:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch removed from -mm tree
Message-Id: <20240704234548.26E63C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch

This patch was dropped because it was folded into mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch

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
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch
mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

