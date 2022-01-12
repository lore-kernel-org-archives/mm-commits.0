Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F92C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jan 2022 22:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiALWh7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 17:37:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55254 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiALWh5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 17:37:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60C161B0D
        for <mm-commits@vger.kernel.org>; Wed, 12 Jan 2022 22:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3E6C36AE9;
        Wed, 12 Jan 2022 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642027076;
        bh=rCUxwaZE+Wc8DILXwXClPpM+iuGcMDLNlKO/EXNl53M=;
        h=Date:From:To:Subject:From;
        b=xjRW9MJ4Jfrc6Osaf7ewIUdKX4RMbGW3vYSvYf8LZkn4Z0iIELcrMoEA7SW61DMwc
         eneO+VRgqt6z9wz94lEyPNkokvXvVungxJ/VbY2DING5DpbLQPyDjMEtCRyaxoEC1E
         IpGgOA71B+NmMeOrBXRVDU52EdW1aV+ICUEmxUPc=
Date:   Wed, 12 Jan 2022 14:37:55 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, corbet@lwn.net,
        mm-commits@vger.kernel.org
Subject:  +
 mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch
 added to -mm tree
Message-ID: <20220112223755.NPTu6TBVu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: update comments regarding migration swap entries
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: update comments regarding migration swap entries

The commit 4dd845b5a3e5 ("mm/swapops: rework swap entry manipulation code")
had changed migtation entry related helpers. Just update debug_vm_pgatble()
synced documentation to reflect those changes.

Link: https://lkml.kernel.org/r/1641880417-24848-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/arch_pgtable_helpers.rst |   14 +++++++-------
 mm/debug_vm_pgtable.c                     |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/Documentation/vm/arch_pgtable_helpers.rst~mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries
+++ a/Documentation/vm/arch_pgtable_helpers.rst
@@ -247,12 +247,12 @@ SWAP Page Table Helpers
 | __swp_to_pmd_entry        | Creates a mapped PMD from a swapped entry (arch) |
 +---------------------------+--------------------------------------------------+
 | is_migration_entry        | Tests a migration (read or write) swapped entry  |
-+---------------------------+--------------------------------------------------+
-| is_write_migration_entry  | Tests a write migration swapped entry            |
-+---------------------------+--------------------------------------------------+
-| make_migration_entry_read | Converts into read migration swapped entry       |
-+---------------------------+--------------------------------------------------+
-| make_migration_entry      | Creates a migration swapped entry (read or write)|
-+---------------------------+--------------------------------------------------+
++-------------------------------+----------------------------------------------+
+| is_writable_migration_entry   | Tests a write migration swapped entry        |
++-------------------------------+----------------------------------------------+
+| make_readable_migration_entry | Creates a read migration swapped entry       |
++-------------------------------+----------------------------------------------+
+| make_writable_migration_entry | Creates a write migration swapped entry      |
++-------------------------------+----------------------------------------------+
 
 [1] https://lore.kernel.org/linux-mm/20181017020930.GN30832@redhat.com/
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries
+++ a/mm/debug_vm_pgtable.c
@@ -888,8 +888,8 @@ static void __init swap_migration_tests(
 	pr_debug("Validating swap migration\n");
 
 	/*
-	 * make_migration_entry() expects given page to be
-	 * locked, otherwise it stumbles upon a BUG_ON().
+	 * make_[readable|writable]_migration_entry() expects given page to
+	 * be locked, otherwise it stumbles upon a BUG_ON().
 	 */
 	__SetPageLocked(page);
 	swp = make_writable_migration_entry(page_to_pfn(page));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch
mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-thp-drop-unused-trace-events-hugepage_.patch

