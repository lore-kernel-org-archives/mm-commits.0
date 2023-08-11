Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADEDC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbjHKXB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjHKXAK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E78D3ABD
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A7566738D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC814C433C8;
        Fri, 11 Aug 2023 22:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794798;
        bh=u+S2963Rt5ahpjpMYClEwvfE9+bLms6+TIRiHA6RCq4=;
        h=Date:To:From:Subject:From;
        b=Z/3Vfmgsvo17tCe9vIdoQ6putZIPjuj/TY8ilIWXkLGeg67z2AQ3DJQlI90vkLK5P
         0zde3eLDMJ8BHejXOGh9e+rNjhZ2+UH8TJuSXglOB6gXGj3+xTVe9zgltjgY9xueVG
         XkFIVu/AWmSUXN2fHkwt+27hWI4oht2GVOwBOxg8=
Date:   Fri, 11 Aug 2023 15:59:57 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        yuzhao@google.com, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        talumbau@google.com, surenb@google.com, suleiman@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, naoya.horiguchi@nec.com, namit@vmware.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jiaqiyan@google.com, hughd@google.com,
        heftig@archlinux.org, david@redhat.com, cuigaosheng1@huawei.com,
        corbet@lwn.net, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch removed from -mm tree
Message-Id: <20230811225957.EC814C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: document and enable new UFFDIO_POISON feature
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-document-and-enable-new-uffdio_poison-feature.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: document and enable new UFFDIO_POISON feature
Date: Fri, 7 Jul 2023 14:55:38 -0700

Update the userfaultfd API to advertise this feature as part of feature
flags and supported ioctls (returned upon registration).

Add basic documentation describing the new feature.

Link: https://lkml.kernel.org/r/20230707215540.2324998-7-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |   15 +++++++++++++++
 include/uapi/linux/userfaultfd.h             |    9 ++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~mm-userfaultfd-document-and-enable-new-uffdio_poison-feature
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -244,6 +244,21 @@ write-protected (so future writes will a
 support a mode flag (``UFFDIO_COPY_MODE_WP`` or ``UFFDIO_CONTINUE_MODE_WP``
 respectively) to configure the mapping this way.
 
+Memory Poisioning Emulation
+---------------------------
+
+In response to a fault (either missing or minor), an action userspace can
+take to "resolve" it is to issue a ``UFFDIO_POISON``. This will cause any
+future faulters to either get a SIGBUS, or in KVM's case the guest will
+receive an MCE as if there were hardware memory poisoning.
+
+This is used to emulate hardware memory poisoning. Imagine a VM running on a
+machine which experiences a real hardware memory error. Later, we live migrate
+the VM to another physical machine. Since we want the migration to be
+transparent to the guest, we want that same address range to act as if it was
+still poisoned, even though it's on a new physical host which ostensibly
+doesn't have a memory error in the exact same spot.
+
 QEMU/KVM
 ========
 
--- a/include/uapi/linux/userfaultfd.h~mm-userfaultfd-document-and-enable-new-uffdio_poison-feature
+++ a/include/uapi/linux/userfaultfd.h
@@ -39,7 +39,8 @@
 			   UFFD_FEATURE_MINOR_SHMEM |		\
 			   UFFD_FEATURE_EXACT_ADDRESS |		\
 			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
-			   UFFD_FEATURE_WP_UNPOPULATED)
+			   UFFD_FEATURE_WP_UNPOPULATED |	\
+			   UFFD_FEATURE_POISON)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -49,12 +50,14 @@
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
-	 (__u64)1 << _UFFDIO_CONTINUE)
+	 (__u64)1 << _UFFDIO_CONTINUE |		\
+	 (__u64)1 << _UFFDIO_POISON)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_WRITEPROTECT)
+	 (__u64)1 << _UFFDIO_POISON)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
_

Patches currently in -mm which might be from axelrasmussen@google.com are


