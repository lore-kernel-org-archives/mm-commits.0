From: akpm@linux-foundation.org
Subject: - kdump-report-actual-value-of-vmcoreinfo_osrelease-in-vmcoreinfo.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:04 -0700
Message-ID: <200808062056.m76Ku4Ld014636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbYHFU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, oomichi@mxs.nes.nec.co.jp, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: report actual value of VMCOREINFO_OSRELEASE in VMCOREINFO
has been removed from the -mm tree.  Its filename was
     kdump-report-actual-value-of-vmcoreinfo_osrelease-in-vmcoreinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: report actual value of VMCOREINFO_OSRELEASE in VMCOREINFO
From: Bernhard Walle <bwalle@suse.de>

The current implementation reports the structure name as
VMCOREINFO_OSRELEASE in VMCOREINFO, e.g.

        VMCOREINFO_OSRELEASE=init_uts_ns.name.release

That doesn't make sense because it's always the same. Instead, use the
value, e.g.

        VMCOREINFO_OSRELEASE=2.6.26-rc3

That's also what the 'makedumpfile -g' does.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kexec.h~kdump-report-actual-value-of-vmcoreinfo_osrelease-in-vmcoreinfo include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-report-actual-value-of-vmcoreinfo_osrelease-in-vmcoreinfo
+++ a/include/linux/kexec.h
@@ -130,8 +130,8 @@ void vmcoreinfo_append_str(const char *f
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
-#define VMCOREINFO_OSRELEASE(name) \
-	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_OSRELEASE(value) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
 #define VMCOREINFO_PAGESIZE(value) \
 	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
_

Patches currently in -mm which might be from bwalle@suse.de are

linux-next.patch
firmware-memmap-cleanup.patch

