Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B71EE7C6
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755919772; cv=none; b=fNyXr19bfjyuw+6zLwUEtye/Gt+j8lo10uT3YrqQ7eEqmJGALB4ULAbIB2VyWq+Nsjac22EhIEaS4NaC6ffPRUhMBvsjugCFaThR20M1pF0yIEbryo9NfEkwSKnmTAoxgKiUi1mjl+At1mYRs6Nfd61zbEo9N0EOz4BAoFdDOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755919772; c=relaxed/simple;
	bh=yPGsUGY2RdNwMVe+UH0kBFjCpQLuyQqMcbCngHGTbX8=;
	h=Date:To:From:Subject:Message-Id; b=FYF6mINnwSimxf0kM0jufFfF9xD7kS73ZUv93pQ122KvSFX5YimO0+TbGKpFI1HvvLKIvLbF2MI6X+4ABQ+HcYt6JXF74KHnGtTTLUUAFB043odlzt57S+MA6x+H/txR9j88wKugeWj+wvditbswukvwSNhLg+mVHL4M9O+9XaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jkd0GHim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jkd0GHim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB97C4CEED;
	Sat, 23 Aug 2025 03:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755919772;
	bh=yPGsUGY2RdNwMVe+UH0kBFjCpQLuyQqMcbCngHGTbX8=;
	h=Date:To:From:Subject:From;
	b=Jkd0GHimFjbMKrfFlwhzp/7pEPszaDFxowihhpIEaw8+fvaEubv2SwqhQ/2z/csf4
	 NDh/Z6yJGIE25U1Elw7dH4qwh66DMD59fX12QYnyxcw4L6fpzeOlg0wvQEt5pRIl+j
	 8k80BrYwUpxmRBwUqxFWobO3KepRMUiKNSKr0aFc=
Date: Fri, 22 Aug 2025 20:29:31 -0700
To: mm-commits@vger.kernel.org,martin.petersen@oracle.com,bostroesser@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch removed from -mm tree
Message-Id: <20250823032932.1BB97C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/target/target_core_user.c: use PAGES_TO_MB and MB_TO_PAGES
has been removed from the -mm tree.  Its filename was
     drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/target/target_core_user.c: use PAGES_TO_MB and MB_TO_PAGES
Date: Fri Aug 22 08:07:35 PM PDT 2025

Replace the custom TCMU_MBS_TO_PAGES and TCMU_PAGES_TO_MBS with the new
system-wide MB_TO_PAGES and PAGES_TO_MB.

Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/target/target_core_user.c |   30 +++++++++++++---------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/target/target_core_user.c~drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages
+++ a/drivers/target/target_core_user.c
@@ -15,6 +15,7 @@
 #include <linux/uio_driver.h>
 #include <linux/xarray.h>
 #include <linux/stringify.h>
+#include <linux/mm.h>
 #include <linux/bitops.h>
 #include <linux/highmem.h>
 #include <linux/configfs.h>
@@ -74,9 +75,6 @@
 #define DATA_PAGES_PER_BLK_DEF 1
 #define DATA_AREA_PAGES_DEF (256 * 1024)
 
-#define TCMU_MBS_TO_PAGES(_mbs) ((size_t)_mbs << (20 - PAGE_SHIFT))
-#define TCMU_PAGES_TO_MBS(_pages) (_pages >> (20 - PAGE_SHIFT))
-
 /*
  * Default number of global data blocks(512K * PAGE_SIZE)
  * when the unmap thread will be started.
@@ -240,7 +238,7 @@ static int tcmu_set_global_max_data_area
 		return -EINVAL;
 	}
 
-	tcmu_global_max_pages = TCMU_MBS_TO_PAGES(max_area_mb);
+	tcmu_global_max_pages = MB_TO_PAGES(max_area_mb);
 	if (atomic_read(&global_page_count) > tcmu_global_max_pages)
 		schedule_delayed_work(&tcmu_unmap_work, 0);
 	else
@@ -252,7 +250,7 @@ static int tcmu_set_global_max_data_area
 static int tcmu_get_global_max_data_area(char *buffer,
 					 const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%d\n", TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
+	return sprintf(buffer, "%d\n", PAGES_TO_MB(tcmu_global_max_pages));
 }
 
 static const struct kernel_param_ops tcmu_global_max_data_area_op = {
@@ -1620,7 +1618,7 @@ static struct se_device *tcmu_alloc_devi
 	udev->data_pages_per_blk = DATA_PAGES_PER_BLK_DEF;
 	udev->max_blocks = DATA_AREA_PAGES_DEF / udev->data_pages_per_blk;
 	udev->cmdr_size = CMDR_SIZE_DEF;
-	udev->data_area_mb = TCMU_PAGES_TO_MBS(DATA_AREA_PAGES_DEF);
+	udev->data_area_mb = PAGES_TO_MB(DATA_AREA_PAGES_DEF);
 
 	mutex_init(&udev->cmdr_lock);
 
@@ -2226,7 +2224,7 @@ static int tcmu_configure_device(struct
 	udev->mb_addr = mb;
 	udev->cmdr = (void *)mb + CMDR_OFF;
 	udev->data_off = udev->cmdr_size + CMDR_OFF;
-	data_size = TCMU_MBS_TO_PAGES(udev->data_area_mb) << PAGE_SHIFT;
+	data_size = MB_TO_PAGES(udev->data_area_mb) << PAGE_SHIFT;
 	udev->mmap_pages = (data_size + udev->cmdr_size + CMDR_OFF) >> PAGE_SHIFT;
 	udev->data_blk_size = udev->data_pages_per_blk * PAGE_SIZE;
 	udev->dbi_thresh = 0; /* Default in Idle state */
@@ -2477,14 +2475,14 @@ static int tcmu_set_max_blocks_param(str
 		pr_err("Invalid max_data_area %d.\n", val);
 		return -EINVAL;
 	}
-	if (val > TCMU_PAGES_TO_MBS(tcmu_global_max_pages)) {
+	if (val > PAGES_TO_MB(tcmu_global_max_pages)) {
 		pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
-		       val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
-		val = TCMU_PAGES_TO_MBS(tcmu_global_max_pages);
+		       val, PAGES_TO_MB(tcmu_global_max_pages));
+		val = PAGES_TO_MB(tcmu_global_max_pages);
 	}
-	if (TCMU_MBS_TO_PAGES(val) < pages_per_blk) {
+	if (MB_TO_PAGES(val) < pages_per_blk) {
 		pr_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%u pages).\n",
-		       val, TCMU_MBS_TO_PAGES(val), pages_per_blk);
+		       val, MB_TO_PAGES(val), pages_per_blk);
 		return -EINVAL;
 	}
 
@@ -2496,7 +2494,7 @@ static int tcmu_set_max_blocks_param(str
 	}
 
 	udev->data_area_mb = val;
-	udev->max_blocks = TCMU_MBS_TO_PAGES(val) / pages_per_blk;
+	udev->max_blocks = MB_TO_PAGES(val) / pages_per_blk;
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
@@ -2514,10 +2512,10 @@ static int tcmu_set_data_pages_per_blk(s
 		return ret;
 	}
 
-	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
+	if (val > MB_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
 		       val, udev->data_area_mb,
-		       TCMU_MBS_TO_PAGES(udev->data_area_mb));
+		       MB_TO_PAGES(udev->data_area_mb));
 		return -EINVAL;
 	}
 
@@ -2529,7 +2527,7 @@ static int tcmu_set_data_pages_per_blk(s
 	}
 
 	udev->data_pages_per_blk = val;
-	udev->max_blocks = TCMU_MBS_TO_PAGES(udev->data_area_mb) / val;
+	udev->max_blocks = MB_TO_PAGES(udev->data_area_mb) / val;
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

