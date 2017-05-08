From: akpm@linux-foundation.org
Subject: [patch 080/114] alsa: use set_memory.h header
Date: Mon, 08 May 2017 15:58:35 -0700
Message-ID: <20170508225835.gOyeSGUu0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdEHW6g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org, tiwai@suse.de, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: alsa: use set_memory.h header

set_memory_* functions have moved to set_memory.h.  Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-14-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
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
