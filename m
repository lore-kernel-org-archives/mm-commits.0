From: akpm@linux-foundation.org
Subject: [merged] mn10300-objcopy-flags-fix.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:20 -0800
Message-ID: <201001112019.o0BKJKFS025560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab0AKUcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:32:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: objcopy flags fix
has been removed from the -mm tree.  Its filename was
     mn10300-objcopy-flags-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

