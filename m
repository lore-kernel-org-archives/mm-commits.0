Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FB7CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjJNWQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjJNWQ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:16:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD823DA
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:16:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C867C433C8;
        Sat, 14 Oct 2023 22:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697321787;
        bh=GTSxBAH28DyKo+lKtwzmUstKo1YYmVSfQORNpaR1uOw=;
        h=Date:To:From:Subject:From;
        b=Qm0NO/UrbxUy+TI6gTgRc1gMt7jBuUQsEtvWLh9rGLnXPSPo0HGeaMTLL8FEjHdPg
         SkGC9ewB0ARp54ItMpywAjpYDIYTnNv9Sl0t09OfhFchasHMzFH9Pq573BUQ/arliq
         w3+9l/jbq3b1l9td6LnnFO/gr73pbDtnqsbk+vd4=
Date:   Sat, 14 Oct 2023 15:16:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, raquini@redhat.com,
        djakov@kernel.org, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-update-the-usage-output-to-be-more-organized.patch added to mm-unstable branch
Message-Id: <20231014221627.0C867C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/mm: update the usage output to be more organized
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-update-the-usage-output-to-be-more-organized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-update-the-usage-output-to-be-more-organized.patch

This patch will later appear in the mm-unstable branch at
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
From: Audra Mitchell <audra@redhat.com>
Subject: tools/mm: update the usage output to be more organized
Date: Fri, 13 Oct 2023 15:03:49 -0400

Organize the usage options alphabetically and improve the description of
some options.  Also separate the more complicated cull options from the
single use compare options.

Link: https://lkml.kernel.org/r/20231013190350.579407-6-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-update-the-usage-output-to-be-more-organized
+++ a/tools/mm/page_owner_sort.c
@@ -634,19 +634,26 @@ static void print_allocator(FILE *out, i
 static void usage(void)
 {
 	printf("Usage: ./page_owner_sort [OPTIONS] <input> <output>\n"
-		"-m\t\tSort by total memory.\n"
-		"-s\t\tSort by the stack trace.\n"
-		"-t\t\tSort by times (default).\n"
-		"-p\t\tSort by pid.\n"
-		"-P\t\tSort by tgid.\n"
-		"-n\t\tSort by task command name.\n"
-		"-a\t\tSort by memory allocate time.\n"
-		"-d\t\tPrint debug information.\n"
-		"--pid <pidlist>\tSelect by pid. This selects the information of blocks whose process ID numbers appear in <pidlist>.\n"
-		"--tgid <tgidlist>\tSelect by tgid. This selects the information of blocks whose Thread Group ID numbers appear in <tgidlist>.\n"
-		"--name <cmdlist>\n\t\tSelect by command name. This selects the information of blocks whose command name appears in <cmdlist>.\n"
-		"--cull <rules>\tCull by user-defined rules.<rules> is a single argument in the form of a comma-separated list with some common fields predefined\n"
-		"--sort <order>\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"-a\t\t\tSort by memory allocation time.\n"
+		"-m\t\t\tSort by total memory.\n"
+		"-n\t\t\tSort by task command name.\n"
+		"-p\t\t\tSort by pid.\n"
+		"-P\t\t\tSort by tgid.\n"
+		"-s\t\t\tSort by the stacktrace.\n"
+		"-t\t\t\tSort by number of times record is seen (default).\n\n"
+		"--pid <pidlist>\t\tSelect by pid. This selects the information"
+		" of\n\t\t\tblocks whose process ID numbers appear in <pidlist>.\n"
+		"--tgid <tgidlist>\tSelect by tgid. This selects the information"
+		" of\n\t\t\tblocks whose Thread Group ID numbers appear in "
+		"<tgidlist>.\n"
+		"--name <cmdlist>\tSelect by command name. This selects the"
+		" information\n\t\t\tof blocks whose command name appears in"
+		" <cmdlist>.\n"
+		"--cull <rules>\t\tCull by user-defined rules. <rules> is a "
+		"single\n\t\t\targument in the form of a comma-separated list "
+		"with some\n\t\t\tcommon fields predefined (pid, tgid, comm, "
+		"stacktrace, allocator)\n"
+		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
 	);
 }
 
_

Patches currently in -mm which might be from audra@redhat.com are

mm-page_owner-remove-free_ts-from-page_owner-output.patch
tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch
tools-mm-filter-out-timestamps-for-correct-collation.patch
tools-mm-fix-the-default-case-for-page_owner_sort.patch
tools-mm-update-the-usage-output-to-be-more-organized.patch

