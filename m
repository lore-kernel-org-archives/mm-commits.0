From: akpm@linux-foundation.org
Subject: + agp-use-set_memoryh-header.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:50:14 -0800
Message-ID: <58ba0136.DCZHPgaE8iaG579Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbdCCXuQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, airlied@linux.ie, alexander.shishkin@linux.intel.com, arnd@arndb.de, catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, jeyu@redhat.com, keescook@chromium.org, linux@armlinux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: agp: use set_memory.h header
has been added to the -mm tree.  Its filename is
     agp-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/agp-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/agp-use-set_memoryh-header.patch

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
Subject: agp: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488413706-9739-7-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c |    1 +
 drivers/char/agp/ati-agp.c    |    1 +
 drivers/char/agp/generic.c    |    2 +-
 drivers/char/agp/intel-gtt.c  |    1 +
 drivers/char/agp/sworks-agp.c |    1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd-k7-agp.c~agp-use-set_memoryh-header drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -9,6 +9,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define AMD_MMBASE_BAR	1
diff -puN drivers/char/agp/ati-agp.c~agp-use-set_memoryh-header drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/ati-agp.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/agp_backend.h>
 #include <asm/agp.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define ATI_GART_MMBASE_BAR	1
diff -puN drivers/char/agp/generic.c~agp-use-set_memoryh-header drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/generic.c
@@ -39,7 +39,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <asm/io.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/pgtable.h>
 #include "agp.h"
 
diff -puN drivers/char/agp/intel-gtt.c~agp-use-set_memoryh-header drivers/char/agp/intel-gtt.c
--- a/drivers/char/agp/intel-gtt.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/intel-gtt.c
@@ -25,6 +25,7 @@
 #include "agp.h"
 #include "intel-agp.h"
 #include <drm/intel-gtt.h>
+#include <asm/set_memory.h>
 
 /*
  * If we have Intel graphics, we're not going to have anything other than
diff -puN drivers/char/agp/sworks-agp.c~agp-use-set_memoryh-header drivers/char/agp/sworks-agp.c
--- a/drivers/char/agp/sworks-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/sworks-agp.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/agp_backend.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define SVWRKS_COMMAND		0x04
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
alsa-hda-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

