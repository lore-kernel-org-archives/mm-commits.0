From: akpm@linux-foundation.org
Subject: + mm-config_zone_device-stop-depending-on-config_expert.patch
 added to -mm tree
Date: Wed, 13 Jul 2016 12:58:19 -0700
Message-ID: <57869d5b.Z3L407l1VhpCPdvp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcGMT6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 15:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jmoyer@redhat.com, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT
has been added to the -mm tree.  Its filename is
     mm-config_zone_device-stop-depending-on-config_expert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-config_zone_device-stop-depending-on-config_expert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-config_zone_device-stop-depending-on-config_expert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT

When it was first introduced CONFIG_ZONE_DEVICE depended on disabling
CONFIG_ZONE_DMA, a configuration choice reserved for "experts".  However,
now that the ZONE_DMA conflict has been eliminated it no longer makes
sense to require CONFIG_EXPERT.

Link: http://lkml.kernel.org/r/146687646274.39261.14267596518720371009.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-config_zone_device-stop-depending-on-config_expert mm/Kconfig
--- a/mm/Kconfig~mm-config_zone_device-stop-depending-on-config_expert
+++ a/mm/Kconfig
@@ -681,7 +681,7 @@ config IDLE_PAGE_TRACKING
 	  See Documentation/vm/idle_page_tracking.txt for more details.
 
 config ZONE_DEVICE
-	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
+	bool "Device memory (pmem, etc...) hotplug support"
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on SPARSEMEM_VMEMMAP
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-config_zone_device-stop-depending-on-config_expert.patch
mm-cleanup-ifdef-guards-for-vmem_altmap.patch

