Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B8EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379891AbiFQC7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379892AbiFQC7M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C2165D35
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C7AB826F4
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A1DC34114;
        Fri, 17 Jun 2022 02:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434745;
        bh=jXkb/hRZbA8r2rUKYbDAJn80f8lQldPAFyb73BVtx14=;
        h=Date:To:From:Subject:From;
        b=d6Xos5zrwQc4+3V4GdvbiDWs06N85LOsxzgZXGKCldKGlsEFCiWNx3pSaCn0rdvan
         8ASXG9JU2qt83lQAmoqMqEXdiTNh585h8kNkgt4RJYgWs34E9Us1KmaDpbb4Z1Pjje
         WfSeFhbVrC84xkoC+YlhlnoeQQ4aatMINQYkf5oI=
Date:   Thu, 16 Jun 2022 19:59:05 -0700
To:     mm-commits@vger.kernel.org, chenxuebing@jari.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] delayacct-remove-some-unused-variables.patch removed from -mm tree
Message-Id: <20220617025905.97A1DC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: delayacct: remove some unused variables
has been removed from the -mm tree.  Its filename was
     delayacct-remove-some-unused-variables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: cxbing <chenxuebing@jari.cn>
Subject: delayacct: remove some unused variables
Date: Thu, 9 Jun 2022 07:44:59 -0700

Drop the unused variables *done* and *count*.

Link: https://lkml.kernel.org/r/20220609144459.86379-1-zhangkkoo@126.com
Signed-off-by: cxbing <chenxuebing@jari.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/tools/accounting/getdelays.c~delayacct-remove-some-unused-variables
+++ a/tools/accounting/getdelays.c
@@ -45,7 +45,6 @@
 		exit(code);			\
 	} while (0)
 
-int done;
 int rcvbufsz;
 char name[100];
 int dbg;
@@ -285,7 +284,6 @@ int main(int argc, char *argv[])
 	pid_t rtid = 0;
 
 	int fd = 0;
-	int count = 0;
 	int write_file = 0;
 	int maskset = 0;
 	char *logfile = NULL;
@@ -495,7 +493,6 @@ int main(int argc, char *argv[])
 				len2 = 0;
 				/* For nested attributes, na follows */
 				na = (struct nlattr *) NLA_DATA(na);
-				done = 0;
 				while (len2 < aggr_len) {
 					switch (na->nla_type) {
 					case TASKSTATS_TYPE_PID:
@@ -509,7 +506,6 @@ int main(int argc, char *argv[])
 							printf("TGID\t%d\n", rtid);
 						break;
 					case TASKSTATS_TYPE_STATS:
-						count++;
 						if (print_delays)
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
_

Patches currently in -mm which might be from chenxuebing@jari.cn are


