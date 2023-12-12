Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554E480028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVcBVWOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F97AC433C8;
	Tue, 12 Dec 2023 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407589;
	bh=x70musMUhZV3QuEJ3SDRNa8rH9AEU5lJ3vYLDr6HAxE=;
	h=Date:To:From:Subject:From;
	b=XVcBVWOMqAW+oC6cZYn6Jd/9igstjHlpir1p2PdWOEqe5njHWxjspwMxN7i+qNRT1
	 tFPLSaEhElTrxvxjWG/JC2X/qwdIYAtVNygyYkcam0zwk21WFC5R3o8Qk0ZPHir6RX
	 N0YYxt5Q/FPLUc1vVgypFfiaq+xoExLB5R0FEtl0=
Date: Tue, 12 Dec 2023 10:59:48 -0800
To: mm-commits@vger.kernel.org,dmaluka@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-add-config_transparent_hugepage_never-option.patch removed from -mm tree
Message-Id: <20231212185949.1F97AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/thp: add CONFIG_TRANSPARENT_HUGEPAGE_NEVER option
has been removed from the -mm tree.  Its filename was
     mm-thp-add-config_transparent_hugepage_never-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmytro Maluka <dmaluka@chromium.org>
Subject: mm/thp: add CONFIG_TRANSPARENT_HUGEPAGE_NEVER option
Date: Tue, 5 Dec 2023 18:02:44 +0100

Currently enabling THP support (CONFIG_TRANSPARENT_HUGEPAGE) requires
enabling either CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS or
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE, which both cause khugepaged starting
by default at kernel bootup.  Add the third choice
CONFIG_TRANSPARENT_HUGEPAGE_NEVER, in line with the existing kernel
command line setting transparent_hugepage=never, to disable THP by default
(in particular, to prevent starting khugepaged by default) but still allow
enabling it at runtime via sysfs.

Rationale: khugepaged has its own non-negligible memory cost even if it is
not used by any applications, since it bumps up vm.min_free_kbytes to its
own required minimum in set_recommended_min_free_kbytes().  For example,
on a machine with 4GB RAM, with 3 mm zones and pageblock_order ==
MAX_ORDER, starting khugepaged causes vm.min_free_kbytes increase from 8MB
to 132MB.

So if we use THP on machines with e.g.  >=8GB of memory for better
performance, but avoid using it on lower-memory machines to avoid its
memory overhead, then for the same reason we also want to avoid even
starting khugepaged on those <8GB machines.  So with
CONFIG_TRANSPARENT_HUGEPAGE_NEVER we can use the same kernel image on both
>=8GB and <8GB machines, with THP support enabled but khugepaged not
started by default.  The userspace can then decide to enable THP via sysfs
if needed, based on the total amount of memory.

This could also be achieved with the existing transparent_hugepage=never
setting in the kernel command line instead.  But it seems cleaner to avoid
tweaking the command line for such a basic setting.

P.S. I see that CONFIG_TRANSPARENT_HUGEPAGE_NEVER was already proposed
in the past [1] but without an explanation of the purpose.

[1] https://lore.kernel.org/all/202211301651462590168@zte.com.cn/

Link: https://lkml.kernel.org/r/20231205170244.2746210-1-dmaluka@chromium.org
Link: https://lore.kernel.org/all/20231204163254.2636289-1-dmaluka@chromium.org/
Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/Kconfig~mm-thp-add-config_transparent_hugepage_never-option
+++ a/mm/Kconfig
@@ -873,6 +873,12 @@ choice
 	  madvise(MADV_HUGEPAGE) but it won't risk to increase the
 	  memory footprint of applications without a guaranteed
 	  benefit.
+
+	config TRANSPARENT_HUGEPAGE_NEVER
+		bool "never"
+	help
+	  Disable Transparent Hugepage by default. It can still be
+	  enabled at runtime via sysfs.
 endchoice
 
 config THP_SWAP
_

Patches currently in -mm which might be from dmaluka@chromium.org are


