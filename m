Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D9FC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 01:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiGRB0J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 21:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiGRB0I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 21:26:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF3212D1E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 18:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 827E1CE10BA
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 01:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9014AC341C0;
        Mon, 18 Jul 2022 01:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658107563;
        bh=IzhYTBSmB2LtbaUF0AWK2lE8z+GOm9+288s/FxkdUGk=;
        h=Date:To:From:Subject:From;
        b=hyoqTVLs63RuH+eFX/MV9I126ehr0whLHLndPL5TifOGD6ZvkmAWinLNDaADDvaGY
         zGKgUqQtgTeMSb7RgGKGDzGU52YU8z+pRN/mOePA2XbfvC7HPOpapjiD47lT64MtXI
         mVe7BIShnA57l57TXJFLnEsFQ1vYFkNPKCXaWGrM=
Date:   Sun, 17 Jul 2022 18:26:02 -0700
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch added to mm-unstable branch
Message-Id: <20220718012603.9014AC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: adjust the indent in is_need()
has been added to the -mm mm-unstable branch.  Its filename is
     tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch

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
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: adjust the indent in is_need()
Date: Mon, 18 Jul 2022 03:55:06 +0800

I noticed one more indentation than necessary in is_need().

Link: https://lkml.kernel.org/r/20220717195506.7602-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-adjust-the-indent-in-is_need
+++ a/tools/vm/page_owner_sort.c
@@ -470,23 +470,23 @@ static bool match_str_list(const char *s
 
 static bool is_need(char *buf)
 {
-		if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
-			return false;
-		if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
-			return false;
-		if ((filter & FILTER_TGID) &&
-			!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
-			return false;
+	if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
+		return false;
+	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
+		return false;
+	if ((filter & FILTER_TGID) &&
+		!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
+		return false;
 
-		char *comm = get_comm(buf);
+	char *comm = get_comm(buf);
 
-		if ((filter & FILTER_COMM) &&
-		!match_str_list(comm, fc.comms, fc.comms_size)) {
-			free(comm);
-			return false;
-		}
+	if ((filter & FILTER_COMM) &&
+	!match_str_list(comm, fc.comms, fc.comms_size)) {
 		free(comm);
-		return true;
+		return false;
+	}
+	free(comm);
+	return true;
 }
 
 static void add_list(char *buf, int len, char *ext_buf)
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch

