From: akpm@linux-foundation.org
Subject: +
 capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch added to -mm tree
Date: Tue, 14 Jul 2015 13:33:28 -0700
Message-ID: <55a57218.d86LbpEau/LqKrvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbbGNUd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 16:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, aaronmdjones@gmail.com, ahferroin7@gmail.com, cl@linux.com, corbet@lwn.net, james.l.morris@oracle.com, jarkko.sakkinen@linux.intel.com, keescook@chromium.org, morgan@kernel.org, msa@moth.iki.fi, mtk.manpages@gmail.com, serge.hallyn@canonical.com, tytso@mit.edu, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: capabilities: add a securebit to disable PR_CAP_AMBIENT_RAISE
has been added to the -mm tree.  Its filename is
     capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: capabilities: add a securebit to disable PR_CAP_AMBIENT_RAISE

Per Andrew Morgan's request, add a securebit to allow admins to disable
PR_CAP_AMBIENT_RAISE.  This securebit will prevent processes from adding
capabilities to their ambient set.

For simplicity, this disables PR_CAP_AMBIENT_RAISE entirely rather than
just disabling setting previously cleared bits.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Aaron Jones <aaronmdjones@gmail.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Markku Savela <msa@moth.iki.fi>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/securebits.h |   11 ++++++++++-
 security/commoncap.c            |    3 ++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/securebits.h~capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise include/uapi/linux/securebits.h
--- a/include/uapi/linux/securebits.h~capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise
+++ a/include/uapi/linux/securebits.h
@@ -43,9 +43,18 @@
 #define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
 #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
 
+/* When set, a process cannot add new capabilities to its ambient set. */
+#define SECURE_NO_CAP_AMBIENT_RAISE		6
+#define SECURE_NO_CAP_AMBIENT_RAISE_LOCKED	7  /* make bit-6 immutable */
+
+#define SECBIT_NO_CAP_AMBIENT_RAISE (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
+#define SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED \
+			(issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE_LOCKED))
+
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
-				 issecure_mask(SECURE_KEEP_CAPS))
+				 issecure_mask(SECURE_KEEP_CAPS) | \
+				 issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
 #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
 
 #endif /* _UAPI_LINUX_SECUREBITS_H */
diff -puN security/commoncap.c~capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise security/commoncap.c
--- a/security/commoncap.c~capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise
+++ a/security/commoncap.c
@@ -993,7 +993,8 @@ int cap_task_prctl(int option, unsigned
 			if (arg2 == PR_CAP_AMBIENT_RAISE &&
 			    (!cap_raised(current_cred()->cap_permitted, arg3) ||
 			     !cap_raised(current_cred()->cap_inheritable,
-					 arg3)))
+					 arg3) ||
+			     issecure(SECURE_NO_CAP_AMBIENT_RAISE)))
 				return -EPERM;
 
 			new = prepare_creds();
_

Patches currently in -mm which might be from luto@kernel.org are

capabilities-ambient-capabilities.patch
capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
linux-next.patch

