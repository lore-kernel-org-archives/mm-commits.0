Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6619C3C0630
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660959; cv=none; b=TccoRqxkmG3bgDAeQ64ZXyskYDZEGgXL8W8wCFVOoWTD+RF96DIcVC19fbEFPQ7PZdcY5uzxxGBrlpM5KA0IvneqgnUQuuXiSA1GCwxBoqHKkR2/J44PesCol1exDwhb2HR04KC8DcRNMMA0FgY9yCSutluPDKwA1e90kB+TQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660959; c=relaxed/simple;
	bh=bKnn8Ar/5WxVS04JkZtd66Yq/tz9agogQ2PpG9uqqzk=;
	h=Date:To:From:Subject:Message-Id; b=YDaf9grpLJhaCov/hFtvJZgVyrQhIku77/dARWXd57hHSdFTp5TtCgru5r6A0wNBTOOR13mhxukzJ6OZp36HZ72Vp3n2fPBxQ7opK1Za7yl5dhGZi46u3+greblD0or9oDYOAc/gzlkfJu+E2JWifB/JGdpT5ZGcz6sL5lS5blE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gnmr82rc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gnmr82rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C3C1F00A3A;
	Thu, 13 Aug 2026 22:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660958;
	bh=VNmcsiogDMi/dwoNZNAluusZ9VXyxbIeCDc+eqqrJYo=;
	h=Date:To:From:Subject;
	b=Gnmr82rcNGnC4gfPwVzl54PSllKjgLea8y4ZgbzIJNcXg5Q6SyFnvXW9K03mfZVcL
	 tDO+KlGUIIvdheBhN28DUrXtXtgcr+EbuKmWSJzfZPb29c3Y8iU/ULW3RyH3eeKuM/
	 yDfkt4SVf9E9FDKXG3uEII+YzIlCmzLZeOVdimWw=
Date: Thu, 13 Aug 2026 15:42:37 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,dave@stgolabs.net,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch removed from -mm tree
Message-Id: <20260813224237.F3C3C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: only destroy orphaned shm segments on sysctl write
has been removed from the -mm tree.  Its filename was
     ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: ipc: only destroy orphaned shm segments on sysctl write
Date: Mon, 15 Jun 2026 10:27:41 +0800

proc_ipc_dointvec_minmax_orphans() currently calls shm_destroy_orphaned()
whenever shm_rmid_forced is set, including on sysctl reads.  Reading
/proc/sys/kernel/shm_rmid_forced should not take shm_ids rwsem for write
and walk all segments.

Only run the cleanup when the sysctl is written and the forced RMID policy
is enabled.

When shm_rmid_forced=1, monitoring tools that read
/proc/sys/kernel/shm_rmid_forced trigger the cleanup on every read.

Link: https://lore.kernel.org/all/?q=only+destroy+orphaned+shm+segments+on+sysctl+write
Link: https://lore.kernel.org/tencent_738A8BC6E9EA205F555E4B0DAA154D4F8E0A@qq.com
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/ipc_sysctl.c~ipc-only-destroy-orphaned-shm-segments-on-sysctl-write
+++ a/ipc/ipc_sysctl.c
@@ -28,7 +28,7 @@ static int proc_ipc_dointvec_minmax_orph
 
 	if (err < 0)
 		return err;
-	if (ns->shm_rmid_forced)
+	if (write && ns->shm_rmid_forced)
 		shm_destroy_orphaned(ns);
 	return err;
 }
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are

mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

