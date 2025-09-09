Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE91303A24
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400230; cv=none; b=VfyEE5YRGV8sU2gt/YZajRFipLKNmTYj5yzrip7Z2nvKm88706KVSPMcNYE6guKhZaQzZ2rVHuOuSVAHaFTVDsGpvHaLFplu9LWfVgwXgFY+52pJUemLynUU1L1t/EZ0rf9dzmOACl/ZkeusXZN4Z9zJ7y0EaY8xWfFzQHB1hl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400230; c=relaxed/simple;
	bh=rpaPe1lTFXm0TGAnhdh9akqJxWL138C0p20cvtR/o2c=;
	h=Date:To:From:Subject:Message-Id; b=RMrRymrPwt7Vg9M8HDEVmN+v3vHSzDvwYdEkGQIimPgL97Ow8smSwvf7FNRGFZxOUE7Q0wJq1q2rTgRTnTBW3mYQXwUJnEzwMRjUSxnzdq9dvBJs3Fdw5oKcNomNARZwweM3Ss0mFMBQwfPWumFHXhUK9Um32Un7DlnJgkt1+Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aA1R08HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aA1R08HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0585AC4CEF4;
	Tue,  9 Sep 2025 06:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400230;
	bh=rpaPe1lTFXm0TGAnhdh9akqJxWL138C0p20cvtR/o2c=;
	h=Date:To:From:Subject:From;
	b=aA1R08HFxzyP9mjfG+mb0sE6reX9FTxYqjj01AOLCrFug8udFXoLyfcBfCMSwTam9
	 9q+gpkOu7+X1cuNE9gm7Z8kp9/lDwuP55iPJk1V6+4P1S0fm+KT611GFI/k1L4471/
	 62+BMPjbC3jSf3534wKXDk9+MuKCSImSF8vG+alQ=
Date: Mon, 08 Sep 2025 23:43:49 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bhe@redhat.com,vdumitrescu@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] percpu-fix-race-on-alloc-failed-warning-limit-v2.patch removed from -mm tree
Message-Id: <20250909064350.0585AC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu-fix-race-on-alloc-failed-warning-limit-v2
has been removed from the -mm tree.  Its filename was
     percpu-fix-race-on-alloc-failed-warning-limit-v2.patch

This patch was dropped because it was folded into percpu-fix-race-on-alloc-failed-warning-limit.patch

------------------------------------------------------
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: percpu-fix-race-on-alloc-failed-warning-limit-v2
Date: Fri, 5 Sep 2025 15:42:14 -0700

prevent warn_limit from going negative, per Christoph Lameter

Link: https://lkml.kernel.org/r/ee87cc59-2717-4dbb-8052-1d2692c5aaaa@nvidia.com
Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~percpu-fix-race-on-alloc-failed-warning-limit-v2
+++ a/mm/percpu.c
@@ -1904,8 +1904,8 @@ fail_unlock:
 fail:
 	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
 
-	if (do_warn && atomic_read(&warn_limit) > 0) {
-		int remaining = atomic_dec_return(&warn_limit);
+	if (do_warn) {
+		int remaining = atomic_dec_if_positive(&warn_limit);
 
 		if (remaining >= 0) {
 			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
_

Patches currently in -mm which might be from vdumitrescu@nvidia.com are

percpu-fix-race-on-alloc-failed-warning-limit.patch

