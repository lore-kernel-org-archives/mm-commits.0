From: akpm@linux-foundation.org
Subject: + kbuild-fix-config_cross_compile-issue-in-config.patch added to -mm tree
Date: Mon, 21 Jun 2010 12:06:20 -0700
Message-ID: <201006211906.o5LJ6LPb031516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268Ab0FUTG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 15:06:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiago.maluta@gmail.com, mmarek@suse.cz


The patch titled
     kbuild: fix CONFIG_CROSS_COMPILE issue in .config
has been added to the -mm tree.  Its filename is
     kbuild-fix-config_cross_compile-issue-in-config.patch

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
Subject: kbuild: fix CONFIG_CROSS_COMPILE issue in .config
From: Tiago Maluta <tiago.maluta@gmail.com>

Linux has an recent option to define CROSS_COMPILE in menuconfig.

Typically, one of the options when building for another target is
('arm' is just an example):

# make ARCH=arm CROSS_COMPILE=arm-cc O=../build

If I omit CROSS_COMPILE and use the new way in .config:
CONFIG_CROSS_COMPILE="arm-cc"

I got:

   cc1: error: unrecognized command line option "-mlittle-endian"
   cc1: error: unrecognized command line option "-mabi=aapcs-linux"
   cc1: error: unrecognized command line option "-mno-thumb-interwork"
   /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -march= switch
   /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -mtune= switch
   make[2]: *** [kernel/bounds.s] Error 1
   make[1]: *** [prepare0] Error 2
   make: *** [sub-make] Error 2

Verbose output clearly says that I'm using the host compiler instead cross
compiler.  This patch fixed my problem.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-fix-config_cross_compile-issue-in-config Makefile
--- a/Makefile~kbuild-fix-config_cross_compile-issue-in-config
+++ a/Makefile
@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
-CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
+CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
_

Patches currently in -mm which might be from tiago.maluta@gmail.com are

kbuild-fix-config_cross_compile-issue-in-config.patch

