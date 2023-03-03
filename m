Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CFBC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCCWs6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjCCWs5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:48:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92EB136F0
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A29A61956
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CA5C433D2;
        Fri,  3 Mar 2023 22:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882754;
        bh=1USq0wnhoIH8dmWH212tHrASKURLF3LCuAyGt/t+giU=;
        h=Date:To:From:Subject:From;
        b=RSd+kW/6C0HF3iGv3NyMu+REQkMPVEawIlBW3LBFpCb0+y3ZhNxrvEEqLTZli3Yd+
         pRQOUSFtpNcv4TolIcGVZsohZP9l6kcOe4WK0WvxIV/2kSCZVO8N8tmGPkbCnYkbXC
         UjbzKLkMBqGfLBE2HkQLR7zqV9Ih8HUh7nj1wneY=
Date:   Fri, 03 Mar 2023 14:32:33 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch added to mm-unstable branch
Message-Id: <20230303223233.E0CA5C433D2@smtp.kernel.org>
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
Date: Fri, 03 Mar 2023 16:58:47 -0300

Goal is to have vmstat_shepherd to transfer from per-CPU counters to
global counters remotely.  For this, an atomic this_cpu_cmpxchg is
necessary.

Add this_cpu_cmpxchg_local_ helpers to asm-generic/percpu.h.

Link: https://lkml.kernel.org/r/20230303195908.901973993@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

