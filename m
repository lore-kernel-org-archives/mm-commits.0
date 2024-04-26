Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238C8175E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104470; cv=none; b=GO+uxpwiOvbISw/3PhVVCyzPozR4FbJHHuUtHYERK4QpH1pdl4CmwZSWLH9VYXjnNgex8PrOpu/hJRmCk99BCdpBihGdkM50hM/pQe0TUfJ6hJY/swcAvqrW8XluE3e7vCP+1oQFB3R/rXdQUAge/kJKOXKRpduWejJX9n7CG6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104470; c=relaxed/simple;
	bh=WxKu9GCC1tYdtvwEZEFSE4u18wqWPpn1UsOwvJhE1kw=;
	h=Date:To:From:Subject:Message-Id; b=uPrJ5iRX1FjOZ+OtrjR+AcdGFjx+vK/iA+dAFrFbPda2pIgrsg06pA39sTR3i/4jX0LnZ5lBjU3EC3aZnJisiJipolPsKEiw6qYTlClRhrga4qPywtpuH91rz5HHfUrwo3SaGjIEJHvwGdeOnMdgbzroJv9PvRwz90Beb2dYG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYpDrhjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYpDrhjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A448FC113CD;
	Fri, 26 Apr 2024 04:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104470;
	bh=WxKu9GCC1tYdtvwEZEFSE4u18wqWPpn1UsOwvJhE1kw=;
	h=Date:To:From:Subject:From;
	b=dYpDrhjbNJ7bTpngihlF8oz0us3AAsIdUSycmIczFhcL9b3Y9icUo6ZsnV5CBWTMh
	 d4NTwi8iuDfWv2FjuOQWKxnAgU/lXUJzx3TZBe3oLPpPbkPfBjPuUS7zeDHq/7EWwI
	 VF90VOjaaLYvLix/N/niY+WuDyuDWv/C5+KGYN8I=
Date: Thu, 25 Apr 2024 21:07:50 -0700
To: mm-commits@vger.kernel.org,j.granados@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch removed from -mm tree
Message-Id: <20240426040750.A448FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: initrd: remove the now superfluous sentinel element from ctl_table array
has been removed from the -mm tree.  Its filename was
     initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joel Granados <j.granados@samsung.com>
Subject: initrd: remove the now superfluous sentinel element from ctl_table array
Date: Thu, 28 Mar 2024 16:57:51 +0100

This commit comes at the tail end of a greater effort to remove the empty
elements at the end of the ctl_table arrays (sentinels) which will reduce
the overall build time size of the kernel and run time memory bloat by ~64
bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove sentinel from kern_do_mounts_initrd_table.

Link: https://lkml.kernel.org/r/20240328-jag-sysctl_remset_misc-v1-4-47c1463b3af2@samsung.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/init/do_mounts_initrd.c~initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/init/do_mounts_initrd.c
@@ -29,7 +29,6 @@ static struct ctl_table kern_do_mounts_i
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
-	{ }
 };
 
 static __init int kernel_do_mounts_initrd_sysctls_init(void)
_

Patches currently in -mm which might be from j.granados@samsung.com are


