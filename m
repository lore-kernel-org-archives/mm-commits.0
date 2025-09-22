Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4E226FDAC
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 21:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758575970; cv=none; b=LK9Pd/saiKNa2DzmWvDLIBBnKwpkUEXSC/fFS7I2pm9oMsN4XoMBfVRfOicIgPSSdWs0C5chYIK1xeEWHyYyJSTHU3QW8jRZrz7uw7DeaH4phsALN83vEPKir72ejdy6l+gd+SacGFg7a+Hu6Mze1HZoJjl0UU8g4N/PTlEeVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758575970; c=relaxed/simple;
	bh=fio63SV5PPXW+wEo2FIxStB1t90FuZ4YPUnVwEPu4VM=;
	h=Date:To:From:Subject:Message-Id; b=l2+WDGOyojkFWh/mTiarEPIrr4Qbq785i7mC+l+4QSgJIsrvjJdWk6B0AJ8vu9qSx4KK9mLCt7HoPfFO6N3T6w5U4c/OzOSSpS37U2bBQIxccYsmMuGcaggO1eMytjEOJ82SeQIjEphNSxWJYNPjX7z0X64Dgc7WHbpQpdr6jTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ms6ViqaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ms6ViqaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94AAC4CEF0;
	Mon, 22 Sep 2025 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758575970;
	bh=fio63SV5PPXW+wEo2FIxStB1t90FuZ4YPUnVwEPu4VM=;
	h=Date:To:From:Subject:From;
	b=Ms6ViqaUnhYI7+L/g6PHAYfbuok0zQujXEunQ4TKfd7hpnI/0IX2Z82ybByVpt3xV
	 DnuMKYU51gIgnan1l65T5UiO5D+22MOHXYICjMRohT08R0lvxo5GjxSSmctUkCfOiD
	 MMs7P77YpCUCf4hS6f4YqCVylqyPlRgUD+I8hjAg=
Date: Mon, 22 Sep 2025 14:19:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,david@redhat.com,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-not-select-memory_isolation.patch added to mm-new branch
Message-Id: <20250922211929.D94AAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: don't select MEMORY_ISOLATION
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-not-select-memory_isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-not-select-memory_isolation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: mm/memory-failure: don't select MEMORY_ISOLATION
Date: Mon, 22 Sep 2025 22:36:18 +0800

We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
factor out memory isolate functions").  However, in commit add05cecef80
("mm: soft-offline: don't free target page in successful page migration")
we remove the need for it, where we removed the calls to
set_migratetype_isolate() etc.

What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
support.  But that comes with CONFIG_MIGRATION.  And
isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.

Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.

Link: https://lkml.kernel.org/r/20250922143618.48640-1-xieyuanbin1@huawei.com
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-memory-failure-not-select-memory_isolation
+++ a/mm/Kconfig
@@ -748,7 +748,6 @@ config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select MEMORY_ISOLATION
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
_

Patches currently in -mm which might be from xieyuanbin1@huawei.com are

mm-memory-failure-not-select-memory_isolation.patch

