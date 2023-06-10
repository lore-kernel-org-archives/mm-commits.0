Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83F9C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjFJArR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjFJAqe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4281E3ABB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2338365382
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A96C433D2;
        Sat, 10 Jun 2023 00:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357962;
        bh=bdQvosdsPBtER1CtuEzCB5SXknS7rDh5ZTZ5apsY1Yw=;
        h=Date:To:From:Subject:From;
        b=v/OMNd06NwAbd0nkJYRqiZcyau4NghxiziW3Y2blMBTc0pqFDcL2B4p+1vsaCOR+A
         vjaCTBNXHyaiplc8d35vGMtfLl7OwAsMswUrzz/ZLqg0rFuW0MAFMo8PG2w7ud+dMN
         Za+7R34xiVG5DzKkX9eulhkW0LHdCTb4ZWzsdkKI=
Date:   Fri, 09 Jun 2023 17:46:01 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch removed from -mm tree
Message-Id: <20230610004602.77A96C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: clear crashk_res if all its memory has been released
has been removed from the -mm tree.  Its filename was
     kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kexec: clear crashk_res if all its memory has been released
Date: Sat, 27 May 2023 20:34:36 +0800

If the resource of crashk_res has been released, it is better to clear
crashk_res.start and crashk_res.end.  Because 'end = start - 1' is not
reasonable, and in some places the test is based on crashk_res.end, not
resource_size(&crashk_res).

Link: https://lkml.kernel.org/r/20230527123439.772-4-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/kexec_core.c~kexec-clear-crashk_res-if-all-its-memory-has-been-released
+++ a/kernel/kexec_core.c
@@ -1137,15 +1137,18 @@ int crash_shrink_memory(unsigned long ne
 	end = start + new_size;
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
-	if (start == end)
-		release_resource(&crashk_res);
-
 	ram_res->start = end;
 	ram_res->end = crashk_res.end;
 	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
 	ram_res->name = "System RAM";
 
-	crashk_res.end = end - 1;
+	if (start == end) {
+		release_resource(&crashk_res);
+		crashk_res.start = 0;
+		crashk_res.end = 0;
+	} else {
+		crashk_res.end = end - 1;
+	}
 
 	insert_resource(&iomem_resource, ram_res);
 
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

