Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC507371CF8
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028764; cv=none; b=f+JIlwzxuZl0tCIWoRq0rsWpb+jlWu/Dko/m7w6svsGraz3RNWgWLdTiGHITdRmEhhUFtVSkL02j08nfOSyxXLPIR3pYDLzIZ1BdZUppsshkHaVLKR/LrOV9DUkfgYHxW9vliTWIT8/eInq7JSXmcjjIMsiLOgd2YziLcp3dgGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028764; c=relaxed/simple;
	bh=CN6VHmEcOf1wlQC8HszWp/osaltzkyUA6nwCYG1H0Gw=;
	h=Date:To:From:Subject:Message-Id; b=AqSZgrXNM4FdTPslwt5L2vmSVqLxbYw+HNkhQun5WQOTOLorQOFDpcOGpwNgifKr2L7sjIC8FQEZBR1ErIM9zluG3mtcihABM8OcoiUMzeW3Ho7vMCQXLl3QkATNnI2LzoUCyDT7oPzzDZQ7wkXfk0Yp40eUk4cS6L2/ClmE+XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y7D1HlbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y7D1HlbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32EF1F00899;
	Fri, 29 May 2026 04:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028763;
	bh=3ygBK38xAvpSZuf7SYOxEysm6hg+DurEO3Yc6TCw4rs=;
	h=Date:To:From:Subject;
	b=Y7D1HlbQ8PCqhYoPA1Nrnkb0QhssB4/8gN4+65HEQnA/PSSlPSfOp1JXeVOVnr6Rj
	 0oixAmt3Gj8Ln4afI/Okz0yR9m6YJxctmlBUfnk2YZRl3lL+8Wv3yUMKZAFACMZq7N
	 rurbInBjoEVyYFGkwwg8aKezFySi89GVJvM50I+Y=
Date: Thu, 28 May 2026 21:26:03 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,pimyn@google.com,gthelen@google.com,elver@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch removed from -mm tree
Message-Id: <20260529042603.A32EF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfence: fix KASAN HW tags bypass via runtime sample_interval change
has been removed from the -mm tree.  Its filename was
     kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kfence: fix KASAN HW tags bypass via runtime sample_interval change
Date: Thu, 7 May 2026 11:52:37 +0200

If a user writes a non-zero value to the sample_interval module parameter
at runtime, the missing KASAN HW tags check in the late init path allows
KFENCE to be enabled alongside KASAN HW tags, bypassing the boot
restriction.

This patch adds the missing check to param_set_sample_interval() to reject
the parameter change if KASAN HW tags are enabled.

Link: https://lore.kernel.org/20260507095237.741017-1-glider@google.com
Fixes: 09833d99db36 ("mm/kfence: disable KFENCE upon KASAN HW tags enablement")
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Pimyn Girgis <pimyn@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kfence/core.c~kfence-fix-kasan-hw-tags-bypass-via-runtime-sample_interval-change
+++ a/mm/kfence/core.c
@@ -77,6 +77,11 @@ static int param_set_sample_interval(con
 		WRITE_ONCE(kfence_enabled, false);
 	}
 
+	if (num && kasan_hw_tags_enabled()) {
+		pr_info("disabled as KASAN HW tags are enabled\n");
+		return -EINVAL;
+	}
+
 	*((unsigned long *)kp->arg) = num;
 
 	if (num && !READ_ONCE(kfence_enabled) && system_state != SYSTEM_BOOTING)
_

Patches currently in -mm which might be from glider@google.com are

lib-test_meminit-use-for-bools.patch

