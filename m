Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE751552E3
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 04:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738124155; cv=none; b=C7Qt1q1U9c1EvFz7whmAN0/W+zgQPyn3WPiHUzhuD7q6eHP885bDHTkG36F0749GhPp3amHoQoKDnFXpWOjw1RFhYs0rMPgPCUiADD79qcekAw4+gqF3Mrx0+5IqnC5ZKriwZRPaFmU0G2w7yeaa9d130sh3IqS3ltRT1KuAXYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738124155; c=relaxed/simple;
	bh=NOWjLys1RN3poY1KoDuhx4UQ7a7ww1GBdSyGlzLw2ug=;
	h=Date:To:From:Subject:Message-Id; b=IYZi5eni1fhmYRCpHcnDUjrK8HCEY7J6+4zl9ipobOf7SFJ90YfauXgQOCVi47MnwwVA2eQolO0Uez0TDiRLS/rMZvojdyxKGTGdSk5FcDCo1aW1zA7fsuu0JuQVoOXEC+jrvYqG3TgxKsgjSzPdRegplBT7Tc81Y8Q2BySExSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifIHJIFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifIHJIFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40A7C4CED3;
	Wed, 29 Jan 2025 04:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738124154;
	bh=NOWjLys1RN3poY1KoDuhx4UQ7a7ww1GBdSyGlzLw2ug=;
	h=Date:To:From:Subject:From;
	b=ifIHJIFYBBnP5aSf2aeiBAkXM3K2O6tIwDNn0eetrGdGXy3w2CTrhIUyAGQOrHxi8
	 VhJviuI3rWMgiMbafe5FMDPnhyoi+Rp/wvo9O3/O2e6xY5bc6+MhJaCCpnSHAqjXSL
	 MkxrzCBE59WbEARobjsNBIHYM5qX0ycofAOQzarc=
Date: Tue, 28 Jan 2025 20:15:54 -0800
To: mm-commits@vger.kernel.org,zhanghao1@kylinos.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch added to mm-unstable branch
Message-Id: <20250129041554.A40A7C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
Date: Tue Jan 28 08:13:57 PM PST 2025

80-col wrapping

Cc: Hao Zhang <zhanghao1@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
+++ a/mm/vmscan.c
@@ -2400,8 +2400,8 @@ static void prepare_scan_control(pg_data
 	}
 }
 
-static inline void calculate_pressure_balance(struct scan_control *sc, int swappiness,
-			u64 *fraction, u64 *denominator)
+static inline void calculate_pressure_balance(struct scan_control *sc,
+			int swappiness, u64 *fraction, u64 *denominator)
 {
 	unsigned long anon_cost, file_cost, total_cost;
 	unsigned long ap, fp;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

