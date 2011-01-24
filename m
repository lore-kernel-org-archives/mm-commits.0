From: akpm@linux-foundation.org
Subject: + binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch added to -mm tree
Date: Mon, 24 Jan 2011 15:13:22 -0800
Message-ID: <201101242313.p0ONDMr9016793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab1AXXNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 18:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com


The patch titled
     binfmt_elf: quiet GCC-4.6 'set but not used' warning in load_elf_binary()
has been added to the -mm tree.  Its filename is
     binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch

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
Subject: binfmt_elf: quiet GCC-4.6 'set but not used' warning in load_elf_binary()
From: David Daney <ddaney@caviumnetworks.com>

With GCC-4.6 we get warnings about things being 'set but not used'.

In load_elf_binary() this can happen with reloc_func_desc if ELF_PLAT_INIT
is defined, but doesn't use the reloc_func_desc argument.

Quiet the warning/error by marking reloc_func_desc as __maybe_unused.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary
+++ a/fs/binfmt_elf.c
@@ -570,7 +570,7 @@ static int load_elf_binary(struct linux_
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
-	unsigned long reloc_func_desc = 0;
+	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct {
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

linux-next.patch
rtc-propagate-error-handling-via-rtc_timer_enqueue-properly.patch
binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch

