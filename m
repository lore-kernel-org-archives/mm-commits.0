Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393235;
	b=hJ7Bt8yydfId1jyw9PJ6qHoeCWogkxvCe6YyXjoyfwOXhqZUsczCP60HN65O0UMGL5il
	 ex8FmIzfmFViHfTuFlEScXTDDTxBTGfDzolOWxd/lw+Nd2LnWn1pDt088Ltbo2YEIlbQ1
	 VJ9R41LTueGMtTBD/3DlqAR7Qn5YXbz659vuOzExc2zQxoG//z2I6wAa8qs94FjNQ4Mvl
	 FBLGUte+opRp2dJNX9ZvJ3dG3kXMpURwV44E/3qZ4V17x9HFvN4PS6s6bi6NdbXUEK8Kf
	 lEYkc2X54u9Ts9qJXuocJZ9SNQfycjdF/C7be42vPNEHkNQai/ZYeo5SYTO3Xt4gvQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393235;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iDNazijM5Rq0AkAOtdYod7WO+dX+J9GsGiIoKo8L6HU=;
	b=lh9TsplRXg5KpwdMbjG86q/zMHGKPaAFMpgF17nD9vilBxfcZJbK16n9ouQCWaxyA5Hy
	 lvESs/ccWWY2l+T/bYwtDnRIX28rt3510dzOPMoxfC9DaMX1o63urLgAN9RUGZIQWbIUC
	 oGxZQU5CHvWgsSDFXpxrE9Qo20djmj63tIKY/lPcj89vaRnHHKA377eMDxuT3jj4kiuDD
	 OXpdLC7R6fLhvuwexp10J53t44wCjd7Ol+Z5npPVCI8rGsTz3edDfQYi+TYhU8ZCEegZq
	 meVNSOq9MtjSVzJ440ukWbic7XGU/ZzuKrtUU3DpMgBG/usre8Ytti3/UU8I92EoDMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fLHnBNUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CE6606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 20:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fLHnBNUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE911F000C1;
	Fri, 30 Oct 2026 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793393234;
	bh=iDNazijM5Rq0AkAOtdYod7WO+dX+J9GsGiIoKo8L6HU=;
	h=Date:To:From:Subject;
	b=fLHnBNUEfNibEcM7gTXzTgJvbqibWG4skiD0C97hdWM+0iw+oNsYT6yGMt9I7fnGP
	 M5g4hQbixdbixtLbe5FLPLoL/EbwZcYBjm277wBxVSoByEJ40L6Qgdh4M/wFfp19kl
	 WJtEut/+xRSSz85HLg9wIn8Z9Q2VD5xF+P2AAQQM=
Date: Fri, 30 Oct 2026 13:47:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,
	muchun.song@linux.dev,enze.li@gmx.com,david@kernel.org,lienze@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-remove-two-unused-include-files.patch added to mm-new branch
Message-Id: <20261030204714.2AE911F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_cma: remove two unused include files
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-remove-two-unused-include-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-remove-two-unused-include-files.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb_cma: remove two unused include files
Date: Mon, 05 Oct 2026 22:20:40 +0800

hugetlb_cma.c includes <linux/mm_inline.h> and <asm/setup.h> but never
uses anything from them, so they can be dropped.

Found with clang-tidy (misc-include-cleaner).  This holds regardless of
config: the file's only #ifdef is CONFIG_NUMA, and it only touches
memblock helpers, so removing these is safe on all arches.

Link: https://lore.kernel.org/20261005142040.675204-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Enze Li <enze.li@gmx.com>
---

 mm/hugetlb_cma.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-remove-two-unused-include-files
+++ a/mm/hugetlb_cma.c
@@ -4,10 +4,8 @@
 #include <linux/cma.h>
 #include <linux/compiler.h>
 #include <linux/cpuset.h>
-#include <linux/mm_inline.h>
 
 #include <asm/page.h>
-#include <asm/setup.h>
 
 #include <linux/hugetlb.h>
 #include <linux/memblock.h>
_

Patches currently in -mm which might be from lienze@kylinos.cn are

docs-hugetlbpagerst-clarify-hugepages_total-in-hugetlbpagerst.patch
mm-hugetlb-drop-unused-mm-parameter-from-unmap_ref_private.patch
mm-hugetlb_cma-remove-two-unused-include-files.patch

