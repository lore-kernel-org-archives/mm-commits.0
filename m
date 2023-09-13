Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1105BEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjIMT2d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjIMT2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:28:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E101999
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:28:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9666C433C8;
        Wed, 13 Sep 2023 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633308;
        bh=ZAIB92OgE2GTXY38NWRvFiSK1hfVtIvBfiYs8mX6BKU=;
        h=Date:To:From:Subject:From;
        b=zG8svbZBTJlAeEEofSeFlA04pGyw2kg+6FvVyH7JFalr7rccGyhkewTVngFGtPrWP
         hwFShtx1LkKYmIGUq6XN16Hcy0OnY2knne5pPRgSsEzNahKrjhogo3jKEyvo1N4FNP
         89swwUZyn0/JWPfW2ULsSvLkfn2yKl69sCMMjFBM=
Date:   Wed, 13 Sep 2023 12:28:28 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-check-disabled-flag-when-fetching.patch added to mm-unstable branch
Message-Id: <20230913192828.A9666C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: check disabled flag when fetching
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-check-disabled-flag-when-fetching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-check-disabled-flag-when-fetching.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: check disabled flag when fetching
Date: Wed, 13 Sep 2023 19:14:26 +0200

Patch series "stackdepot: allow evicting stack traces", v2.

Currently, the stack depot grows indefinitely until it reaches its
capacity.  Once that happens, the stack depot stops saving new stack
traces.

This creates a problem for using the stack depot for in-field testing
and in production.

For such uses, an ideal stack trace storage should:

1. Allow saving fresh stack traces on systems with a large uptime while
   limiting the amount of memory used to store the traces;
2. Have a low performance impact.

Implementing #1 in the stack depot is impossible with the current
keep-forever approach.  This series targets to address that.  Issue #2 is
left to be addressed in a future series.

This series changes the stack depot implementation to allow evicting
unneeded stack traces from the stack depot.  The users of the stack depot
can do that via new stack_depot_save_flags(STACK_DEPOT_FLAG_GET) and
stack_depot_put APIs.

Internal changes to the stack depot code include:

1. Storing stack traces in fixed-frame-sized slots; the slot size is
   controlled via CONFIG_STACKDEPOT_MAX_FRAMES (vs precisely-sized
   slots in the current implementation);
2. Keeping available slots in a freelist (vs keeping an offset to the next
   free slot);
3. Using a read/write lock for synchronization (vs a lock-free approach
   combined with a spinlock).

This series also integrates the eviction functionality in the tag-based
KASAN modes.

Despite wasting some space on rounding up the size of each stack record,
with CONFIG_STACKDEPOT_MAX_FRAMES=32, the tag-based KASAN modes end up
consuming ~5% less memory in stack depot during boot (with the default
stack ring size of 32k entries).  The reason for this is the eviction of
irrelevant stack traces from the stack depot, which frees up space for
other stack traces.

For other tools that heavily rely on the stack depot, like Generic KASAN
and KMSAN, this change leads to the stack depot capacity being reached
sooner than before.  However, as these tools are mainly used in fuzzing
scenarios where the kernel is frequently rebooted, this outcome should be
acceptable.

There is no measurable boot time performance impact of these changes for
KASAN on x86-64.  I haven't done any tests for arm64 modes (the stack
depot without performance optimizations is not suitable for intended use
of those anyway), but I expect a similar result.  Obtaining and copying
stack trace frames when saving them into stack depot is what takes the
most time.

This series does not yet provide a way to configure the maximum size of
the stack depot externally (e.g.  via a command-line parameter).  This
will be added in a separate series, possibly together with the performance
improvement changes.


This patch (of 19):

Do not try fetching a stack trace from the stack depot if the
stack_depot_disabled flag is enabled.

Link: https://lkml.kernel.org/r/cover.1694625260.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/66bf1f0ad22d2c49ef500893340c71355b71d092.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-check-disabled-flag-when-fetching
+++ a/lib/stackdepot.c
@@ -477,7 +477,7 @@ unsigned int stack_depot_fetch(depot_sta
 	 */
 	kmsan_unpoison_memory(entries, sizeof(*entries));
 
-	if (!handle)
+	if (!handle || stack_depot_disabled)
 		return 0;
 
 	if (parts.pool_index > pool_index_cached) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch

