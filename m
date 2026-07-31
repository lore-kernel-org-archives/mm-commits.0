Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB253290C2
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465701; cv=none; b=isMcXn5vb7wko9Pw7KTf4b9MoEMEGxz08rgkDjHvNm+H8pDiBHXFj3Zcc/rxMBOnHxVALPW1IjmGr6e8z3uL0R+olNpxrbJACUf+bSJpgaGA1qjbjZ+KqW5owXDbjN8xcLrSvc9DSMqO05BSGKd+8omD9QfBRv7q2hXNwzze/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465701; c=relaxed/simple;
	bh=J/mrlNgLVYJhx9QgcGeagAw1ZnB72el5CotU/rWDc6I=;
	h=Date:To:From:Subject:Message-Id; b=Yg/D/ruqlOVRGoKI8JcWMYF00lCRCRc72ifbvFGzE77Tjb/LvK8o90/6fKjcj1C7H8hNnus+7O1oWHDPa05B/UlpNgBp5EWQvbhMRtPqPG9T7zhz4b2TadKg5F3mGSlonPeOOZQ8Gk0stj4eg8lBiHSY2wlwxgGNuX/AhGrbhbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MOPZ5lYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MOPZ5lYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5B41F00A3A;
	Fri, 31 Jul 2026 02:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465700;
	bh=xFoR+KLdode08aqf2obo3TwgBBMD9s/p6cxKT/x9oR0=;
	h=Date:To:From:Subject;
	b=MOPZ5lYgKQcWtQAXt8jq654AXzo84l+ajmZukN1NOkDlx7stgOowa8iaO4zJbcR8T
	 HNxIhp5SSifrXJ6pD3DV5YDiS0zwqAvLEH9sCezzuzxtMC1j8jyhVtu41568J04ble
	 dKzllSxDA8QmJLcG4n4+frBDi5jA17qC9WMSmojA=
Date: Thu, 30 Jul 2026 19:41:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-fix-typos-in-kconfig-help-text.patch removed from -mm tree
Message-Id: <20260731024140.4B5B41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: fix typos in Kconfig help text
has been removed from the -mm tree.  Its filename was
     samples-damon-fix-typos-in-kconfig-help-text.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: samples/damon: fix typos in Kconfig help text
Date: Mon, 29 Jun 2026 07:55:35 -0700

Fix a couple  of typos in samples/damon/Kconfig help text. Change "Thps"
to "This", and "tierign" to "tiering".

Link: https://lore.kernel.org/20260629145538.134832-5-sj@kernel.org
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/damon/Kconfig~samples-damon-fix-typos-in-kconfig-help-text
+++ a/samples/damon/Kconfig
@@ -31,7 +31,7 @@ config SAMPLE_DAMON_MTIER
 	bool "DAMON sample module for memory tiering"
 	depends on DAMON && DAMON_PADDR
 	help
-	  Thps builds DAMON sample module for memory tierign.
+	  This builds DAMON sample module for memory tiering.
 
 	  The module assumes the system is constructed with two NUMA nodes,
 	  which seems as local and remote nodes to all CPUs.  For example,
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are


