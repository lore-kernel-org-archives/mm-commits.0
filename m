Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE969C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiG3BI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940383F01
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3575DB82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0450C433C1;
        Sat, 30 Jul 2022 01:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143308;
        bh=8nEmcH7fupdY3u3q3kOq8xz40Kps0omBLYXiAWohR/I=;
        h=Date:To:From:Subject:From;
        b=OnRb7UYtEmrtIvLnwU/c1/rPMImcJHoszEN7dBi+3xU3Ul4yPMBcOatmHYCp9+3t4
         vOo7BcvevaPxrejgAGqGeOqPxvq9fZellX92Q7IPKxxbnXxUOq7BBz2ixymydnQjdE
         qHMn7LjN5SxfhsQg/PrWwj3pjcwCDLJLiKSzEohc=
Date:   Fri, 29 Jul 2022 18:08:27 -0700
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch removed from -mm tree
Message-Id: <20220730010827.E0450C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/page_owner_sort.c: adjust the indent in is_need()
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-adjust-the-indent-in-is_need.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


