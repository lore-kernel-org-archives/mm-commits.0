Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852484A24
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 00:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738282973; cv=none; b=f0GKwk9oGvAmhzC24JWKYnkXpfuzaO8MriSzpbR9YfCCnIdJfyWkqMBq3aMIvIRHTVNa26JLYKQ9RRhZXQZW4yN1E2TXMts3RaKz2zllWZu9esJsPFydURu55ufMgMchRoPQlC141+HT5V4wbj10pp8Fti2FwUULAsueqMZxd7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738282973; c=relaxed/simple;
	bh=4leH9AyMsNCP0w/dCoNNyqekjv6icWqJpKDeGRwLNeY=;
	h=Date:To:From:Subject:Message-Id; b=XLW35ekFXitXsZ/hmzKYnYaBQIeEU2HFdbJYtWFTXSoX5lh9wDQAO9CNNLsid/C5+AoOfsM28wznm2HUsm/5IlEpxfmJbLXqQEYwWF0tMfPbAA0seN1qNxeh1rht2LdEUPgBXJWOor3cYW4guT2LKDtLLNU458DFVWs1VhWF/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yoansWpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yoansWpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF353C4CED2;
	Fri, 31 Jan 2025 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738282973;
	bh=4leH9AyMsNCP0w/dCoNNyqekjv6icWqJpKDeGRwLNeY=;
	h=Date:To:From:Subject:From;
	b=yoansWpciPOYH9rXgB7I12FVyzN/5rgEIJKS+LNp2l6o9lh11RkASSrbwDOTe2Lj8
	 zCDe4GmwB95Vnz6jsF85fHPmkzAUZ0LuwyguAD/lH/5rbar/27KuWXwl05iGecnd5q
	 w8TULmt29peG7fNZjtm3uHFnRzatGNuuZtJEiQ2k=
Date: Thu, 30 Jan 2025 16:22:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tamird@gmail.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,geert@linux-m68k.org,davidgow@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-include-linux-mm-for-xarray-maintenance.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131002252.EF353C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: include linux-mm for xarray maintenance
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-include-linux-mm-for-xarray-maintenance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-include-linux-mm-for-xarray-maintenance.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: include linux-mm for xarray maintenance
Date: Thu Jan 30 04:16:20 PM PST 2025

MM developers have an interest in the xarray code.
Cc: David Gow <davidgow@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-include-linux-mm-for-xarray-maintenance
+++ a/MAINTAINERS
@@ -25676,6 +25676,7 @@ F:	arch/x86/entry/vdso/
 XARRAY
 M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-xarray-port-tests-to-kunit.patch
maintainers-include-linux-mm-for-xarray-maintenance.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes.patch
xfs-convert-timeouts-to-secs_to_jiffies-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

