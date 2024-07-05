Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D50F9C8
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141643; cv=none; b=MvVgkgU2+LrEiQ3mq85DB8ZLAeBMQ0/Xfxhs4OtgB5HmGGABkte+yMs0ojlEsuBKXmQI/triZzNtd9M8Jcu9w6kGAWUWbaObw1iHSU823z3EV4X8Yq2pGGOzhrXWuKRLZO5U3bwvXLEDHeQ+nscLAzDFJ3YLpbog9PTQUKwk8d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141643; c=relaxed/simple;
	bh=rQE/hBMKH0WTmwPXyzVynbn7l8Ie8pJw1Fyio57Brm0=;
	h=Date:To:From:Subject:Message-Id; b=omqw8CL5TrAVVGuGBBJa/EeS3FhWkVQJ7ayV81KTkmvONTF+6x5cyj5Jxvr3yaR4W0zVFjuNqPXeEMaRynWviYdfpGtcVBKBwiMtuL3JQZWST8+KJRilcbgfhyq440C9fExAMCYakVK+qQrNrpucaeh768SSsbsuMgWnei8mVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHmsmv1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHmsmv1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E01FC3277B;
	Fri,  5 Jul 2024 01:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141643;
	bh=rQE/hBMKH0WTmwPXyzVynbn7l8Ie8pJw1Fyio57Brm0=;
	h=Date:To:From:Subject:From;
	b=UHmsmv1J6zsevWuOCVzHDRbiyJb0TPt1YT/9d/qIHfsXQZ1LUfa3sQg+50S/akWsr
	 XUdfJDr7qsNB63hgAAk9cwwNo0yf35/ec5A782RJjHUNUOnJhy8dEu8fndiQ/a5ZXr
	 Unm73DMIkbmN/KCi46ePhjTwt1ZMpkWykEfn3Vak=
Date: Thu, 04 Jul 2024 18:07:23 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-add-enable_soft_offline-sysctl.patch removed from -mm tree
Message-Id: <20240705010723.9E01FC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: mm: add enable_soft_offline sysctl
has been removed from the -mm tree.  Its filename was
     docs-mm-add-enable_soft_offline-sysctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs: mm: add enable_soft_offline sysctl
Date: Wed, 26 Jun 2024 05:08:18 +0000

Add the documentation for soft offline behaviors / costs, and what the new
enable_soft_offline sysctl is for.

[jiaqiyan@google.com: fix kerneldoc warnings]
  Link: https://lkml.kernel.org/r/CACw3F52=GxTCDw-PqFh3-GDM-fo3GbhGdu0hedxYXOTT4TQSTg@mail.gmail.com
[jiaqiyan@google.com: there are more blank lines needed]
  Link: https://lkml.kernel.org/r/CACw3F52_obAB742XeDRNun4BHBYtrxtbvp5NkUincXdaob0j1g@mail.gmail.com
Link: https://lkml.kernel.org/r/20240626050818.2277273-5-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -36,6 +36,7 @@ Currently, these files are in /proc/sys/
 - dirtytime_expire_seconds
 - dirty_writeback_centisecs
 - drop_caches
+- enable_soft_offline
 - extfrag_threshold
 - highmem_is_dirtyable
 - hugetlb_shm_group
@@ -267,6 +268,43 @@ used::
 These are informational only.  They do not mean that anything is wrong
 with your system.  To disable them, echo 4 (bit 2) into drop_caches.
 
+enable_soft_offline
+===================
+Correctable memory errors are very common on servers. Soft-offline is kernel's
+solution for memory pages having (excessive) corrected memory errors.
+
+For different types of page, soft-offline has different behaviors / costs.
+
+- For a raw error page, soft-offline migrates the in-use page's content to
+  a new raw page.
+
+- For a page that is part of a transparent hugepage, soft-offline splits the
+  transparent hugepage into raw pages, then migrates only the raw error page.
+  As a result, user is transparently backed by 1 less hugepage, impacting
+  memory access performance.
+
+- For a page that is part of a HugeTLB hugepage, soft-offline first migrates
+  the entire HugeTLB hugepage, during which a free hugepage will be consumed
+  as migration target.  Then the original hugepage is dissolved into raw
+  pages without compensation, reducing the capacity of the HugeTLB pool by 1.
+
+It is user's call to choose between reliability (staying away from fragile
+physical memory) vs performance / capacity implications in transparent and
+HugeTLB cases.
+
+For all architectures, enable_soft_offline controls whether to soft offline
+memory pages.  When set to 1, kernel attempts to soft offline the pages
+whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
+the request to soft offline the pages.  Its default value is 1.
+
+It is worth mentioning that after setting enable_soft_offline to 0, the
+following requests to soft offline pages will not be performed:
+
+- Request to soft offline pages from RAS Correctable Errors Collector.
+
+- On ARM, the request to soft offline pages from GHES driver.
+
+- On PARISC, the request to soft offline pages from Page Deallocation Table.
 
 extfrag_threshold
 =================
_

Patches currently in -mm which might be from jiaqiyan@google.com are


