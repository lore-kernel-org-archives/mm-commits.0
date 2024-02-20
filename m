Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3970152E05;
	Tue, 20 Feb 2024 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467752; cv=none; b=M84XeHh1eZWGjq8X2j2JqjL5Mexvpxn4vBT2obpKSTfXEvey676c0gJ8BI504pOMLw3MVboibBRkGtgw1gi7nC17JKLVW0cfpilZ+82Gal7RFk3OJ/BijwXiDK4q4gRSMVsY31dWt6316fXuHuKcTAv0eBPD6xhyLEt3bZP4STA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467752; c=relaxed/simple;
	bh=wjNqv5S/iGUc/LrczozFrHBiGvj7yLbN0AuOjH3lWOk=;
	h=Date:To:From:Subject:Message-Id; b=dwGCruoH9BN9g+naVB9I8nMgYrrx8mNuvUpTF8LcEm2lLxRhRNEifUNAFLpdOKLgw9yljT/dMnejGllQxjNAJCLiU/oGEjauz1M1Joz0woWuoIl6g8UOwKuPnMmy3wafZ3/58i1+DwAFU12jnvqYDIPIaoabKWt/c7qiOTsLhs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdlN40Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdlN40Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACC2C433F1;
	Tue, 20 Feb 2024 22:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467752;
	bh=wjNqv5S/iGUc/LrczozFrHBiGvj7yLbN0AuOjH3lWOk=;
	h=Date:To:From:Subject:From;
	b=xdlN40Yz0FPXnlKMV/TTY57sIMd3Hjgm2nzA4XKNNybZRug5y3vIs4dPmfSclVVE/
	 Sy28Qm/9HjSxqzBQ7IfOKLjRDqnObLJYVoluEg8Bp0Y/sM+0FdKYpiDCwX1fSqchRx
	 fthrPKaQGqi6ZMPh2LVQrv4F+gaYhl6yL3jJY/Pc=
Date: Tue, 20 Feb 2024 14:22:31 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@suse.com,jonas@wielicki.name,debianlists@actiu.net,colin.i.king@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch removed from -mm tree
Message-Id: <20240220222232.2ACC2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: clarify swapaccount=0 deprecation warning
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clarify swapaccount=0 deprecation warning
Date: Tue, 13 Feb 2024 03:16:34 -0500

The swapaccount deprecation warning is throwing false positives.  Since we
deprecated the knob and defaulted to enabling, the only reports we've been
getting are from folks that set swapaccount=1.  While this is a nice
affirmation that always-enabling was the right choice, we certainly don't
want to warn when users request the supported mode.

Only warn when disabling is requested, and clarify the warning.

[colin.i.king@gmail.com: spelling: "commdandline" -> "commandline"]
  Link: https://lkml.kernel.org/r/20240215090544.1649201-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/20240213081634.3652326-1-hannes@cmpxchg.org
Fixes: b25806dcd3d5 ("mm: memcontrol: deprecate swapaccounting=0 mode")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reported-by: "Jonas Schäfer" <jonas@wielicki.name>
Reported-by: Narcis Garcia <debianlists@actiu.net>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-clarify-swapaccount=0-deprecation-warning
+++ a/mm/memcontrol.c
@@ -7971,9 +7971,13 @@ bool mem_cgroup_swap_full(struct folio *
 
 static int __init setup_swap_account(char *s)
 {
-	pr_warn_once("The swapaccount= commandline option is deprecated. "
-		     "Please report your usecase to linux-mm@kvack.org if you "
-		     "depend on this functionality.\n");
+	bool res;
+
+	if (!kstrtobool(s, &res) && !res)
+		pr_warn_once("The swapaccount=0 commandline option is deprecated "
+			     "in favor of configuring swap control via cgroupfs. "
+			     "Please report your usecase to linux-mm@kvack.org if you "
+			     "depend on this functionality.\n");
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

