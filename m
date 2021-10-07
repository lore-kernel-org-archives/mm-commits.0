Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A417C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4947661175
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhJGBQG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 21:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE39261090;
        Thu,  7 Oct 2021 01:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633569253;
        bh=6eS0XYATyETLuTALULsr00ndh/cq6e00cFvXUOIs6YE=;
        h=Date:From:To:Subject:From;
        b=U4v54DAKMZM9qv4pOiIzUIfhJO7ngxewvtotJqEcSLuyRXsNVQNSDEZnO4Xq8fmnO
         j2pvgajIs+9DYGiY2ZsXZG/FOrw2zAMcX00O0XqGbeQ6AP+qcIFr4GPMUwa5lgtwYi
         lh9vyGiQmGkE4Et+V0FdZ+q1iVTdjeF0LZwFfZJw=
Date:   Wed, 06 Oct 2021 18:14:12 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [alternative-merged]
 kasan-remove-duplicate-of-kasan_flag_async.patch removed from -mm tree
Message-ID: <20211007011412.k0I0vUi8K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove duplicate of kasan_flag_async
has been removed from the -mm tree.  Its filename was
     kasan-remove-duplicate-of-kasan_flag_async.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: remove duplicate of kasan_flag_async

Patch series "arm64: ARMv8.7-A: MTE: Add asymm in-kernel support", v2.

This series implements the in-kernel asymmetric mode support for ARMv8.7-A
Memory Tagging Extension (MTE), which is a debugging feature that allows
to detect with the help of the architecture the C and C++ programmatic
memory errors like buffer overflow, use-after-free, use-after-return, etc.

MTE is built on top of the AArch64 v8.0 virtual address tagging TBI (Top
Byte Ignore) feature and allows a task to set a 4 bit tag on any subset of
its address space that is multiple of a 16 bytes granule.  MTE is based on
a lock-key mechanism where the lock is the tag associated to the physical
memory and the key is the tag associated to the virtual address.

When MTE is enabled and tags are set for ranges of address space of a
task, the PE will compare the tag related to the physical memory with the
tag related to the virtual address (tag check operation).  Access to the
memory is granted only if the two tags match.  In case of mismatch the PE
will raise an exception.

When asymmetric mode is present, the CPU triggers a fault on a tag
mismatch during a load operation and asynchronously updates a register
when a tag mismatch is detected during a store operation.

Note: The userspace support will be sent with a future patch series.


This patch (of 5):

After merging async mode for KASAN_HW_TAGS a duplicate of the
kasan_flag_async flag was left erroneously inside the code.

Remove the duplicate.

Note: This change does not bring functional changes to the code
base.

Link: https://lkml.kernel.org/r/20211004202253.27857-1-vincenzo.frascino@arm.com
Link: https://lkml.kernel.org/r/20211004202253.27857-2-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-remove-duplicate-of-kasan_flag_async
+++ a/mm/kasan/kasan.h
@@ -38,8 +38,6 @@ static inline bool kasan_async_mode_enab
 
 #endif
 
-extern bool kasan_flag_async __ro_after_init;
-
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_GRANULE_SIZE	(1UL << KASAN_SHADOW_SCALE_SHIFT)
 #else
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

arm64-mte-bitfield-definitions-for-asymm-mte.patch
arm64-mte-cpu-feature-detection-for-asymm-mte.patch
arm64-mte-add-asymmetric-mode-support.patch
kasan-extend-kasan-mode-kernel-parameter.patch

