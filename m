Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0477AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbiEMT13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383941AbiEMT0A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D4938D8C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E54BB61598
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4872AC34116;
        Fri, 13 May 2022 19:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469819;
        bh=60f3HWwnWzMO4mDJpfLciwoVmgD76dWlW6maXEr1+Rc=;
        h=Date:To:From:Subject:From;
        b=A1nLpVos/DOJL1vt/7TWyGBr+LE0Lnf50U6phXJfqdHn1M2cPVqDAOAoviK2GkVyJ
         cMwoeM3Ze/4YNPgFm5wrHw7XlLewXK7SKa2aKTOMhnBIdBRjTE9KN/Cmd+SfSeY40Y
         skqWvu4eDrCIzr/9hIKbpbIirkRYn+rERIamIohU=
Date:   Fri, 13 May 2022 12:23:38 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, prudo@redhat.com,
        dyoung@redhat.com, bhe@redhat.com, sensor1010@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-crash_corec-remove-redundant-check-of-ck_cmdline.patch removed from -mm tree
Message-Id: <20220513192339.4872AC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/crash_core.c: remove redundant check of ck_cmdline
has been removed from the -mm tree.  Its filename was
     kernel-crash_corec-remove-redundant-check-of-ck_cmdline.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: lizhe <sensor1010@163.com>
Subject: kernel/crash_core.c: remove redundant check of ck_cmdline

At the end of get_last_crashkernel(), the judgement of ck_cmdline is
obviously unnecessary and causes redundance, let's clean it up.

Link: https://lkml.kernel.org/r/20220506104116.259323-1-sensor1010@163.com
Signed-off-by: lizhe <sensor1010@163.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Philipp Rudo <prudo@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/crash_core.c~kernel-crash_corec-remove-redundant-check-of-ck_cmdline
+++ a/kernel/crash_core.c
@@ -222,9 +222,6 @@ next:
 		p = strstr(p+1, name);
 	}
 
-	if (!ck_cmdline)
-		return NULL;
-
 	return ck_cmdline;
 }
 
_

Patches currently in -mm which might be from sensor1010@163.com are


