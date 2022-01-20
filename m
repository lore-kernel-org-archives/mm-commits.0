Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1750FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377819AbiATVYk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57050 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377818AbiATVYi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 067C2B81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AAAC340E5;
        Thu, 20 Jan 2022 21:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713875;
        bh=5KZkYNk94N4c5AkUYwRmEbpFVQwkzgo6Z8/qLkgoHaY=;
        h=Date:From:To:Subject:From;
        b=v700bLg77Kd+7QY2VumITAYn/Zj1i5lIiGBztp3tmm+o4DWPuV9o6ulHkbpJSsiIs
         IqjMUkZbSsBh4wAAyguA2APk423ooqN0LZudGOJ67qYE2l0pRW5qqjG/kQR2UeJH7A
         11k1/TVWn0XqR3RkCTu6cpfQgIDgu/QXtGws9hGQ=
Date:   Thu, 20 Jan 2022 13:24:35 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, corbet@lwn.net,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch
 removed from -mm tree
Message-ID: <20220120212435.SqV7jGQTQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: update comments regarding migration swap entries
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


