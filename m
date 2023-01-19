Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46AEC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjASBWM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjASBUE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93854941A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74204B81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8CCC433F0;
        Thu, 19 Jan 2023 01:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091010;
        bh=h77h6WhYKBdIcsVgRm4NzZDlatj32DTwb71zS0uLEvA=;
        h=Date:To:From:Subject:From;
        b=WMb0mxtnJ9VPfAkGCSauvW57qGioLQ6Ohej1qfW7gIRVfwuqRsGRXbQsONk9qmC+h
         xvy6JbV0n0VuU309PT+0SoDRztS2nUcG6sDLOTVaAx0x81CFiURTC4ymDhx6+6dBJz
         uFWR6kdSMFJ4ki9dS1kGFyyumHqCLQjparcl5U3I=
Date:   Wed, 18 Jan 2023 17:16:49 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        mirsad.todorovac@alu.unizg.hr, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch removed from -mm tree
Message-Id: <20230119011650.1E8CCC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
has been removed from the -mm tree.  Its filename was
     selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
Date: Mon, 9 Jan 2023 18:12:55 +0100

If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
fail.  Let's fix that like khugepaged.c does by conditionally defining
MADV_PAGEOUT.

Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of anonymous memory")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
+++ a/tools/testing/selftests/mm/cow.c
@@ -30,6 +30,9 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
 #ifndef MADV_COLLAPSE
 #define MADV_COLLAPSE 25
 #endif
_

Patches currently in -mm which might be from david@redhat.com are

mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

