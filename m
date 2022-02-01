Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5F3C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiBATxz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiBATxy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE99EC06173E
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 11:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67595B82F7B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA57BC340EB;
        Tue,  1 Feb 2022 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745231;
        bh=IEujmMXP7Ut4PAQcdNI+94GvjC/pmCt3520uqaH0ME4=;
        h=Date:To:From:Subject:From;
        b=I19y8sdbp7iVWeDzZrkxn6u+jHFz4/hG1jjLR73Eg1icHMFz3KV4KQuhBUkdGiD/8
         CuFsxHTGCPT65gQy9wZkQNNB1MXw8HY7Om5wuE+NcW6nbJP2nl70+QnF5JqPIYsJEu
         M3DPu+ppTgCkW+zXtUL6zpJ9FK/q9UO+JnzXrEZM=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:49 -0800
Date:   Tue, 01 Feb 2022 11:53:49 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch added to -mm tree
Message-Id: <20220201195349.CA57BC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fail get_user_pages for LONGTERM dev coherent type
has been added to the -mm tree.  Its filename is
     mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm/gup: fail get_user_pages for LONGTERM dev coherent type

Avoid long term pinning for Coherent device type pages.  This could
interfere with their own device memory manager.  For now, we are just
returning error for PIN_LONGTERM Coherent device type pages.  Eventually,
these type of pages will get migrated to system memory, once the device
migration pages support is added.

Link: https://lkml.kernel.org/r/20220201154901.7921-4-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/gup.c~mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type
+++ a/mm/gup.c
@@ -1870,6 +1870,12 @@ static long check_and_migrate_movable_pa
 		 * If we get a movable page, since we are going to be pinning
 		 * these entries, try to move them out if possible.
 		 */
+		if (is_dev_private_or_coherent_page(head)) {
+			WARN_ON_ONCE(is_device_private_page(head));
+			ret = -EFAULT;
+			goto unpin_pages;
+		}
+
 		if (!is_pinnable_page(head)) {
 			if (PageHuge(head)) {
 				if (!isolate_huge_page(head, &movable_page_list))
@@ -1900,6 +1906,7 @@ static long check_and_migrate_movable_pa
 	if (list_empty(&movable_page_list) && !isolation_error_count)
 		return nr_pages;
 
+unpin_pages:
 	if (gup_flags & FOLL_PIN) {
 		unpin_user_pages(pages, nr_pages);
 	} else {
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

