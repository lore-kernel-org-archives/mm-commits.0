From: akpm@linux-foundation.org
Subject: + cscope-build-warning.patch added to -mm tree
Date: Tue, 13 Nov 2007 11:40:40 -0800
Message-ID: <200711131940.lADJeemB030795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbXKMTku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 14:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, jirislaby@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     cscope build warning
has been added to the -mm tree.  Its filename is
     cscope-build-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: cscope build warning
=46rom: Sam Ravnborg <sam@ravnborg.org>

On Tue, Nov 13, 2007 at 01:40:45PM +0100, Jiri Slaby wrote:
> On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploade=
d to
>
> $ uname -a
> Linux bellona 2.6.23-rc8-mm2_64 #58 SMP Fri Sep 28 08:52:12 CEST 2007=
 x86_64
> x86_64 x86_64 GNU/Linux
> $ make O=3D../bu cscope
>   FILELST cscope.files
> find: /home/l/latest/xxx/arch/x86_64: nen=C3=AD souborem ani adres=C3=
=A1=C5=99em
>   MAKE    cscope.out
>

I have following fix queued in my inbox:

This patch fixed the following errors when doing "make cscope" and
"make cscope ARCH=3Dum".

  FILELST cscope.files
find: arch/i386: No such file or directory
  MAKE    cscope.out

  FILELST cscope.files
find: include/asm-i386: No such file or directory
  MAKE    cscope.out

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~cscope-build-warning Makefile
--- a/Makefile~cscope-build-warning
+++ a/Makefile
@@ -1323,6 +1323,7 @@ ALLINCLUDE_ARCHS :=3D $(ARCH) $(SUBARCH)
 else
 ALLINCLUDE_ARCHS :=3D $(SRCARCH)
 endif
+ALLINCLUDE_ARCHS :=3D $(shell echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/=
x86/" -e "s/x86_64/x86/")
 else
 #Allow user to specify only ALLSOURCE_PATHS on the command line, keepi=
ng existing behavour.
 ALLINCLUDE_ARCHS :=3D $(ALLSOURCE_ARCHS)
@@ -1332,7 +1333,7 @@ endif
 ifeq ($(ARCH), $(SRCARCH))
 ALLSOURCE_ARCHS :=3D $(ARCH)
 else
-ALLSOURCE_ARCHS :=3D $(ARCH) $(SRCARCH)
+ALLSOURCE_ARCHS :=3D $(shell echo $(ARCH) $(SRCARCH)|sed -e "s/i386/x8=
6/" -e "s/x86_64/x86/")
 endif
=20
 define find-sources
_

Patches currently in -mm which might be from sam@ravnborg.org are

uml-fix-symlink-loops.patch
git-kbuild.patch
kconfig-use-getopt-in-confc-for-handling-command-line.patch
cscope-build-warning.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
m68k-use-cc-cross-prefix.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
