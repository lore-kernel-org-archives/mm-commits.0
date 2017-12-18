From: akpm@linux-foundation.org
Subject: + fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch added to -mm tree
Date: Mon, 18 Dec 2017 15:00:37 -0800
Message-ID: <5a384895.S0his+k22W4YAwAJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935208AbdLRXAi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 18:00:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't use the same value for MAP_FIXED_SAFE and MAP_SYNC
has been added to the -mm tree.  Its filename is
     fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: mm: don't use the same value for MAP_FIXED_SAFE and MAP_SYNC

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
-#define MAP_FIXED_SAFE	0x80000		/* MAP_FIXED which doesn't unmap underlying mapping */
+
+/* 0x0100 - 0x80000 flags are defined in asm-generic/mman.h */
+#define MAP_FIXED_SAFE	0x100000		/* MAP_FIXED which doesn't unmap underlying mapping */
 
 /*
  * Flags for mlock
_

Patches currently in -mm which might be from avagin@openvz.org are

fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch

