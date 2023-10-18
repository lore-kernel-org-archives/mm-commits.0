Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01117CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbjJRVhu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbjJRVg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3241B4
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4F3C433C9;
        Wed, 18 Oct 2023 21:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664971;
        bh=pGI6iNos0t5iSst0DWd9roQmtA0oo++9Caihkvr+E/Q=;
        h=Date:To:From:Subject:From;
        b=ER3r5dJOsa6+R59Nu2UWOOSWuHI3dfgHg1ElqV75qkQCUke0qYNCr1e4XN3zr//Fy
         Fov3XKq0VEFOBs/G0rTajpCzmI7/bjLELbqlfB8dfEMH8IzdP//3+iWgzWirl9Hc/m
         YZQNBKZmPkgl8l/+n3r/I/P28kXY0wWIjoiwaCIQ=
Date:   Wed, 18 Oct 2023 14:36:11 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, djakov@kernel.org,
        aquini@redhat.com, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-update-the-usage-output-to-be-more-organized.patch removed from -mm tree
Message-Id: <20231018213611.7E4F3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/mm: update the usage output to be more organized
has been removed from the -mm tree.  Its filename was
     tools-mm-update-the-usage-output-to-be-more-organized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: tools/mm: update the usage output to be more organized
Date: Fri, 13 Oct 2023 15:03:49 -0400

Organize the usage options alphabetically and improve the description of
some options.  Also separate the more complicated cull options from the
single use compare options.

Link: https://lkml.kernel.org/r/20231013190350.579407-6-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Georgi Djakov <djakov@kernel.org>
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


