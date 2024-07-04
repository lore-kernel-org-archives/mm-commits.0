Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF605339E
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136793; cv=none; b=O/vY1Ki6CVKGieE8UEytc8pnosqiO/1fNp0RcZ0e0q5SzTUunKYrDEhoCMzWNHOl4JxXiZbYADTxpg7IV976sUV6V7beo8vQaiofXx7nkeGGS6lZTG7JkwrtFMmuPf7PANldIaBTiYu/ZXkPWxtOjjNkkGzYDycbLakWwHMZwmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136793; c=relaxed/simple;
	bh=AhfwktnOboRMCV3tmyZAIm9X5nGB7ZwdercJVtuDSvw=;
	h=Date:To:From:Subject:Message-Id; b=isq8BHBY2iHUyQL1irmRKy6N1ZN8tvWPdxaVHoca+LbmxrvZgICIzQYlhEVOVDAdQ3bcCKuSdaumv8e3Zpmap/jnhXZcY8XBDiAm6iDkKPwbFKmVZI1igDJzllgAiibAao3hHTi/ixTUFMURvjP2kkh2e8DfTJ2Hd09GdKO1GP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJNrgOT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJNrgOT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E7DC3277B;
	Thu,  4 Jul 2024 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136793;
	bh=AhfwktnOboRMCV3tmyZAIm9X5nGB7ZwdercJVtuDSvw=;
	h=Date:To:From:Subject:From;
	b=dJNrgOT6+eLzeuk60yOqegdMdo7sonKA4wDJ2sokM0H68uWyWFtWLQByLXygZnGON
	 cO2lMS1eHG1ZsmQXQPBkQUklmGO9pOLq5os5ROTfhw9OfUlnUADQr8yMLyIYODjjUE
	 bSTOIhIE6yl5Cra99y2mmzLWP2MOsDlirWc2FLW4=
Date: Thu, 04 Jul 2024 16:46:32 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch removed from -mm tree
Message-Id: <20240704234633.18E7DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v7
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch

This patch was dropped because it was folded into mm-memory-failure-userspace-controls-soft-offlining-pages.patch

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v7
Date: Fri, 28 Jun 2024 20:59:56 +0000

Link: https://lkml.kernel.org/r/20240628205958.2845610-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-userspace-controls-soft-offlining-pages-v7
+++ a/mm/memory-failure.c
@@ -2808,8 +2808,7 @@ int soft_offline_page(unsigned long pfn,
 	}
 
 	if (!sysctl_enable_soft_offline) {
-		pr_info_once("%#lx: disabled by /proc/sys/vm/enable_soft_offline\n",
-			pfn);
+		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch
docs-mm-add-enable_soft_offline-sysctl-fix.patch
docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

