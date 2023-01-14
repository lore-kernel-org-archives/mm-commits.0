Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1649FC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjANEGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjANEGt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:06:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FE8F
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:06:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8301BB800C1
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C803C433EF;
        Sat, 14 Jan 2023 04:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673669204;
        bh=xFs9+nsDRavvi3xPaV1GYdKcH76CPBPxedVEeGPvdc4=;
        h=Date:To:From:Subject:From;
        b=kT53qKOLsLrJ1xtyKO7mMDaqpSdvN5MrSx3paW1UtL9Ia49BPHAqs+ELwdoLps9Wy
         B7/Qte/3YPTim8J9rkJWcUTjejR51Kz3unOjY/kVuqiN3vyk9RImx833IxDo1j9m6+
         BIEAo9vI3nV7LQ+p9WK+3be8dM4KLv7XPJB7DHv8=
Date:   Fri, 13 Jan 2023 20:06:43 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        mingo@redhat.com, kbingham@kernel.org, jan.kiszka@siemens.com,
        gregkh@linuxfoundation.org, dmitrii.bundin.a@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-mm-introspection-utils-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230114040644.2C803C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-add-mm-introspection-utils-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-mm-introspection-utils-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-mm-introspection-utils-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

