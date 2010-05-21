From: akpm@linux-foundation.org
Subject: + fbmem-fix-printk-format-warnings.patch added to -mm tree
Date: Fri, 21 May 2010 12:30:37 -0700
Message-ID: <201005211930.o4LJUbhN029958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285Ab0EUTbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, airlied@redhat.com, eric@anholt.net, marcin.slusarz@gmail.com


The patch titled
     fbmem: fix printk format warnings
has been added to the -mm tree.  Its filename is
     fbmem-fix-printk-format-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk formats:

drivers/video/fbmem.c: In function 'fb_do_apertures_overlap':
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/video/fbmem.c:1494: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'

Fixes the patch "fbdev: allow passing more than one aperture for handoff".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbmem-fix-printk-format-warnings drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-fix-printk-format-warnings
+++ a/drivers/video/fbmem.c
@@ -1491,7 +1491,10 @@ static bool fb_do_apertures_overlap(stru
 		for (j = 0; j < gena->count; ++j) {
 			struct aperture *g = &gena->ranges[j];
 			printk(KERN_DEBUG "checking generic (%llx %llx) vs hw (%llx %llx)\n",
-				g->base, g->size, h->base, h->size);
+				(unsigned long long)g->base,
+				(unsigned long long)g->size,
+				(unsigned long long)h->base,
+				(unsigned long long)h->size);
 			if (apertures_overlap(g, h))
 				return true;
 		}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-fix-s6e63m0-kconfig.patch
backlight-fix-s6e63m0-device-attr-function-return-types.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch
fbmem-fix-printk-format-warnings.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

