From: akpm@osdl.org
Subject: - kbuild-write-astest-files-to-kbuild_extmod-directory.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:31 -0800
Message-ID: <200612081104.kB8B4VTX018562@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938032AbWLHLEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@gentoo.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: Write astest files to $(KBUILD_EXTMOD) directory
has been removed from the -mm tree.  Its filename was
     kbuild-write-astest-files-to-kbuild_extmod-directory.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: kbuild: Write astest files to $(KBUILD_EXTMOD) directory
From: Daniel Drake <dsd@gentoo.org>

The astest code in 2.6.19 causes problems for Gentoo and other
distributions building external kernel modules in sandboxes.  kbuild has
generally been pretty good at not violating the sandbox for quite a while,
I hope we can keep it that way.

Right now it writes to a temporary astest file in the current directory
(i.e.  /usr/src/linux), this is because it is found that writing to
/dev/null is not safe because as deletes its output file on failure.

To clarify what a sandbox is: Gentoo's package system compiles the package
in /var/tmp/portage and while that package is building it restricts writes
to parts of the filesystem outside of /var/tmp/portage and /tmp.  If the
external module tries to write to another location on the real filesystem
such as /usr/src/linux, the build is aborted due to sandbox violation.

This patch prefixes the astest file path with the KBUILD_EXTMOD path if an
external kernel module is being built.  The behaviour in other situations
is unmodified.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/Kbuild.include |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-write-astest-files-to-kbuild_extmod-directory scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-write-astest-files-to-kbuild_extmod-directory
+++ a/scripts/Kbuild.include
@@ -66,9 +66,11 @@ as-option = $(shell if $(CC) $(CFLAGS) $
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
 
-as-instr = $(shell if echo -e "$(1)" | $(AS) >/dev/null 2>&1 -W -Z -o astest$$$$.out ; \
+as-instr = $(shell if echo -e "$(1)" | $(AS) >/dev/null 2>&1 -W -Z -o \
+		   $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)astest$$$$.out ; \
 		   then echo "$(2)"; else echo "$(3)"; fi; \
-	           rm -f astest$$$$.out)
+	           rm -f \
+		   $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)astest$$$$.out)
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
_

Patches currently in -mm which might be from dsd@gentoo.org are

origin.patch
some-kbuild-fix.patch

