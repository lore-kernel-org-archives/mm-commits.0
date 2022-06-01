Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CFFC43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 20:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiFAUvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiFAUun (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 16:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524871B5858
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 13:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9FB60E9D
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 20:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3D4C385B8;
        Wed,  1 Jun 2022 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654116471;
        bh=8ycNewgxt+H84IH+OiKQJai5WrAoTW+zDobvqRdq0iM=;
        h=Date:To:From:Subject:From;
        b=B4tUk2qDVZ0dC6X2E7ITguzpxCZoCeZlte5hDu+RxL8gh/ok4jArr5Xj7MiMQAIbi
         xXwwsD3NoRNsJLbwwwSIASf4UWdqD7tRxUOVlUOfgQ5xy2Ruh55UCwXuJ6ogTCjhHV
         7FXq34s13BiTJagMrZ09h/+IvAaU60h/gDJ/RVEY=
Date:   Wed, 01 Jun 2022 13:47:50 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, david@redhat.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-re-factor-page_is_ram.patch added to mm-nonmm-unstable branch
Message-Id: <20220601204751.2F3D4C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: resource: re-factor page_is_ram()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-re-factor-page_is_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-re-factor-page_is_ram.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: resource: re-factor page_is_ram()
Date: Wed, 1 Jun 2022 22:02:43 +0530

Presently page_is_ram() relies on walk_system_ram_range() that performs a
walk on kernel iomem resources hierarchy with a dummy callback __is_ram().
Before calling find_next_iomem_res(), walk_system_ram_range() does some
book-keeping which can be avoided for page_is_ram() use-case.

Hence this patch proposes to update page_is_ram() to directly call
find_next_iomem_res() with minimal book-keeping needed.

To avoid allocating a 'struct resource' the patch also updates
find_next_iomem_res() to not return -EINVAL in case 'res == NULL'. 
Instead our 'struct resource *res' is only populated when its not NULL.

Link: https://lkml.kernel.org/r/20220601163243.3806231-1-vaibhav@linux.ibm.com
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/kernel/resource.c~resource-re-factor-page_is_ram
+++ a/kernel/resource.c
@@ -311,7 +311,7 @@ EXPORT_SYMBOL(release_resource);
  *
  * If a resource is found, returns 0 and @*res is overwritten with the part
  * of the resource that's within [@start..@end]; if none is found, returns
- * -ENODEV.  Returns -EINVAL for invalid parameters.
+ * -ENODEV.
  *
  * @start:	start address of the resource searched for
  * @end:	end address of same resource
@@ -328,9 +328,6 @@ static int find_next_iomem_res(resource_
 {
 	struct resource *p;
 
-	if (!res)
-		return -EINVAL;
-
 	if (start >= end)
 		return -EINVAL;
 
@@ -356,7 +353,7 @@ static int find_next_iomem_res(resource_
 		break;
 	}
 
-	if (p) {
+	if (p && res) {
 		/* copy data */
 		*res = (struct resource) {
 			.start = max(start, p->start),
@@ -474,18 +471,18 @@ int walk_system_ram_range(unsigned long
 	return ret;
 }
 
-static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
-{
-	return 1;
-}
-
 /*
  * This generic page_is_ram() returns true if specified address is
  * registered as System RAM in iomem_resource list.
  */
 int __weak page_is_ram(unsigned long pfn)
 {
-	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
+	const resource_size_t pfn_res = PFN_PHYS(pfn);
+
+	return find_next_iomem_res(pfn_res,
+				   pfn_res + 1,
+				   IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY,
+				   IORES_DESC_NONE, NULL) == 0;
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
_

Patches currently in -mm which might be from vaibhav@linux.ibm.com are

resource-re-factor-page_is_ram.patch

