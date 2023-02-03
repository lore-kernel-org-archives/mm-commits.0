Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AF5C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjBCGqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjBCGqW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:46:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3FA92ED7
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D5561DB5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81F0C433D2;
        Fri,  3 Feb 2023 06:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406650;
        bh=3ZerAGSsk6HGd7BCRVdaAvnxd7ZwEZ5PVGw5j10Kgz8=;
        h=Date:To:From:Subject:From;
        b=KUzQVNnEE/7mx3z5trIY9HbCW66AhKRv8TX9AncYFAuINLMA/aFqNWA/TwM1y/Jmo
         55+iI23geEr1QWf96Q09Fnxj0eF6EqMMc5gfzk3kwHPOvbJRpCb9dTfTrBW00pSlz5
         90p8DgHyBk/Yyj/jy68X3R2gJyDbJZRSdnHOGbJA=
Date:   Thu, 02 Feb 2023 22:44:10 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        mingo@redhat.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, dmitrii.bundin.a@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-add-mm-introspection-utils-fix.patch removed from -mm tree
Message-Id: <20230203064410.B81F0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts-gdb-add-mm-introspection-utils-fix
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-mm-introspection-utils-fix.patch

This patch was dropped because it was folded into scripts-gdb-add-mm-introspection-utils.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-gdb-add-mm-introspection-utils-fix
Date: Fri Jan 13 08:04:59 PM PST 2023

s/physicall/physical/

Cc: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/gdb/linux/mm.py~scripts-gdb-add-mm-introspection-utils-fix
+++ a/scripts/gdb/linux/mm.py
@@ -78,7 +78,7 @@ class Cr3():
             return f"""\
 cr3:
     {'cr3 binary data': <30} {hex(self.cr3)}
-    {'next entry physicall address': <30} {hex(self.next_entry_physical_address)}
+    {'next entry physical address': <30} {hex(self.next_entry_physical_address)}
     ---
     {'bit' : <4} {self.page_level_write_through[0]: <10} {'page level write through': <30} {self.page_level_write_through[1]}
     {'bit' : <4} {self.page_level_cache_disabled[0]: <10} {'page level cache disabled': <30} {self.page_level_cache_disabled[1]}
@@ -159,7 +159,7 @@ level {self.page_hierarchy_level}:
     {'entry address': <30} {hex(self.address)}
     {'page entry binary data': <30} {hex(self.page_entry_binary_data)}
     {'page size': <30} {'1GB' if self.page_hierarchy_level == 3 else '2MB' if self.page_hierarchy_level == 2 else '4KB' if self.page_hierarchy_level == 1 else 'Unknown page size for level:' + self.page_hierarchy_level}
-    {'page physicall address': <30} {hex(self.page_physical_address)}
+    {'page physical address': <30} {hex(self.page_physical_address)}
     ---
     {'bit': <4} {self.entry_present[0]: <10} {'entry present': <30} {self.entry_present[1]}
     {'bit': <4} {self.read_write[0]: <10} {'read/write access allowed': <30} {self.read_write[1]}
@@ -180,7 +180,7 @@ level {self.page_hierarchy_level}:
 level {self.page_hierarchy_level}:
     {'entry address': <30} {hex(self.address)}
     {'page entry binary data': <30} {hex(self.page_entry_binary_data)}
-    {'next entry physicall address': <30} {hex(self.next_entry_physical_address)}
+    {'next entry physical address': <30} {hex(self.next_entry_physical_address)}
     ---
     {'bit': <4} {self.entry_present[0]: <10} {'entry present': <30} {self.entry_present[1]}
     {'bit': <4} {self.read_write[0]: <10} {'read/write access allowed': <30} {self.read_write[1]}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
scripts-gdb-add-mm-introspection-utils.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

