Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB93C7EE33
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjE3WE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjE3WEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8992E11F
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B886344E
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD8CC4339B;
        Tue, 30 May 2023 22:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484282;
        bh=v0dHS4h2Jo0p4RTV3x5nSDBOdyS0Crl9GfV8dLkqce8=;
        h=Date:To:From:Subject:From;
        b=nPsaIpBQnSsKPAqujmt9JsdIJ1cnTk53Cjm3F+iHAM+2GEXMNPDc3axfo7izHNpGq
         +tMavCV1rKy/42fYK1Kr8XMGUOcd46T9N8ag3bFpXQ9PICs+v8PDde8KS/3dxq+dTg
         kpBczZY5xltcUfAJ5UAAkVDD70uqe4/PRi5mzq6I=
Date:   Tue, 30 May 2023 15:04:42 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220442.BDD8CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: enable kexec_crash_size to support two crash kernel regions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

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
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kexec: enable kexec_crash_size to support two crash kernel regions
Date: Sat, 27 May 2023 20:34:39 +0800

The crashk_low_res should be considered by /sys/kernel/kexec_crash_size to
support two crash kernel regions.  Since crashk_res manages the memory
with high address and crashk_low_res manages the memory with low address,
crashk_low_res is shrunken only when all crashk_res is shrunken.  And
because when there is only one crash kernel region, crashk_res is always
used.  Therefore, if all crashk_res is shrunken and crashk_low_res still
exists, swap them.

Link: https://lkml.kernel.org/r/20230527123439.772-7-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   43 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

--- a/kernel/kexec_core.c~kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions
+++ a/kernel/kexec_core.c
@@ -1091,6 +1091,11 @@ __bpf_kfunc void crash_kexec(struct pt_r
 	}
 }
 
+static inline resource_size_t crash_resource_size(const struct resource *res)
+{
+	return !res->end ? 0 : resource_size(res);
+}
+
 ssize_t crash_get_memory_size(void)
 {
 	ssize_t size = 0;
@@ -1098,8 +1103,8 @@ ssize_t crash_get_memory_size(void)
 	if (!kexec_trylock())
 		return -EBUSY;
 
-	if (crashk_res.end != crashk_res.start)
-		size = resource_size(&crashk_res);
+	size += crash_resource_size(&crashk_res);
+	size += crash_resource_size(&crashk_low_res);
 
 	kexec_unlock();
 	return size;
@@ -1135,7 +1140,7 @@ int __crash_shrink_memory(struct resourc
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long old_size;
+	unsigned long old_size, low_size;
 
 	if (!kexec_trylock())
 		return -EBUSY;
@@ -1144,14 +1149,42 @@ int crash_shrink_memory(unsigned long ne
 		ret = -ENOENT;
 		goto unlock;
 	}
-	old_size = !crashk_res.end ? 0 : resource_size(&crashk_res);
+
+	low_size = crash_resource_size(&crashk_low_res);
+	old_size = crash_resource_size(&crashk_res) + low_size;
 	new_size = roundup(new_size, KEXEC_CRASH_MEM_ALIGN);
 	if (new_size >= old_size) {
 		ret = (new_size == old_size) ? 0 : -EINVAL;
 		goto unlock;
 	}
 
-	ret = __crash_shrink_memory(&crashk_res, new_size);
+	/*
+	 * (low_size > new_size) implies that low_size is greater than zero.
+	 * This also means that if low_size is zero, the else branch is taken.
+	 *
+	 * If low_size is greater than 0, (low_size > new_size) indicates that
+	 * crashk_low_res also needs to be shrunken. Otherwise, only crashk_res
+	 * needs to be shrunken.
+	 */
+	if (low_size > new_size) {
+		ret = __crash_shrink_memory(&crashk_res, 0);
+		if (ret)
+			goto unlock;
+
+		ret = __crash_shrink_memory(&crashk_low_res, new_size);
+	} else {
+		ret = __crash_shrink_memory(&crashk_res, new_size - low_size);
+	}
+
+	/* Swap crashk_res and crashk_low_res if needed */
+	if (!crashk_res.end && crashk_low_res.end) {
+		crashk_res.start = crashk_low_res.start;
+		crashk_res.end   = crashk_low_res.end;
+		release_resource(&crashk_low_res);
+		crashk_low_res.start = 0;
+		crashk_low_res.end   = 0;
+		insert_resource(&iomem_resource, &crashk_res);
+	}
 
 unlock:
 	kexec_unlock();
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-fix-a-memory-leak-in-crash_shrink_memory.patch
kexec-delete-a-useless-check-in-crash_shrink_memory.patch
kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

