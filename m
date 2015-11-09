From: akpm@linux-foundation.org
Subject: [merged] kexec-use-file-name-as-the-output-message-prefix.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:42 -0800
Message-ID: <5640fe76.oJScfaXn7up1hGnS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbKIUNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: use file name as the output message prefix
has been removed from the -mm tree.  Its filename was
     kexec-use-file-name-as-the-output-message-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kexec: use file name as the output message prefix

kexec output message misses the prefix "kexec", when Dave Young split the
kexec code.  Now, we use file name as the output message prefix.

Currently, the format of output message:
[  140.290795] SYSC_kexec_load: hello, world
[  140.291534] kexec: sanity_check_segment_list: hello, world

Ideally, the format of output message:
[   30.791503] kexec: SYSC_kexec_load, Hello, world
[   79.182752] kexec_core: sanity_check_segment_list, Hello, world

Remove the custom prefix "kexec" in output message.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c      |    2 ++
 kernel/kexec_core.c |    4 ++--
 kernel/kexec_file.c |    2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/kexec.c~kexec-use-file-name-as-the-output-message-prefix kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-file-name-as-the-output-message-prefix
+++ a/kernel/kexec.c
@@ -6,6 +6,8 @@
  * Version 2.  See the file COPYING for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/mm.h>
 #include <linux/file.h>
diff -puN kernel/kexec_core.c~kexec-use-file-name-as-the-output-message-prefix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-use-file-name-as-the-output-message-prefix
+++ a/kernel/kexec_core.c
@@ -6,7 +6,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-#define pr_fmt(fmt)	"kexec: " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/capability.h>
 #include <linux/mm.h>
@@ -1027,7 +1027,7 @@ static int __init crash_notes_memory_ini
 
 	crash_notes = __alloc_percpu(size, align);
 	if (!crash_notes) {
-		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
+		pr_warn("Memory allocation for saving cpu register states failed\n");
 		return -ENOMEM;
 	}
 	return 0;
diff -puN kernel/kexec_file.c~kexec-use-file-name-as-the-output-message-prefix kernel/kexec_file.c
--- a/kernel/kexec_file.c~kexec-use-file-name-as-the-output-message-prefix
+++ a/kernel/kexec_file.c
@@ -9,6 +9,8 @@
  * Version 2.  See the file COPYING for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/mm.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from mnfhuang@gmail.com are


