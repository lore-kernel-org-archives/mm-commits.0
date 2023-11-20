Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09802C5AD4C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjKTSqP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjKTSqO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:46:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02647C8
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:46:11 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE1C433C8;
        Mon, 20 Nov 2023 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700505970;
        bh=axwp9CLUjj3+nBPPq62sJvLjmg0jNy2hjK5Gk/3CaYg=;
        h=Date:To:From:Subject:From;
        b=OXDvstAM9VTcHllwCilxCiv8S95vN33SpagnKsIF3jJX4Itr/mURQEm3hk5P5sK4O
         Sz/znWELPXNkZZmJ5PYb+4TQgVnpmUFERaC3hH396L8RjW1Vnx6gh8HPjBTCp+sn8+
         PiOqVFSGNtXx1HtGdDmDTdT6w0QstFgg4I6zNl6c=
Date:   Mon, 20 Nov 2023 10:46:10 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        masahiroy@kernel.org, maninder1.s@samsung.com, hca@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkstack-allow-to-pass-minstacksize-parameter.patch added to mm-nonmm-unstable branch
Message-Id: <20231120184610.97CE1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkstack: allow to pass MINSTACKSIZE parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkstack-allow-to-pass-minstacksize-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkstack-allow-to-pass-minstacksize-parameter.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: checkstack: allow to pass MINSTACKSIZE parameter
Date: Mon, 20 Nov 2023 19:37:19 +0100

The checkstack script omits all functions with a stack usage of less than
100 bytes.  However the script already has support for a parameter which
allows to override the default, but it cannot be set with

$ make checkstack

Add a MINSTACKSIZE parameter which allows to change the default. This might
be useful in order to print the stack usage of all functions, or only those
with large stack usage:

$ make checkstack MINSTACKSIZE=0
$ make checkstack MINSTACKSIZE=800

Link: https://lkml.kernel.org/r/20231120183719.2188479-4-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Makefile~checkstack-allow-to-pass-minstacksize-parameter
+++ a/Makefile
@@ -1576,7 +1576,8 @@ help:
 	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 echo  ''
 	@echo  'Static analysers:'
-	@echo  '  checkstack      - Generate a list of stack hogs'
+	@echo  '  checkstack      - Generate a list of stack hogs and consider all functions'
+	@echo  '                    with a stack size larger than MINSTACKSIZE (default: 100)'
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
@@ -2016,9 +2017,10 @@ CHECKSTACK_ARCH := $(SUBARCH)
 else
 CHECKSTACK_ARCH := $(ARCH)
 endif
+MINSTACKSIZE	?= 100
 checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
-	$(PERL) $(srctree)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
+	$(PERL) $(srctree)/scripts/checkstack.pl $(CHECKSTACK_ARCH) $(MINSTACKSIZE)
 
 kernelrelease:
 	@$(filechk_kernel.release)
_

Patches currently in -mm which might be from hca@linux.ibm.com are

checkstack-fix-printed-address.patch
arch-remove-arch_thread_stack_allocator.patch
arch-remove-arch_task_struct_allocator.patch
arch-remove-arch_task_struct_on_stack.patch
checkstack-sort-output-by-size-and-function-name.patch
checkstack-allow-to-pass-minstacksize-parameter.patch

