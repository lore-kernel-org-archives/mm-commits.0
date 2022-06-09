Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A41C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 16:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbiFIQtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbiFIQta (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 12:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F5320F5A
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 09:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05D6DB82E56
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 16:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6209C34114;
        Thu,  9 Jun 2022 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654793366;
        bh=TrN4KvSqDPhz+boKvH+BNjWp1PDpXNWrzqSHADTTjYE=;
        h=Date:To:From:Subject:From;
        b=G+hfrDQr1MN/cKgXqrUz7aEgAUU8PE46Dp3qdp3jQRP6UA/vPIqVuqxYkW7/FVOJE
         IIHpVuqliEHlUHqWRaEAJH1Y88xik7n2NG0hx175dFPilvSSWY1KJatyhH+BkkIqdy
         yKnoSlwum1oFzBTE5Tw/ZdmZ5pN54OqKfFLGg9no=
Date:   Thu, 09 Jun 2022 09:49:25 -0700
To:     mm-commits@vger.kernel.org, chenxuebing@jari.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-remove-some-unused-variables.patch added to mm-nonmm-unstable branch
Message-Id: <20220609164926.A6209C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: remove some unused variables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     delayacct-remove-some-unused-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-remove-some-unused-variables.patch

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

delayacct-remove-some-unused-variables.patch

