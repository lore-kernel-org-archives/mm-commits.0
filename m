Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F2060DE1;
	Wed, 13 Mar 2024 19:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710357184; cv=none; b=oArDw00SOhgo3wpN9I5bowgatwXl9sVgQ4cEYKZFwbaR+Lxw/7T90+QIeVWbgSHJXOv6tdT+NRLtCgLfECyxHCgEGXdhMWYiBuzl9Nyc62+BvfrhJAn7faIbp4vHqxoawQXc/bzieIuMhhCnnprY5dW5XeAvw8U0F9//QryEni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710357184; c=relaxed/simple;
	bh=VRP1BUIHUrm0aj0yZUmJflJJDyQvlK0xH3dChfMn6xw=;
	h=Date:To:From:Subject:Message-Id; b=O8EpOh/HBYTHOXdgxSE+T2p4FhGcF8qT2nc2bFVNnEv0JcrgRiA+eRNmwg/EAuDCFpBnpajPeOAlfLdt/caZNXz8+FFlmYiPVDhYmKI2BmteNiVV3kdS8oB9rQ+cMwPmxoJHqof9vItGhsc2N/eL2q3Ck9nkqTmwdnIEBQh25JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKrwLGtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKrwLGtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB00C433C7;
	Wed, 13 Mar 2024 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710357184;
	bh=VRP1BUIHUrm0aj0yZUmJflJJDyQvlK0xH3dChfMn6xw=;
	h=Date:To:From:Subject:From;
	b=IKrwLGtlrHzC2iQ8eDz++GgUnU1uBeKmuAtG4O5AmMURP/KyVw0fPoKo4ylI1No5+
	 Zpz95g6kCqRDMcMJwkV8/HM7Gdndv40EjrXm1+ZxGIXRr9WtLyW/MwTMx429mEqfOY
	 unoFzCl5h5kRLlTnVFzISqarvYtEXBQNgvuuVccU=
Date: Wed, 13 Mar 2024 12:13:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,qiang4.zhang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memtest-use-readwrite_once-in-memory-scanning.patch removed from -mm tree
Message-Id: <20240313191304.5DB00C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memtest: use {READ,WRITE}_ONCE in memory scanning
has been removed from the -mm tree.  Its filename was
     memtest-use-readwrite_once-in-memory-scanning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiang Zhang <qiang4.zhang@intel.com>
Subject: memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Tue, 12 Mar 2024 16:04:23 +0800

memtest failed to find bad memory when compiled with clang.  So use
{WRITE,READ}_ONCE to access memory to avoid compiler over optimization.

Link: https://lkml.kernel.org/r/20240312080422.691222-1-qiang4.zhang@intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memtest.c~memtest-use-readwrite_once-in-memory-scanning
+++ a/mm/memtest.c
@@ -51,10 +51,10 @@ static void __init memtest(u64 pattern,
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
-		*p = pattern;
+		WRITE_ONCE(*p, pattern);
 
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
+		if (READ_ONCE(*p) == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
_

Patches currently in -mm which might be from qiang4.zhang@intel.com are


