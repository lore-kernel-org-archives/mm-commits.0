Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CA4C7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjFJArU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjFJAqe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C983C01
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C51D651DE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B738FC433EF;
        Sat, 10 Jun 2023 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357964;
        bh=43Ys1A2hwNB5l0waVqt7JP8UKHaawBdzB2VYBrd/yo4=;
        h=Date:To:From:Subject:From;
        b=QPsp/CQV15zEm08l6Ih+qhoHljbWSdKAf7MPCEnzmpXCHHO5XZuYg2MPQe4cjJb03
         atritX06/ENK45HVuMyS6Gp+YJMntWgD5J+Xnp8xBFmC8S8Bdrdy6ltJWeD7HVuFfY
         NGRiqNLq0/1YBplt06Ofdj56sryqdyWx4zIQcd34=
Date:   Fri, 09 Jun 2023 17:46:04 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-add-helper-__crash_shrink_memory.patch removed from -mm tree
Message-Id: <20230610004604.B738FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: add helper __crash_shrink_memory()
has been removed from the -mm tree.  Its filename was
     kexec-add-helper-__crash_shrink_memory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kexec: add helper __crash_shrink_memory()
Date: Sat, 27 May 2023 20:34:38 +0800

No functional change, in preparation for the next patch so that it is
easier to review.

[akpm@linux-foundation.org: make  __crash_shrink_memory() static]
  Link: https://lore.kernel.org/oe-kbuild-all/202305280717.Pw06aLkz-lkp@intel.com/
Link: https://lkml.kernel.org/r/20230527123439.772-6-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   51 +++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

--- a/kernel/kexec_core.c~kexec-add-helper-__crash_shrink_memory
+++ a/kernel/kexec_core.c
@@ -1105,11 +1105,38 @@ ssize_t crash_get_memory_size(void)
 	return size;
 }
 
+static int __crash_shrink_memory(struct resource *old_res,
+				 unsigned long new_size)
+{
+	struct resource *ram_res;
+
+	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
+	if (!ram_res)
+		return -ENOMEM;
+
+	ram_res->start = old_res->start + new_size;
+	ram_res->end   = old_res->end;
+	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
+	ram_res->name  = "System RAM";
+
+	if (!new_size) {
+		release_resource(old_res);
+		old_res->start = 0;
+		old_res->end   = 0;
+	} else {
+		crashk_res.end = ram_res->start - 1;
+	}
+
+	crash_free_reserved_phys_range(ram_res->start, ram_res->end);
+	insert_resource(&iomem_resource, ram_res);
+
+	return 0;
+}
+
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
 	unsigned long old_size;
-	struct resource *ram_res;
 
 	if (!kexec_trylock())
 		return -EBUSY;
@@ -1125,27 +1152,7 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
-	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
-	if (!ram_res) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	ram_res->start = crashk_res.start + new_size;
-	ram_res->end = crashk_res.end;
-	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
-	ram_res->name = "System RAM";
-
-	if (!new_size) {
-		release_resource(&crashk_res);
-		crashk_res.start = 0;
-		crashk_res.end = 0;
-	} else {
-		crashk_res.end = ram_res->start - 1;
-	}
-
-	crash_free_reserved_phys_range(ram_res->start, ram_res->end);
-	insert_resource(&iomem_resource, ram_res);
+	ret = __crash_shrink_memory(&crashk_res, new_size);
 
 unlock:
 	kexec_unlock();
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

