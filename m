From: akpm@linux-foundation.org
Subject: [merged]
 binfmt_elf-remove-the-set_fs-in-fill_siginfo_note.patch removed from -mm
 tree
Date: Thu, 07 May 2020 09:55:39 -0700
Message-ID: <20200507165539.ctqHqZkxQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGQzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 12:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elf: remove the set_fs in fill_siginfo_note
has been removed from the -mm tree.  Its filename was
     binfmt_elf-remove-the-set_fs-in-fill_siginfo_note.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: binfmt_elf: remove the set_fs in fill_siginfo_note

The code in binfmt_elf.c is differnt from the rest of the code that
processes siginfo, as it sends siginfo from a kernel buffer to a file
rather than from kernel memory to userspace buffers.  To remove it's use
of set_fs the code needs some different siginfo helpers.

Add the helper copy_siginfo_to_external to copy from the kernel's internal
siginfo layout to a buffer in the siginfo layout that userspace expects.

Modify fill_siginfo_note to use copy_siginfo_to_external instead of set_fs
and copy_siginfo_to_user.

Update compat_binfmt_elf.c to use the previously added
copy_siginfo_to_external32 to handle the compat case.

Link: http://lkml.kernel.org/r/20200505101256.3121270-6-hch@lst.de
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |    5 +----
 fs/compat_binfmt_elf.c |    2 +-
 include/linux/signal.h |    8 ++++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/fs/binfmt_elf.c~binfmt_elf-remove-the-set_fs-in-fill_siginfo_note
+++ a/fs/binfmt_elf.c
@@ -1685,10 +1685,7 @@ static void fill_auxv_note(struct memelf
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
 
--- a/fs/compat_binfmt_elf.c~binfmt_elf-remove-the-set_fs-in-fill_siginfo_note
+++ a/fs/compat_binfmt_elf.c
@@ -43,7 +43,7 @@
  */
 #define user_long_t		compat_long_t
 #define user_siginfo_t		compat_siginfo_t
-#define copy_siginfo_to_user	copy_siginfo_to_user32
+#define copy_siginfo_to_external	copy_siginfo_to_external32
 
 /*
  * The machine-dependent core note format types are defined in elfcore-compat.h,
--- a/include/linux/signal.h~binfmt_elf-remove-the-set_fs-in-fill_siginfo_note
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
