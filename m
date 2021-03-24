Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD0C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E1C619E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhCXXiO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234894AbhCXXiN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D770C61A1D;
        Wed, 24 Mar 2021 23:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616629082;
        bh=+PWyWVPIhWxHDUGAlv3wkQZUPZExiNXGEattJsbNRiY=;
        h=Date:From:To:Subject:From;
        b=myvCxs4v0VbUgvDQdD3XlfIvH13djmMCfsH+2B0YYm5lW1QwvOG0tJYKwQoh/oln2
         bAyNNlGC9HgKJGYSZqEqeHhNeCEPZCaeQ8YCa/ktMKu0vXeC0vyV2vckLsn89eA561
         i+GoSW6JZc0VFq6epMV1Gq77qidrdyMcszNsN5Wo=
Date:   Wed, 24 Mar 2021 16:37:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ralf.ramsauer@oth-regensburg.de,
        joe@perches.com, corbet@lwn.net, lukas.bulwahn@gmail.com
Subject:  + maintainers-assign-pagewalkh-to-memory-management.patch
 added to -mm tree
Message-ID: <20210324233759.J_AZv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: assign pagewalk.h to MEMORY MANAGEMENT
has been added to the -mm tree.  Its filename is
     maintainers-assign-pagewalkh-to-memory-management.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-assign-pagewalkh-to-memory-management.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-assign-pagewalkh-to-memory-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: assign pagewalk.h to MEMORY MANAGEMENT

Patch series "kernel-doc and MAINTAINERS clean-up".

Roughly 900 warnings of about 21.000 kernel-doc warnings in the kernel
tree warn with 'cannot understand function prototype:', i.e., the
kernel-doc parser cannot parse the function's signature.  The majority,
about 600 cases of those, are just struct definitions following the
kernel-doc description.  Further, spot-check investigations suggest that
the authors of the specific kernel-doc descriptions simply were not aware
that the general format for a kernel-doc description for a structure
requires to prefix the struct name with the keyword 'struct', as in
'struct struct_name - Brief description.'.  Details on kernel-doc are at
the Link below.

Without the struct keyword, kernel-doc does not check if the kernel-doc
description fits to the actual struct definition in the source code. 
Fortunately, in roughly a quarter of these cases, the kernel-doc
description is actually complete wrt.  its corresponding struct
definition.  So, the trivial change adding the struct keyword will allow
us to keep the kernel-doc descriptions more consistent for future changes,
by checking for new kernel-doc warnings.

Also, some of the files in ./include/ are not assigned to a specific
MAINTAINERS section and hence have no dedicated maintainer.  So, if
needed, the files in ./include/ are also assigned to the fitting
MAINTAINERS section, as I need to identify whom to send the clean-up patch
anyway.

Here is the change from this kernel-doc janitorial work in the ./include/
directory for MEMORY MANAGEMENT.


This patch (of 2):

Commit a520110e4a15 ("mm: split out a new pagewalk.h header from mm.h")
adds a new file in ./include/linux, but misses to update MAINTAINERS
accordingly.  Hence, ./scripts/get_maintainers.pl
./include/linux/pagewalk.h points only to lkml as general fallback for all
files, whereas the original ./include/linux/mm.h clearly marks this file
part of MEMORY MANAGEMENT.

Assign ./include/linux/pagewalk.h to MEMORY MANAGEMENT.

Link: https://lkml.kernel.org/r/20210322122542.15072-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20210322122542.15072-2-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-assign-pagewalkh-to-memory-management
+++ a/MAINTAINERS
@@ -11557,6 +11557,7 @@ F:	include/linux/gfp.h
 F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
+F:	include/linux/pagewalk.h
 F:	include/linux/vmalloc.h
 F:	mm/
 
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maintainers-assign-pagewalkh-to-memory-management.patch
pagewalk-prefix-struct-kernel-doc-descriptions.patch

