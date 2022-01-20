Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95860C4321E
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377914AbiATV3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377992AbiATV3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18E2AB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A584EC340E0;
        Thu, 20 Jan 2022 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714180;
        bh=1pbN1ZLU6nU7eKSgZhRuqGxAg+E1cMQn2fq7Ox1rUOc=;
        h=Date:From:To:Subject:From;
        b=M0xPbXCzWMftarGvDChv3ubOX6t8BpUPXJg+uEq4/J+o7ivIC0esQDORMoQ/W0BCd
         W7CrjJRw3evJniVVJmPc42/m2iwRiKO313xOO/2ZmIN5fcuw5Mv+bMzrgR+8zhgB0E
         w5mHwTCjztqZKPoXsx8NwiCzKInCRiGQ98lDuSTA=
Date:   Thu, 20 Jan 2022 13:29:40 -0800
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, geert+renesas@glider.be,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, yzaikin@google.com
Subject:  [merged]
 sysctl-fix-duplicate-path-separator-in-printed-entries.patch removed from
 -mm tree
Message-ID: <20220120212940.kfm8iC0-v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix duplicate path separator in printed entries
has been removed from the -mm tree.  Its filename was
     sysctl-fix-duplicate-path-separator-in-printed-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


