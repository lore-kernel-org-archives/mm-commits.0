Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9236113D8B0
	for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2024 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893192; cv=none; b=d4njK95fjF1RWdv8lBsOyTTQuasj0+qCnjYfjasKtSzn+Tdjg7SIiXzrE+cf/38G/mQHI44rdP5I4DUv1lw9TEcks6uGpR/AhB5VmhDfZmxMUafp3Ft5aLzd8ccDWXJhR6QUS0CgBWQ3WjH9jwWHsRejWwBjOp3WXedc2e3yFU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893192; c=relaxed/simple;
	bh=mpm8xUWCnD37eP9zbTuPvwdTcRlGWa80DhOs8q6Dj6k=;
	h=Date:To:From:Subject:Message-Id; b=ZlKIciFER5j7wPGBhBslzBD5zUC6exQasdpK/Y6ewciEVETFkmzyn0uE3RV2suwaG0cboY/5UKBdTPDHed5tcA4ULBLlS0RVsjCseXqI5Bh4jk3XvSCBOSAr9V2uhcFqLmvzMEU+BNu7mWL/yvocZqBLcEomXDBpE65Y/bP2zF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mioTgWST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mioTgWST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277FFC116B1;
	Tue, 23 Apr 2024 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713893192;
	bh=mpm8xUWCnD37eP9zbTuPvwdTcRlGWa80DhOs8q6Dj6k=;
	h=Date:To:From:Subject:From;
	b=mioTgWSTOSY3HpMZDOyRx3q9UKAsHtQ5YtsG57YOAtaN2IjKFVzwSAjO1bZaF1eZS
	 S2N7kWjeMzyale9I7I3n0lknSk5jfFbdicYDGTAy1yXdnDW5ct6sG9hb9ejdjL3+ax
	 mE4cD0K+Y81WXEIdD+sDk8hQul44o/PjH5fGSX58=
Date: Tue, 23 Apr 2024 10:26:31 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shikemeng@huaweicloud.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2.patch added to mm-unstable branch
Message-Id: <20240423172632.277FFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2
Date: Tue, 23 Apr 2024 10:22:53 +1000

fix build with CONFIG_CGROUP_WRITEBACK=n

mm/backing-dev.c: In function 'wb_stats_show':
mm/backing-dev.c:175:33: error: 'struct bdi_writeback' has no member named =
'memcg_css'
  175 |                    cgroup_ino(wb->memcg_css->cgroup),
      |                                 ^~

Link: https://lkml.kernel.org/r/20240423102253.3675d0af@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/backing-dev.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2
+++ a/mm/backing-dev.c
@@ -172,7 +172,11 @@ static void wb_stats_show(struct seq_fil
 		   "b_more_io:         %10lu\n"
 		   "b_dirty_time:      %10lu\n"
 		   "state:             %10lx\n\n",
+#ifdef CONFIG_CGROUP_WRITEBACK
 		   cgroup_ino(wb->memcg_css->cgroup),
+#else
+		   (ino_t)0,
+#endif
 		   K(stats->nr_writeback),
 		   K(stats->nr_reclaimable),
 		   K(stats->wb_thresh),
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix-2.patch

