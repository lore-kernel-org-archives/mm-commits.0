Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D725149E00
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854744; cv=none; b=ne06vsHmzgdLxB0wHYo/3Xg7qYAFWJv+pMOhmGaEjJ/+gPNRq90YThT0V7WttMVvSfLgqH1B1VOALDn5IVysp2fUSUdf3WYAThC4lnpu9ywQy1apzXuSNF458I7d/iYMDJxxYTH908Yo1oOKekUByrlgym49nnlqbgNwzQ3S7rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854744; c=relaxed/simple;
	bh=FvQR2iEEIJrFLtOWfxBZZD3FzxVBmWDJpNBL9O+GimA=;
	h=Date:To:From:Subject:Message-Id; b=r1HDbZlccsLue7FjtzZ/ijPf0hC8a0EWgkEvTMl12VHp4wBdmpwQDC18YtbXsIvy1SIJQKRFfmVkoVrAKRrGoGj+7tE8TunSwHMsta3ouuvai/5vA8wTzTRfpbjoWP5aSmP28cMYKE4NRsFKG/q5S4tWBmBKnFIuf5Pi/fqeBpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+PxSxF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+PxSxF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04263C4CECF;
	Wed,  6 Nov 2024 00:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854744;
	bh=FvQR2iEEIJrFLtOWfxBZZD3FzxVBmWDJpNBL9O+GimA=;
	h=Date:To:From:Subject:From;
	b=V+PxSxF5w0/tn8fnftKQIbM1wIWWy/I1lRDBm8Ee92ThRrMkICCvVl4LY9lbXxhn4
	 aBT39demB4CLxKEUmsvutFhnIxlf8SBp6GKpR9coGvygrebDPSw6/nZ5/kjm3nN8bH
	 wyCB/PcaNPegxNxoJUB84FR6xXfPVCWbu6M9QfMY=
Date: Tue, 05 Nov 2024 16:59:03 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,pintu.ping@gmail.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-fix-useless-return-in-void-function.patch removed from -mm tree
Message-Id: <20241106005904.04263C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: fix useless return in void function
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-useless-return-in-void-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm/cma: fix useless return in void function
Date: Fri, 27 Sep 2024 23:46:37 +0530

There is a unnecessary return statement at the end of void function
cma_activate_area.  This can be dropped.

While at it, also fix another warning related to unsigned.
These are reported by checkpatch as well.

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
+unsigned cma_area_count;

WARNING: void function return statements are not generally useful
+       return;
+}

Link: https://lkml.kernel.org/r/20240927181637.19941-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-fix-useless-return-in-void-function
+++ a/mm/cma.c
@@ -32,7 +32,7 @@
 #include "cma.h"
 
 struct cma cma_areas[MAX_CMA_AREAS];
-unsigned cma_area_count;
+unsigned int cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
@@ -135,7 +135,6 @@ out_error:
 	totalcma_pages -= cma->count;
 	cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
-	return;
 }
 
 static int __init cma_init_reserved_areas(void)
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are

zsmalloc-replace-kmap_atomic-with-kmap_local_page.patch
mm-zsmalloc-use-memcpy_from-to_page-whereever-possible.patch

