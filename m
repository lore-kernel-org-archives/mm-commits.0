From: akpm@linux-foundation.org
Subject: + mm-correct-guards-for-non_swap_entry.patch added to -mm
 tree
Date: Thu, 05 Mar 2020 19:46:06 -0800
Message-ID: <20200306034606.ZCixUypqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgCFDqH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 22:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, steven.price@arm.com


The patch titled
     Subject: include/linux/swapops.h: correct guards for non_swap_entry()
has been added to the -mm tree.  Its filename is
     mm-correct-guards-for-non_swap_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-correct-guards-for-non_swap=
_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-correct-guards-for-non_swap=
_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Steven Price <steven.price@arm.com>
Subject: include/linux/swapops.h: correct guards for non_swap_entry()

If CONFIG_DEVICE_PRIVATE is defined, but neither CONFIG_MEMORY_FAILURE nor
CONFIG_MIGRATION, then non_swap_entry() will return 0, meaning that the
condition (non_swap_entry(entry) && is_device_private_entry(entry)) in
zap_pte_range() will never be true even if the entry is a device private
one.

Equally any other code depending on non_swap_entry() will not function as
expected.

Link: http://lkml.kernel.org/r/20200305130550.22693-1-steven.price@arm.com
Fixes: 5042db43cc26 ("mm/ZONE_DEVICE: new type of ZONE_DEVICE for unaddress=
able memory")
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/swapops.h~mm-correct-guards-for-non_swap_entry
+++ a/include/linux/swapops.h
@@ -348,7 +348,8 @@ static inline void num_poisoned_pages_in
 }
 #endif
=20
-#if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION)
+#if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION) || \
+    defined(CONFIG_DEVICE_PRIVATE)
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >=3D MAX_SWAPFILES;
_

Patches currently in -mm which might be from steven.price@arm.com are

mm-correct-guards-for-non_swap_entry.patch
