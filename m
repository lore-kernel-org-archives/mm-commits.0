Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130ACC7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjFJArZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjFJAqf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EEC3C03
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D7165393
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA59CC433EF;
        Sat, 10 Jun 2023 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357965;
        bh=Mb5PeS6/ct9ahKNmiPZf09k3h4lTXKmxePCoV/oglOw=;
        h=Date:To:From:Subject:From;
        b=BIA1yZeq3gkKiWyODTIBlclE1JsxABMB/Jzqa6Vo8TKKlTLw6pwKLLK8IQLZ6M6yj
         43MN2PICA5ULsFawlxx52JT3MgBfF8HC6GtwtzUCtd9MbJMS9AB6eplHqS750q9Qdu
         xv3RblhVmFGtsXXVgxYJqr3nG2EPYm1s4TfTGGNI=
Date:   Fri, 09 Jun 2023 17:46:05 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch removed from -mm tree
Message-Id: <20230610004605.CA59CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: enable kexec_crash_size to support two crash kernel regions
has been removed from the -mm tree.  Its filename was
     kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kexec: enable kexec_crash_size to support two crash kernel regions
Date: Sat, 27 May 2023 20:34:39 +0800

The crashk_low_res should be considered by /sys/kernel/kexec_crash_size
to support two crash kernel regions shrinking if existing.

While doing it, crashk_low_res will only be shrunk when the entire
crashk_res is empty; and if the crashk_res is empty and crahk_low_res
is not, change crashk_low_res to be crashk_res.

[bhe@redhat.com: redo changelog]
Link: https://lkml.kernel.org/r/20230527123439.772-7-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Baoquan He <bhe@redhat.com>
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
@@ -1136,7 +1141,7 @@ static int __crash_shrink_memory(struct
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long old_size;
+	unsigned long old_size, low_size;
 
 	if (!kexec_trylock())
 		return -EBUSY;
@@ -1145,14 +1150,42 @@ int crash_shrink_memory(unsigned long ne
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


