Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1031317C7B6
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277491; cv=none; b=m+eUxA2pXf8p+IFPIqO8bA57ii5FHrOQLivYBqVqpZEGju1C4E/APqttEKAzMwk2Uvakdadw3BJQG2LVIhsEnCyIcs5Og9xtHxKGEqiSyzG532/MofldzAEgcXWGPCBxB+kZtBJxme8QOqcfeRegtaSDczO01N7rzde64QKR5x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277491; c=relaxed/simple;
	bh=v9JU0mAwkDowSTBXj9WKz9hR8iOOLhlVHmJpPr7/E98=;
	h=Date:To:From:Subject:Message-Id; b=HSXJGIzyhUP+sR4PupZm0dDCcT6QcAZ6Fa8PkMADRFBZITtNvwWVMPUn4BBFySL6D4a70g1D1RJ8AgsZWvSTh5CI/5Xp76wHpQVQ5dPScWlmO8DA3qydBh4tdJpKcaP+1P6NnZ/zzd7YV0gOzIN/pSulRE5Yl5GxLBb3aRfBb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p5AbMBmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p5AbMBmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F54BC4AF0E;
	Wed, 21 Aug 2024 21:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724277490;
	bh=v9JU0mAwkDowSTBXj9WKz9hR8iOOLhlVHmJpPr7/E98=;
	h=Date:To:From:Subject:From;
	b=p5AbMBmcpd4V2AC3FMAIDN8rVb9AFCfuPFFALIFryie7rIK89czccu2lQgv8OncQw
	 rKXzVeMh95RmT7Ub0odOuYtajfXJhQZPYwyQS3EN3D4S32/H5YM/j+APZmAgF5KRg6
	 oDe4w/xMvNNg3xtEU6EEhAA8WrOlt3oCAbK2ECEw=
Date: Wed, 21 Aug 2024 14:58:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@Huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch added to mm-unstable branch
Message-Id: <20240821215810.7F54BC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch

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
Subject: mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix
Date: Wed Aug 21 02:56:38 PM PDT 2024

s/unmap_posioned_folio/unmap_poisoned_folio/

Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix
+++ a/mm/memory_hotplug.c
@@ -1808,7 +1808,7 @@ static void do_migrate_range(unsigned lo
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				unmap_posioned_folio(folio, TTU_IGNORE_MLOCK);
+				unmap_poisoned_folio(folio, TTU_IGNORE_MLOCK);
 			continue;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
mm-memory-failure-add-unmap_posioned_folio-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

