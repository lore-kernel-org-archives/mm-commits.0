From: akpm@linux-foundation.org
Subject: + kcore-add-kconfig-help-text.patch added to -mm tree
Date: Thu, 07 Nov 2013 13:39:25 -0800
Message-ID: <527c088d.GPNEQQ64GqLQwVxl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3KGVj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 16:39:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lailavrazda1979@gmail.com, dhowells@redhat.com, rdunlap@infradead.org

Subject: + kcore-add-kconfig-help-text.patch added to -mm tree
To: rdunlap@infradead.org,dhowells@redhat.com,lailavrazda1979@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 13:39:25 -0800


The patch titled
     Subject: kcore: add Kconfig help text
has been added to the -mm tree.  Its filename is
     kcore-add-kconfig-help-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcore-add-kconfig-help-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcore-add-kconfig-help-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kcore: add Kconfig help text

Under Pseudo filesystems, /proc/kcore support has no help.

Fixes a portion of kernel bugzilla #52671:
  https://bugzilla.kernel.org/show_bug.cgi?id=52671

Thanks for David Howells for the help text.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: <lailavrazda1979@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/Kconfig~kcore-add-kconfig-help-text fs/proc/Kconfig
--- a/fs/proc/Kconfig~kcore-add-kconfig-help-text
+++ a/fs/proc/Kconfig
@@ -31,6 +31,10 @@ config PROC_FS
 config PROC_KCORE
 	bool "/proc/kcore support" if !ARM
 	depends on PROC_FS && MMU
+	help
+	  Provides a virtual ELF core file of the live kernel.  This can
+	  be read with gdb and other ELF tools.  No modifications can be
+	  made using this mechanism.
 
 config PROC_VMCORE
 	bool "/proc/vmcore support"
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo-fix.patch
hpet-allow-user-controlled-mmap-for-user-processes.patch
kernel-doc-improve-no-structured-comments-found-error.patch
kcore-add-kconfig-help-text.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

