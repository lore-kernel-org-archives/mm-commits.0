Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630DD47F4A
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 23:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859021; cv=none; b=u2kzspih7k6wSPHOm495VyCTNHCykMvlZfXf7Wpscg1b6stL+z9pJpUe0AKl4aVFIHMcDTpzr0l2U001Vaf9py+2O6BS5YfSF07QNX1MlZSW6JUoGO+2YYCwaKe5HQ1GvTVKjrkQiH09iSgXDvDg2QQcOTdLLcNLjkqYObHKCEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859021; c=relaxed/simple;
	bh=kmIHm4pe/79eg29Dcaf+UWftEzCYMvZpB1xZ3BkuY1Y=;
	h=Date:To:From:Subject:Message-Id; b=Kh/oL7cAuzA3xElKg2X/TUFmsQK5CfKm+seDgPzQrJsm9xbob0Oov76i7agjthhzxdzHXSqXIQEDtA8+A2Gc+EzRnDLRnfhE9J2YHM0W/tA/BKr646YM3/iZWdt/QTQew/Ysd0Hu14aO442cLWZv4D8Nr3nEh4+vm9S16H/E9k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1BJNakk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1BJNakk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114C3C4CEE3;
	Fri, 13 Jun 2025 23:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749859021;
	bh=kmIHm4pe/79eg29Dcaf+UWftEzCYMvZpB1xZ3BkuY1Y=;
	h=Date:To:From:Subject:From;
	b=p1BJNakkkr1s7xEIe7IKsFt+RzCAWXXjWUG9e1y0JKWFZz/UGNchVhhbZwZXBvrzk
	 HC+R+NOWKPWiBlJ3JLPNC5B/n/8QH16NIFn+PG8OxLbAm+JSxDN89kkc/q/0ak3nBU
	 vA5LAeOB+zvoT51OfyVupGGF0bCy3pB97q5SGWAM=
Date: Fri, 13 Jun 2025 16:57:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-linux-mm-list-to-kexec-handover.patch added to mm-hotfixes-unstable branch
Message-Id: <20250613235701.114C3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add linux-mm@ list to Kexec Handover
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-linux-mm-list-to-kexec-handover.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-linux-mm-list-to-kexec-handover.patch

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
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: MAINTAINERS: add linux-mm@ list to Kexec Handover
Date: Fri, 13 Jun 2025 15:19:14 +0200

Along with kexec, KHO also has parts dealing with memory management, like
page/folio initialization, memblock, and preserving/unpreserving memory
for next kernel.  Copy linux-mm@ to KHO patches so the right set of eyes
can look at changes to those parts.

Link: https://lkml.kernel.org/r/20250613131917.4488-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-linux-mm-list-to-kexec-handover
+++ a/MAINTAINERS
@@ -13345,6 +13345,7 @@ M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
 L:	kexec@lists.infradead.org
+L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
_

Patches currently in -mm which might be from ptyadav@amazon.de are

maintainers-add-linux-mm-list-to-kexec-handover.patch
kho-initialize-tail-pages-for-higher-order-folios-properly.patch

