From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 089/166] include/linux/swapops.h: correct guards
 for non_swap_entry()
Date: Mon, 06 Apr 2020 20:08:43 -0700
Message-ID: <20200407030843.XB8zAqurU%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgDGDIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:44 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dan.j.williams@intel.com, jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, steven.price@arm.com, torvalds@linux-foundation.org

=46rom: Steven Price <steven.price@arm.com>
Subject: include/linux/swapops.h: correct guards for non_swap_entry()

If CONFIG_DEVICE_PRIVATE is defined, but neither CONFIG_MEMORY_FAILURE nor
CONFIG_MIGRATION, then non_swap_entry() will return 0, meaning that the
condition (non_swap_entry(entry) && is_device_private_entry(entry)) in
zap_pte_range() will never be true even if the entry is a device private
one.

Equally any other code depending on non_swap_entry() will not function as
expected.

I originally spotted this just by looking at the code, I haven't actually
observed any problems.

Looking a bit more closely it appears that actually this situation
(currently at least) cannot occur:

DEVICE_PRIVATE depends on ZONE_DEVICE
ZONE_DEVICE depends on MEMORY_HOTREMOVE
MEMORY_HOTREMOVE depends on MIGRATION

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
@@ -350,7 +350,8 @@ static inline void num_poisoned_pages_in
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
