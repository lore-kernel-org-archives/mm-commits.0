From: akpm@linux-foundation.org
Subject: [merged]
 dcumentation-filesystems-proctxt-add-more-description-for-maps-smaps.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:57:44 -0700
Message-ID: <57fc1ce8.o2eBPnB/hnFBP14n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38050 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcJJW5p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.hu@intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, gleb@kernel.org, guangrong.xiao@linux.intel.com, mhocko@suse.com, mtosatti@redhat.com, oleg@redhat.com, pbonzini@redhat.com, ross.zwisler@linux.intel.com, stefanha@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: add more description for maps/smaps
has been removed from the -mm tree.  Its filename was
     dcumentation-filesystems-proctxt-add-more-description-for-maps-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Ho <robert.hu@intel.com>
Subject: Documentation/filesystems/proc.txt: add more description for maps/smaps

Add some more description on the limitations for smaps/maps readings, as well
as some guaruntees we can make.

Link: http://lkml.kernel.org/r/1475296958-27652-2-git-send-email-robert.hu@intel.com
Signed-off-by: Robert Ho <robert.hu@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Robert Hu <robert.hu@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/filesystems/proc.txt~dcumentation-filesystems-proctxt-add-more-description-for-maps-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~dcumentation-filesystems-proctxt-add-more-description-for-maps-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -515,6 +515,18 @@ be vanished or the reverse -- new added.
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
+Note: reading /proc/PID/maps or /proc/PID/smaps is inherently racy (consistent
+output can be achieved only in the single read call).
+This typically manifests when doing partial reads of these files while the
+memory map is being modified.  Despite the races, we do provide the following
+guarantees:
+
+1) The mapped addresses never go backwards, which implies no two
+   regions will ever overlap.
+2) If there is something at a given vaddr during the entirety of the
+   life of the smaps/maps walk, there will be some output for it.
+
+
 The /proc/PID/clear_refs is used to reset the PG_Referenced and ACCESSED/YOUNG
 bits on both physical and virtual pages associated with a process, and the
 soft-dirty bit on pte (see Documentation/vm/soft-dirty.txt for details).
_

Patches currently in -mm which might be from robert.hu@intel.com are


