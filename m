Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4186EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiANWFJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46738 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWFI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82AE961FF0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE30C36AEC;
        Fri, 14 Jan 2022 22:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197908;
        bh=fYosh6t1jrY2eNo/PYk8o82juQtQ+9oPeBQ1g/Ukvow=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dPamXJtWixS9l2Ydatp0YI0Is9BIsfIx/pRPiAKp3aNlKeKz385GkvZaNiLYgXMnv
         xQ4I1R1jcx61jsnknqt4HNU40fixuPmPolibAA+fQTQAeF957KoG27QVqgzxmP94Kc
         Ts0XqYWaEgyqsnp7cwhQ9uYijGtNHWCZENp+1sHI=
Date:   Fri, 14 Jan 2022 14:05:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 041/146] mm/debug_vm_pgtable: update comments
 regarding migration swap entries
Message-ID: <20220114220507.FT-t6AQz5%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
