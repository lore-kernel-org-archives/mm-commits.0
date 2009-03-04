From: akpm@linux-foundation.org
Subject: + libfs-make-simple_read_from_buffer-conventional-fix-2.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:53:20 -0800
Message-ID: <200903042253.n24MrKjm012581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbZCDWx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, rostedt@goodmis.org, srostedt@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     libfs-make-simple_read_from_buffer-conventional-fix-2
has been added to the -mm tree.  Its filename is
     libfs-make-simple_read_from_buffer-conventional-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs-make-simple_read_from_buffer-conventional-fix-2
From: "H. Peter Anvin" <hpa@zytor.com>

Looking at the whole function, the code nowhere else looks for the case
count == 0, and as a result we end up returning -EFAULT for count == 0.

However, rather than backing out the above I think this is the better fix
for that problem.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/libfs.c~libfs-make-simple_read_from_buffer-conventional-fix-2 fs/libfs.c
--- a/fs/libfs.c~libfs-make-simple_read_from_buffer-conventional-fix-2
+++ a/fs/libfs.c
@@ -530,7 +530,7 @@ ssize_t simple_read_from_buffer(void __u
 
 	if (pos < 0)
 		return -EINVAL;
-	if (pos >= available)
+	if (pos >= available || !count)
 		return 0;
 	if (count > available - pos)
 		count = available - pos;
_

Patches currently in -mm which might be from hpa@zytor.com are

linux-next.patch
x86-oqo-depends-on-input_polldev.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-simplify-highmem-related-kconfig-entries.patch
libfs-make-simple_read_from_buffer-conventional.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
libfs-make-simple_read_from_buffer-conventional-fix-2.patch
tty-pty-lookup-retval-fixup.patch
x86-dmi_scan_machine-uses-uninitialized-address-on-x86-efi.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
introduce-pr_cont-macro.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch

