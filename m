From: Andrew Morton <akpm@linux-foundation.org>
Subject: + binfmt_elf-femove-the-set_fs-in-fill_siginfo_note.patch
 added to -mm tree
Date: Thu, 23 Apr 2020 19:06:41 -0700
Message-ID: <20200424020641.7dn6gu5UT%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgDXCGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 22:06:42 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elf: femove the set_fs in fill_siginfo_note
has been added to the -mm tree.  Its filename is
     binfmt_elf-femove-the-set_fs-in-fill_siginfo_note.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-femove-the-set_fs-in-fill_siginfo_note.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-femove-the-set_fs-in-fill_siginfo_note.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: binfmt_elf: femove the set_fs in fill_siginfo_note

The code in binfmt_elf.c is different from the rest of the code that
processes siginfo, as it sends siginfo from a kernel buffer to a file
rather than from kernel memory to userspace buffers.  To remove its use of
set_fs the code needs some different siginfo helpers.

Add the helper copy_siginfo_to_external to copy from the kernel's internal
siginfo layout to a buffer in the siginfo layout that userspace expects.

Modify fill_siginfo_note to use copy_siginfo_to_external instead of set_fs
and copy_siginfo_to_user.

Update compat_binfmt_elf.c to use the previously added
copy_siginfo_to_external32 to handle the compat case.

Link: http://lkml.kernel.org/r/20200421154204.252921-4-hch@lst.de
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |    5 +----
 fs/compat_binfmt_elf.c |    2 +-
 include/linux/signal.h |    8 ++++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/fs/binfmt_elf.c~binfmt_elf-femove-the-set_fs-in-fill_siginfo_note
+++ a/fs/binfmt_elf.c
@@ -1552,10 +1552,7 @@ static void fill_auxv_note(struct memelf
 static void fill_siginfo_note(struct memelfnote *note, user_siginfo_t *csigdata,
 		const kernel_siginfo_t *siginfo)
 {
-	mm_segment_t old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	copy_siginfo_to_user((user_siginfo_t __user *) csigdata, siginfo);
-	set_fs(old_fs);
+	copy_siginfo_to_external(csigdata, siginfo);
 	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
 }
 
--- a/fs/compat_binfmt_elf.c~binfmt_elf-femove-the-set_fs-in-fill_siginfo_note
+++ a/fs/compat_binfmt_elf.c
@@ -39,7 +39,7 @@
  */
 #define user_long_t		compat_long_t
 #define user_siginfo_t		compat_siginfo_t
-#define copy_siginfo_to_user	copy_siginfo_to_user32
+#define copy_siginfo_to_external	copy_siginfo_to_external32
 
 /*
  * The machine-dependent core note format types are defined in elfcore-compat.h,
--- a/include/linux/signal.h~binfmt_elf-femove-the-set_fs-in-fill_siginfo_note
+++ a/include/linux/signal.h
@@ -24,6 +24,14 @@ static inline void clear_siginfo(kernel_
 
 #define SI_EXPANSION_SIZE (sizeof(struct siginfo) - sizeof(struct kernel_siginfo))
 
+static inline void copy_siginfo_to_external(siginfo_t *to,
+					    const kernel_siginfo_t *from)
+{
+	memcpy(to, from, sizeof(*from));
+	memset(((char *)to) + sizeof(struct kernel_siginfo), 0,
+		SI_EXPANSION_SIZE);
+}
+
 int copy_siginfo_to_user(siginfo_t __user *to, const kernel_siginfo_t *from);
 int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from);
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

signal-factor-copy_siginfo_to_external32-from-copy_siginfo_to_user32.patch
binfmt_elf-femove-the-set_fs-in-fill_siginfo_note.patch
