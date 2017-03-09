From: akpm@linux-foundation.org
Subject: + alsa-use-set_memoryh-header.patch added to -mm tree
Date: Thu, 09 Mar 2017 13:39:03 -0800
Message-ID: <58c1cb77.5P50wwvZVlrVlvM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdCIVpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alsa: use set_memory.h header
has been added to the -mm tree.  Its filename is
     alsa-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alsa-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alsa-use-set_memoryh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: alsa: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-14-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c    |    2 +-
 sound/pci/intel8x0.c         |    4 +++-
 sound/x86/intel_hdmi_audio.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN sound/pci/hda/hda_intel.c~alsa-use-set_memoryh-header sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~alsa-use-set_memoryh-header
+++ a/sound/pci/hda/hda_intel.c
@@ -53,7 +53,7 @@
 #ifdef CONFIG_X86
 /* for snoop control */
 #include <asm/pgtable.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
 #include <sound/core.h>
diff -puN sound/pci/intel8x0.c~alsa-use-set_memoryh-header sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c~alsa-use-set_memoryh-header
+++ a/sound/pci/intel8x0.c
@@ -40,7 +40,9 @@
 #include <sound/initval.h>
 /* for 440MX workaround */
 #include <asm/pgtable.h>
-#include <asm/cacheflush.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Intel 82801AA,82901AB,i810,i820,i830,i840,i845,MX440; SiS 7012; Ali 5455");
diff -puN sound/x86/intel_hdmi_audio.c~alsa-use-set_memoryh-header sound/x86/intel_hdmi_audio.c
--- a/sound/x86/intel_hdmi_audio.c~alsa-use-set_memoryh-header
+++ a/sound/x86/intel_hdmi_audio.c
@@ -30,7 +30,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <sound/core.h>
 #include <sound/asoundef.h>
 #include <sound/pcm.h>
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-use-set_memoryh-header.patch
misc-sram-use-set_memoryh-header.patch
video-vermilion-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

