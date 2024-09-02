Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30114BF86
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248814; cv=none; b=t9Jtv3kpeZI4Ku10+Tidj5/+yoTdAME7z68f4PMDeiA77q3vGetouDk/bfX5QbkWvl7JN90wGcATW5UWeeKGNe3ofpR5mUj9M0pB042XapHrRV9h5l/5InGNPNeH7xHPvoXBznw2uo9bN+H7Ha+I/dipc0zd7XIU6MCfQmiWKRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248814; c=relaxed/simple;
	bh=+UKfGyxdCLW3tuDv8SM54yA7PEV6XrvGO2sE2Za48NI=;
	h=Date:To:From:Subject:Message-Id; b=pbNAYWIyrELx3E2SuDiU9B1azDbp+Nrxhdunndt9G48cWPTSqWeOhjrjQSCxGyK+ZkFSizu5tU7w/YwVsjGl6gKdNItvdK+UwKdWORPPKOcSWSCc06lEEgRCqLvQs6aGVGwTCGh3M3v90oVrEaCdm2W9eFc1BFPdOEnSkoTlhxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q+ANeQxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q+ANeQxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032EDC4CEC2;
	Mon,  2 Sep 2024 03:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248814;
	bh=+UKfGyxdCLW3tuDv8SM54yA7PEV6XrvGO2sE2Za48NI=;
	h=Date:To:From:Subject:From;
	b=Q+ANeQxt1a9d4uJSWuv0x0ZBBS7OXBTSc4HBV7dsWi0tkVQnv1+9ZTRR3/0G+aPAW
	 l5EsEnY3uH/g35C4qS3dH5dz+/6AhaNHlZ3GMVP8fzKYdD8EcJ2YeCQTsWMc2w5IzR
	 l+V1hgvtOM4SV6IEmImUMINKlNR3rwP8ssNGwOhk=
Date: Sun, 01 Sep 2024 20:46:53 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch removed from -mm tree
Message-Id: <20240902034654.032EDC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/percpu_counter: add missing __percpu qualifier to a cast
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: lib/percpu_counter: add missing __percpu qualifier to a cast
Date: Wed, 14 Aug 2024 08:44:13 +0200

Add missing __percpu qualifier to a (void *) cast to fix

percpu_counter.c:212:36: warning: cast removes address space '__percpu' of expression
percpu_counter.c:212:33: warning: incorrect type in assignment (different address spaces)
percpu_counter.c:212:33:    expected signed int [noderef] [usertype] __percpu *counters
percpu_counter.c:212:33:    got void *

sparse warnings.

Found by GCC's named address space checks.

There were no changes in the resulting object file.

Link: https://lkml.kernel.org/r/20240814064437.940162-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c~lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast
+++ a/lib/percpu_counter.c
@@ -209,7 +209,7 @@ int __percpu_counter_init_many(struct pe
 		INIT_LIST_HEAD(&fbc[i].list);
 #endif
 		fbc[i].count = amount;
-		fbc[i].counters = (void *)counters + (i * counter_size);
+		fbc[i].counters = (void __percpu *)counters + i * counter_size;
 
 		debug_percpu_counter_activate(&fbc[i]);
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are

errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

