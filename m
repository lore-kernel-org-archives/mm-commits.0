Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CEDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jan 2022 22:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiALWk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 17:40:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50022 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiALWk1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 17:40:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 367C4B8216D
        for <mm-commits@vger.kernel.org>; Wed, 12 Jan 2022 22:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CDCC36AE5;
        Wed, 12 Jan 2022 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642027224;
        bh=YBZfS8twv3X43IY3lhkNk8j0F28FVHxsp9785KDwp58=;
        h=Date:From:To:Subject:From;
        b=ayr8KbnBx1zuN8EwtMIwY70q9jeyE0lGgk2cJ1/iuRkl5GOOdh2c7dQhK/Tb3ydj1
         bgVWMaldcYtc3X685jynbMhqTNEEN0aYOY+V8M9jON/AUtQCHz16myJs4aimTHRJPk
         cln6R0se8Q04tvGz67edrJW5LVht2ta9pw5AnWmw=
Date:   Wed, 12 Jan 2022 14:40:24 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, geert+renesas@glider.be,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, yzaikin@google.com
Subject:  +
 sysctl-fix-duplicate-path-separator-in-printed-entries.patch added to -mm
 tree
Message-ID: <20220112224024.UOzFUKvLL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix duplicate path separator in printed entries
has been added to the -mm tree.  Its filename is
     sysctl-fix-duplicate-path-separator-in-printed-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-fix-duplicate-path-separator-in-printed-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-fix-duplicate-path-separator-in-printed-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sysctl: fix duplicate path separator in printed entries

sysctl_print_dir() always terminates the printed path name with a slash,
so printing a slash before the file part causes a duplicate like in

    sysctl duplicate entry: /kernel//perf_user_access

Fix this by dropping the extra slash.

Link: https://lkml.kernel.org/r/e3054d605dc56f83971e4b6d2f5fa63a978720ad.1641551872.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/proc_sysctl.c~sysctl-fix-duplicate-path-separator-in-printed-entries
+++ a/fs/proc/proc_sysctl.c
@@ -163,7 +163,7 @@ static int insert_entry(struct ctl_table
 		else {
 			pr_err("sysctl duplicate entry: ");
 			sysctl_print_dir(head->parent);
-			pr_cont("/%s\n", entry->procname);
+			pr_cont("%s\n", entry->procname);
 			return -EEXIST;
 		}
 	}
@@ -1020,8 +1020,8 @@ failed:
 	if (IS_ERR(subdir)) {
 		pr_err("sysctl could not get directory: ");
 		sysctl_print_dir(dir);
-		pr_cont("/%*.*s %ld\n",
-			namelen, namelen, name, PTR_ERR(subdir));
+		pr_cont("%*.*s %ld\n", namelen, namelen, name,
+			PTR_ERR(subdir));
 	}
 	drop_sysctl_table(&dir->header);
 	if (new)
@@ -1626,7 +1626,7 @@ static void put_links(struct ctl_table_h
 		else {
 			pr_err("sysctl link missing during unregister: ");
 			sysctl_print_dir(parent);
-			pr_cont("/%s\n", name);
+			pr_cont("%s\n", name);
 		}
 	}
 }
_

Patches currently in -mm which might be from geert+renesas@glider.be are

sysctl-fix-duplicate-path-separator-in-printed-entries.patch

