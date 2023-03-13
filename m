Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCB6C74A4B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCMSHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCMSHf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA80834323
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69FE46102A
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B86C433EF;
        Mon, 13 Mar 2023 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678730852;
        bh=X+RG16AW3VWUC83dGvw8w8ZAjqWlDqaXmHmwkC74v2I=;
        h=Date:To:From:Subject:From;
        b=YUPW3yQg43H1SbxpnxzUf7z2vj0ozInKBpJAU8mwoGkD25yOfCxAdPVYD7pQQ4nMq
         qaF1nVFs1dRE5YDC+b5BB2j16vLfCow2PKlQkdrSjWI0/KwOx6NXDUsNq7JjaR6VsG
         Mxd+Xr89Fk9K1bSirJ9uIR/uSXVp7pcdv0CaOJIQ=
Date:   Mon, 13 Mar 2023 11:07:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mhocko@suse.com, lstoakes@gmail.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch added to mm-unstable branch
Message-Id: <20230313180732.C0B86C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: add this_cpu_cmpxchg_local and asm-generic definitions
has been added to the -mm mm-unstable branch.  Its filename is
     add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: add this_cpu_cmpxchg_local and asm-generic definitions
Date: Mon, 13 Mar 2023 13:25:12 -0300

Goal is to have vmstat_shepherd to transfer from per-CPU counters to
global counters remotely.  For this, an atomic this_cpu_cmpxchg is
necessary.

Add this_cpu_cmpxchg_local_ helpers to asm-generic/percpu.h.

Link: https://lkml.kernel.org/r/20230313162634.383217649@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/asm-generic/percpu.h~add-this_cpu_cmpxchg_local-and-asm-generic-definitions
+++ a/include/asm-generic/percpu.h
@@ -424,6 +424,23 @@ do {									\
 	this_cpu_generic_cmpxchg(pcp, oval, nval)
 #endif
 
+#ifndef this_cpu_cmpxchg_local_1
+#define this_cpu_cmpxchg_local_1(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_local_2
+#define this_cpu_cmpxchg_local_2(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_local_4
+#define this_cpu_cmpxchg_local_4(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_local_8
+#define this_cpu_cmpxchg_local_8(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+
 #ifndef this_cpu_cmpxchg_double_1
 #define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
--- a/include/linux/percpu-defs.h~add-this_cpu_cmpxchg_local-and-asm-generic-definitions
+++ a/include/linux/percpu-defs.h
@@ -513,6 +513,8 @@ do {									\
 #define this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(this_cpu_xchg_, pcp, nval)
 #define this_cpu_cmpxchg(pcp, oval, nval) \
 	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
+#define this_cpu_cmpxchg_local(pcp, oval, nval) \
+	__pcpu_size_call_return2(this_cpu_cmpxchg_local_, pcp, oval, nval)
 #define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, pcp1, pcp2, oval1, oval2, nval1, nval2)
 
_

Patches currently in -mm which might be from mtosatti@redhat.com are

this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

