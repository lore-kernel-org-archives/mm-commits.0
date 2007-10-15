From: akpm@linux-foundation.org
Subject: + modpost-problem-when-symbols-move-from-one-module-to-another.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:44:14 -0700
Message-ID: <200710152044.l9FKiEP7024239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645AbXJOUpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, sam@ravnborg.org


The patch titled
     modpost: fix problem with out of date Module.symvers
has been added to the -mm tree.  Its filename is
     modpost-problem-when-symbols-move-from-one-module-to-another.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: modpost: fix problem with out of date Module.symvers
From: Trent Piepho <xyzzy@speakeasy.org>

When part of build an external module tree, modpost first reads in the
kernel's and then the external tree's Module.symvers files.  From these files
it establishes a symbol => module mapping.  When it later reads in each module
built and processes the symbols it finds, it discovers the symbol=>module
mapping from Module.symvers and leaves it as it is.

The problem comes with a module has been re-named or a symbol has moved from
one module to another, since the Module.symvers file was generated.  modpost
does not update the symbol=>module mapping when it finds the new location of
the symbol when scanning the newly built modules.  This results in the module
containing incorrect dependency information and the new Module.symvers file
written by modpost will also contain the incorrect mappings, perpetuating the
problem to the next build, and so on.

When building the out of kernel development tree for kernel subsystem, like
v4l-dvb or ALSA, deleting the external Module.symvers file before building
(which the kernel build system doesn't do and shouldn't be necessary anyway),
won't fix the problem.  modpost still reads the kernel's Module.symvers, and
since we a building a kernel subsystem, it will define the same symbols as the
external modules.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

origin.patch
git-alsa.patch
git-dvb.patch
modpost-problem-when-symbols-move-from-one-module-to-another.patch
