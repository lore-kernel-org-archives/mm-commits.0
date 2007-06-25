From: akpm@linux-foundation.org
Subject: + eventfd-clean-compile-when-config_eventfd=n.patch added to -mm tree
Date: Mon, 25 Jun 2007 14:27:42 -0700
Message-ID: <200706252127.l5PLRgMb011173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbXFYV2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davidel@xmailserver.org


The patch titled
     eventfd: clean compile when CONFIG_EVENTFD=n
has been added to the -mm tree.  Its filename is
     eventfd-clean-compile-when-config_eventfd=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eventfd: clean compile when CONFIG_EVENTFD=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warning and add parameter checking when CONFIG_EVENTFD=n:

fs/aio.c: In function 'aio_complete':
fs/aio.c:955: warning: statement with no effect

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/eventfd.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/eventfd.h~eventfd-clean-compile-when-config_eventfd=n include/linux/eventfd.h
--- a/include/linux/eventfd.h~eventfd-clean-compile-when-config_eventfd=n
+++ a/include/linux/eventfd.h
@@ -19,7 +19,8 @@ int eventfd_signal(struct file *file, in
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-#define eventfd_signal(f, n) 0
+static inline int eventfd_signal(struct file *file, int n)
+{ return 0; }
 
 #endif /* CONFIG_EVENTFD */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
