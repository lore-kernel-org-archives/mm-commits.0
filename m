From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch removed from -mm tree
Date: Wed, 07 Feb 2018 14:45:01 -0800
Message-ID: <5a7b816d.c3CkNa3tyRdMVzWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbeBGWpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't use the same value for MAP_FIXED_NOREPLACE and MAP_SYNC
has been removed from the -mm tree.  Its filename was
     fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch

This patch was dropped because it was folded into mm-introduce-map_fixed_safe.patch

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: mm: don't use the same value for MAP_FIXED_NOREPLACE and MAP_SYNC

Link: http://lkml.kernel.org/r/20171218184916.24445-1-avagin@openvz.org
Fixes: ("fs, elf: drop MAP_FIXED usage from elf_map")
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/mman-common.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/uapi/asm-generic/mman-common.h~fs-elf-drop-map_fixed-usage-from-elf_map-fix include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~fs-elf-drop-map_fixed-usage-from-elf_map-fix
+++ a/include/uapi/asm-generic/mman-common.h
@@ -26,7 +26,9 @@
 #else
 # define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
 #endif
-#define MAP_FIXED_NOREPLACE	0x80000	/* MAP_FIXED which doesn't unmap underlying mapping */
+
+/* 0x0100 - 0x80000 flags are defined in asm-generic/mman.h */
+#define MAP_FIXED_NOREPLACE	0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 
 /*
  * Flags for mlock
_

Patches currently in -mm which might be from avagin@openvz.org are

mm-introduce-map_fixed_safe.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v2.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

