Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3939E8120A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104472; cv=none; b=mH3lnYlt0CnkkDswqSMhgHLPNpG0OlvMP07zBE+2foioXPVDD944Bjv/OnuXAumpZifm7+BbgzxcDZ6Nbv2ThUiGysDNeRire2rZdtqVk+IbKcu3jJvl4A6GGv9H7LqUFe+yT+GkxnJq/QiIcqsokaRrFFnTLE8nTUfNGez///k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104472; c=relaxed/simple;
	bh=5ZCtI0W1Bh2BLnGnde7Jv+ZGGx4JmW7OEEx14931CsE=;
	h=Date:To:From:Subject:Message-Id; b=Cv+gxmTGCir44A4tU1GTFfvyz07R+WtiWH3MP79FabFdwh8fQpIG3NYltJNcvudw4AuEiNL4cIEHwGjC/i5NPQGD+1fn88pv4YE8Npu72WN5576/69Kt6cYbveaOSJjYda1gacK/yrhNtbw4t6RRllxoUbGxBjmvcIuzKnK0jSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PnwPomhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PnwPomhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3293C113CD;
	Fri, 26 Apr 2024 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104471;
	bh=5ZCtI0W1Bh2BLnGnde7Jv+ZGGx4JmW7OEEx14931CsE=;
	h=Date:To:From:Subject:From;
	b=PnwPomhiOFthTJKwCN+eCrqWNYxxuAu0CXBmmSdehvmGPYBCehmlgXReHclF+B97n
	 4uNDEOSTD2WCDb+VEbvmcJ/EiRe2/qsod+pRgYeqxGKyJ9jvNereEEo2GsBJpsOmQy
	 g1DPCygSvc2Hk68BdxY31r0GMXh0awkRfDqDEH24=
Date: Thu, 25 Apr 2024 21:07:51 -0700
To: mm-commits@vger.kernel.org,j.granados@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch removed from -mm tree
Message-Id: <20240426040751.B3293C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: remove the now superfluous sentinel element from ctl_table array
has been removed from the -mm tree.  Its filename was
     ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joel Granados <j.granados@samsung.com>
Subject: ipc: remove the now superfluous sentinel element from ctl_table array
Date: Thu, 28 Mar 2024 16:57:52 +0100

This commit comes at the tail end of a greater effort to remove the empty
elements at the end of the ctl_table arrays (sentinels) which will reduce
the overall build time size of the kernel and run time memory bloat by ~64
bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove the sentinels from ipc_sysctls and mq_sysctls

Link: https://lkml.kernel.org/r/20240328-jag-sysctl_remset_misc-v1-5-47c1463b3af2@samsung.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    1 -
 ipc/mq_sysctl.c  |    1 -
 2 files changed, 2 deletions(-)

--- a/ipc/ipc_sysctl.c~ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/ipc/ipc_sysctl.c
@@ -178,7 +178,6 @@ static struct ctl_table ipc_sysctls[] =
 		.extra2		= SYSCTL_INT_MAX,
 	},
 #endif
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)
--- a/ipc/mq_sysctl.c~ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/ipc/mq_sysctl.c
@@ -64,7 +64,6 @@ static struct ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)
_

Patches currently in -mm which might be from j.granados@samsung.com are


