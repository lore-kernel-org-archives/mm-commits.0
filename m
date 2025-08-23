Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979113E41A
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 03:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755918766; cv=none; b=ARssfvVuVGJi5wzGUca9tKE7aVs7qkQuEcpM8APBKPpJjCeJV5ahEsLQnN1mBk2yFaq5DarFQ+A7MXphN0C/uRA7YMAP9/RITZCrov8U5iW5Wh/93yYF+eklSL4QlEhFsRL9qF1nCeFuhBypDMFUClKxbxJ+b9L8EigUrL03LcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755918766; c=relaxed/simple;
	bh=4whQC0zZndT/mx55xPJCH9woTWSPw70jTsZqh9tbxGQ=;
	h=Date:To:From:Subject:Message-Id; b=BaHe0SYlUGtUqvDCnknQJm4mRUpxxx1mlpld7k3TbwvZI12C7VKiYv7udvCi+BUbPyHNz9hAa/HEXok6G/yesIOComC6lWj2KTwQX2nQFWebgT8wZUe8XmKw95W+C3YVIs4n3tnc+s9dmqgyU7+RQFLU2XffES2NESpycrKogKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKvunHIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKvunHIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B4CC4CEED;
	Sat, 23 Aug 2025 03:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755918766;
	bh=4whQC0zZndT/mx55xPJCH9woTWSPw70jTsZqh9tbxGQ=;
	h=Date:To:From:Subject:From;
	b=IKvunHIsXUD/EC96I3LQS7+8u6MoItlpZ4iW/te13aqPNk2pwmGJzSaqeKELA3Yd9
	 voqxOx4IFdyeiroAXuR+caDu4jj8NojOJg13Ns00rzkOTAlc6b6kPwuVl/DaMwPaj+
	 5c1wmo39wFR8RIC3eThYFHnzwmoNb/gNE5W0cPSM=
Date: Fri, 22 Aug 2025 20:12:45 -0700
To: mm-commits@vger.kernel.org,martin.petersen@oracle.com,bostroesser@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch added to mm-unstable branch
Message-Id: <20250823031246.16B4CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/target/target_core_user.c: use PAGES_TO_MB and MB_TO_PAGES
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch

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
drivers-target-target_core_userc-use-pages_to_mb-and-mb_to_pages.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

