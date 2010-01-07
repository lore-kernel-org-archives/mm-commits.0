From: akpm@linux-foundation.org
Subject: + mn10300-objcopy-flags-fix.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:21 -0800
Message-ID: <201001070028.o070SLiH027644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368Ab0AGA2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msalter@redhat.com, dhowells@redhat.com


The patch titled
     mn10300: objcopy flags fix
has been added to the -mm tree.  Its filename is
     mn10300-objcopy-flags-fix.patch

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
Subject: mn10300: objcopy flags fix
From: Mark Salter <msalter@redhat.com>

The gcc-4.2.1 based toolchain for MN10300 adds some new note sections
which need to be stripped from the binary image.  This patch takes care of
that.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/Makefile~mn10300-objcopy-flags-fix arch/mn10300/Makefile
--- a/arch/mn10300/Makefile~mn10300-objcopy-flags-fix
+++ a/arch/mn10300/Makefile
@@ -19,7 +19,7 @@ CCDIR	:= $(strip $(patsubst %/specs,%,$(
 KBUILD_CPPFLAGS += -nostdinc -I$(CCDIR)/include
 
 LDFLAGS		:=
-OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
+OBJCOPYFLAGS	:= -O binary -R .note -R .comment -R .GCC-command-line -R .note.gnu.build-id -S
 #LDFLAGS_vmlinux := -Map linkmap.txt
 CHECKFLAGS	+=
 
_

Patches currently in -mm which might be from msalter@redhat.com are

mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch

